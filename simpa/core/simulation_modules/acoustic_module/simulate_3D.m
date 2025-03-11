%%SPDX-FileCopyrightText: 2021 Division of Intelligent Medical Systems, DKFZ
%%SPDX-FileCopyrightText: 2021 Janek Groehl
%%SPDX-License-Identifier: MIT

function [] = simulate_3D(optical_path)

%% In case of an error, make sure the matlab scripts exits anyway
clean_up = onCleanup(@exit);

%% Read settings file

data = load(optical_path);
settings = data.settings;

%% Read initial pressure

source.p0 = data.initial_pressure;

% Choose if the initial pressure should be smoothed before simulation
if isfield(settings, 'initial_pressure_smoothing') == true
    p0_smoothing = settings.initial_pressure_smoothing;
else
    p0_smoothing = true;
end

%% Define kWaveGrid

[Nx, Ny, Nz] = size(source.p0);

if isfield(settings, 'sample') == true
    if settings.sample == true
        dx = double(settings.voxel_spacing_mm)/(double(settings.upscale_factor) * 1000);
    else
        dx = double(settings.voxel_spacing_mm)/1000; % convert from mm to m
    end
else
    dx = double(settings.voxel_spacing_mm)/1000; % convert from mm to m
end

kgrid = kWaveGrid(Nx, dx, Ny, dx, Nz, dx);

%% Define medium

% if a field of the struct "data" is given which describes the sound speed, the array is loaded and is used as medium.sound_speed
if isfield(data, 'sos') == true
    medium.sound_speed = data.sos;
else
    medium.sound_speed = 1540;
end

% if a field of the struct "data" is given which describes the attenuation, the array is loaded and is used as medium.alpha_coeff
if isfield(data, 'alpha_coeff') == true
    medium.alpha_coeff = data.alpha_coeff;
else
    medium.alpha_coeff = 0.01;
end

medium.alpha_power = double(settings.medium_alpha_power); % b for a * MHz ^ b
medium.alpha_mode = 'no_dispersion';

% if a field of the struct "data" is given which describes the density, the array is loaded and is used as medium.density
if isfield(data, 'density') == true
    medium.density = data.density;
else
    medium.density = 1000*ones(Nx, Ny, Nz);
end

%% Sampling rate

% load sampling rate from settings
dt = 1.0 / double(settings.sensor_sampling_rate_mhz * 1000000);

% Simulate as many time steps as a wave takes to traverse diagonally through the entire tissue
Nt = round((sqrt(Ny*Ny+Nx*Nx+Nz*Nz)*dx / mean(medium.sound_speed, 'all')) / dt);

estimated_cfl_number = dt / dx * mean(medium.sound_speed, 'all');

% smaller time steps are better for numerical stability in time progressing simulations
% A minimum CFL of 0.3 is advised in the kwave handbook.
% In case we specify something larger, we use a higher sampling rate than anticipated.
% Otherwise we simulate with the target sampling rate
if estimated_cfl_number < 0.3
    kgrid.setTime(Nt, dt);
else
    kgrid.t_array = makeTime(kgrid, medium.sound_speed, 0.3);
end

%% Define sensor

% Definition of the parameters required for the use of our own sensor
elem_pos = data.sensor_element_positions * 1e-3;

size_sensor_elem_pos = size(elem_pos);
n_elem = size_sensor_elem_pos(2);

if isfield(settings, 'sensor_radius_mm') == true
    sensor_radius = double(settings.sensor_radius_mm) * 1e-3;
else
    sensor_radius = 40e-3;
end

center_of_rotation = (elem_pos(:, 128) + elem_pos(:, 129)) / 2 + [sensor_radius, 0, 0]';
angular_coverage = 128; % [°]
grid_3D = true;

% Assign binary mask from iThera geometry to the sensor
[sensor.mask, sensor_value, ~, ~, ~, ~] = ithera_geometry(dx, dx, dx, Ny*dx, Nx, Ny, Nz, n_elem, angular_coverage, center_of_rotation, grid_3D);

% Model sensor frequency response
if isfield(settings, 'model_sensor_frequency_response') == true
    if settings.model_sensor_frequency_response == true
        center_freq = double(settings.sensor_center_frequency); % [Hz]
        bandwidth = double(settings.sensor_bandwidth); % [%]
        sensor.frequency_response = [center_freq, bandwidth];
    end
end

%% Computation settings

if settings.gpu == true
    datacast = 'gpuArray-single';
else
    datacast = 'single';
end

input_args = {'DataCast', datacast, 'PMLInside', settings.pml_inside, ...
              'PMLAlpha', double(settings.pml_alpha), 'PMLSize', 'auto', ...
              'PlotPML', settings.plot_pml, 'RecordMovie', settings.record_movie, ...
              'MovieName', settings.movie_name, 'PlotScale', [-1, 1], 'LogScale', settings.acoustic_log_scale, ...
              'Smooth', p0_smoothing};

if settings.gpu == true
    point_time_series_data = kspaceFirstOrder3DG(kgrid, medium, source, sensor, input_args{:});
    point_time_series_data = gather(point_time_series_data);
else
    point_time_series_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});
end

%% Manual calculations on sinograms due to the addition of a handmade sensor

% Number of time samples acquired for each point
temporal_dim = size(point_time_series_data, 2);

% Finding the indexes of the physical points for each element
% the found indexs and coords are stored in a cell, because the number of points found per element varies
sensor_points_idx = cell(n_elem, 1); 
sensor_points_coord = cell(n_elem, 1);

for sensor_idx = 1:n_elem
    found_idxs = find(sensor_value == sensor_idx);
    [x, y, z] = ind2sub(size(sensor_value), find(sensor_value == sensor_idx)); % coord of sensors in SIMPA coords
    sensor_points_idx{sensor_idx} = found_idxs';
    sensor_points_coord{sensor_idx} = [x'; y'; z'];
end

max_length = max(cellfun(@length, sensor_points_idx));
% filling the array with zeros to have a unique line width
sensor_points_padded = cellfun(@(x) [x, zeros(1, max_length - length(x))], sensor_points_idx, 'UniformOutput', false); 
% transforming to matrix for processing
sensor_points_mat = cell2mat(sensor_points_padded');
% renumbering the sensors to correspond to time series data
[~, ~, sensor_points_renum_vec] = unique(sensor_points_mat(:), 'sorted'); 
% accounting for the artificial numerotation of the 0s in the numerotation
sensor_points_renum_vec = sensor_points_renum_vec - 1;
% reshaping and retransforming to a cell
sensor_points_reshaped = reshape(sensor_points_renum_vec, max_length, n_elem)'; 
sensor_points_cell = arrayfun(@(i) nonzeros(sensor_points_reshaped(i, :))', (1:n_elem)', 'UniformOutput', false);

% Filling time series data
time_series_data = zeros(n_elem, temporal_dim);

for sensor_idx = 1:n_elem

    sensor_pts = sensor_points_cell{sensor_idx}';
    sensor_signals = point_time_series_data(sensor_pts(:, 1), :);
    % the values for one element are the average values of the points of this element
    time_series_data(sensor_idx, :) = mean(sensor_signals, 1);

end

%% Write data to mat array
save(optical_path, 'time_series_data');
time_step = kgrid.dt;
number_time_steps = kgrid.Nt;
save(strcat(optical_path, 'dt.mat'), 'time_step', 'number_time_steps');

end