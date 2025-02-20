%%SPDX-FileCopyrightText: 2021 Division of Intelligent Medical Systems, DKFZ
%%SPDX-FileCopyrightText: 2021 Janek Groehl
%%SPDX-License-Identifier: MIT

function [] = simulate_3D_modified(optical_path)

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

% add 2 pixel "gel" to reduce Fourier artifact
GEL_LAYER_HEIGHT = 3;

%source.p0 = padarray(source.p0, [GEL_LAYER_HEIGHT 0], 0, 'pre');
[Nx, Ny, Nz] = size(source.p0);
if isfield(settings, 'sample') == true
    if settings.sample == true
        dx = double(settings.voxel_spacing_mm)/(double(settings.upscale_factor) * 1000);
    else
        dx = double(settings.voxel_spacing_mm)/1000;    % convert from mm to m
    end
else
    dx = double(settings.voxel_spacing_mm)/1000;    % convert from mm to m
end
kgrid = kWaveGrid(Nx, dx, Ny, dx, Nz, dx);

%% Define medium

% if a field of the struct "data" is given which describes the sound speed, the array is loaded and is used as medium.sound_speed
if isfield(data, 'sos') == true
    medium.sound_speed = data.sos;
    % add 2 pixel "gel" to reduce Fourier artifact
%    medium.sound_speed = padarray(medium.sound_speed, [GEL_LAYER_HEIGHT 0], 'replicate', 'pre');
else
    medium.sound_speed = 1540;
end

% if a field of the struct "data" is given which describes the attenuation, the array is loaded and is used as medium.alpha_coeff
if isfield(data, 'alpha_coeff') == true
 medium.alpha_coeff = data.alpha_coeff;
 % add 2 pixel "gel" to reduce Fourier artifact
% medium.alpha_coeff = padarray(medium.alpha_coeff, [GEL_LAYER_HEIGHT 0], 'replicate', 'pre');
else
 medium.alpha_coeff = 0.01;
end

medium.alpha_power = double(settings.medium_alpha_power); % b for a * MHz ^ b
medium.alpha_mode = 'no_dispersion';

% if a field of the struct "data" is given which describes the density, the array is loaded and is used as medium.density
if isfield(data, 'density') == true
    medium.density = data.density;
    % add 2 pixel "gel" to reduce Fourier artifact
%    medium.density = padarray(medium.density, [GEL_LAYER_HEIGHT 0], 'replicate', 'pre');
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
n_elem = size(data.sensor_element_positions);

% assign binary mask from iThera geometry to the sensor
[sensor.mask, ~, ~, ~, ~, ~] = ithera_geometry_modified(dx, dx, dx, Nz*dx, Nx, Ny, Nz, n_elem, 125, true);

% model sensor frequency response
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
    time_series_data = kspaceFirstOrder3DG(kgrid, medium, source, sensor, input_args{:});
    time_series_data = gather(time_series_data);
else
    time_series_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});
end

% combine data to give one trace per physical array element
time_series_data = karray.combineSensorData(kgrid, time_series_data);

%% Write data to mat array
save(optical_path, 'time_series_data')%, '-v7.3')
time_step = kgrid.dt;
number_time_steps = kgrid.Nt;
save(strcat(optical_path, 'dt.mat'), 'time_step', 'number_time_steps');

end