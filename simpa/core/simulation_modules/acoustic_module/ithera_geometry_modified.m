function [sensor_mask, sensor_value, m_phi, m_theta, sensor_cart_coord, sensor_elem_mat] = ithera_geometry_modified(dx, dy, dz, grid_dim_z_m, Nx, Ny, Nz, num_el, coverage, grid3D)

%% Definition of the kWave sensor

karray = kWaveArray;

%% Setup  detector

% Detector parameters
r_sensor = 0.0405; %[m], detector radius
iThera_sensor_elevation = 13e-3; %[m]

elem_step = coverage / 360 * 2 * pi / num_el; %[rad], angular step 
angle_first_elem = (180 - coverage) / 2 / 360 * 2 * pi + elem_step / 2; %[rad], first angle
angle_last_elem = angle_first_elem + (num_el - 1) * elem_step; %[rad], last angle
angle_sensor = (angle_first_elem : elem_step : angle_last_elem) - pi / 2; % vector of detector angles
gap = 1e-4; % gap between elements

size_azimuth = (r_sensor * pi * coverage / 180) / num_el - gap; % element width
if grid3D
    sensor_elevation = min(iThera_sensor_elevation, grid_dim_z_m - 2 * dz); % size in elevation, equals "iThera_sensor_elevation", and is smaller if the grid dimension along z is not enough
else
    sensor_elevation = dz; % size in elevation equals 1 in the 2D case
end

R_curve = 0.040; %[m], element curvature
delta_theta = ((size_azimuth - gap) / (2 * pi * R_curve)) * 2 * pi; % angle step azimuth
delta_phi = 2 * asin(sensor_elevation / (2 * R_curve)); % angle step elevation

m_scale = 1;
m_phi = round(m_scale * sensor_elevation / dz); % number of sampling points per element elevation
m_theta = ceil(size_azimuth / dx); % number of sampling points per element azimuth

% Detector element center positions
pos_elem_arc_sph = zeros(num_el, 3); % azimuth = 0
pos_elem_arc_sph(:, 2) = angle_sensor; % elevation 
pos_elem_arc_sph(:, 3) = ones(num_el, 1) * r_sensor; % r
pos_elem_arc = zeros(size(pos_elem_arc_sph));
[pos_elem_arc(:, 1), pos_elem_arc(:, 3), pos_elem_arc(:, 2)] = sph2cart(pos_elem_arc_sph(:, 1), pos_elem_arc_sph(:, 2), pos_elem_arc_sph(:, 3));

% Detector element sampling positions
angle_sensor_xy = linspace(-delta_theta/2, delta_theta/2, m_theta);
angle_sensor_xz = linspace(-delta_phi/2, delta_phi/2, m_phi);
[Ang_xy0, Ang_xz0] = meshgrid(angle_sensor_xy, angle_sensor_xz);
Ang_xy_mat = zeros(numel(Ang_xy0), num_el);
Ang_xz_mat = zeros(numel(Ang_xz0), num_el);
sensor_elem_mat = zeros(3, m_theta * m_phi, num_el);

X = 0;
Y = 0;
Z = 0;

for i = 1:num_el
    Ang_xy = Ang_xy0 + angle_sensor(i);
    Ang_xz = Ang_xz0;
    Ang_xy_mat(:, i) = Ang_xy(:);
    Ang_xz_mat(:, i) = Ang_xz(:);
    sensor_elem_mat(1, :, i) = r_sensor .* cos(Ang_xy(:)) .* cos(Ang_xz(:)); % position of the detection points in the x direction
    sensor_elem_mat(2, :, i) = r_sensor .* sin(Ang_xy(:)) .* cos(Ang_xz(:)); % position of the detection points in the y direction
    sensor_elem_mat(3, :, i) = r_sensor .* sin(Ang_xz(:)); % position of the detection points in the z direction
    
    X = [X, sensor_elem_mat(1, :, i)];
    Y = [Y, sensor_elem_mat(2, :, i)];
    Z = [Z, sensor_elem_mat(3, :, i)];
    
end
sensor_cart_coord = [X;Y;Z];

middle_x = Nx / 2;
middle_y = Ny / 2;
middle_z = Nz / 2;

sensor_mask = zeros(Nx, Ny, Nz);
sensor_value = zeros(Nx, Ny, Nz);

for i = 1:num_el
    for j = 1:m_theta*m_phi
        x_pos = round(middle_x + sensor_elem_mat(1, j, i) / dx);
        y_pos = round(middle_y + sensor_elem_mat(2, j, i) / dy);
        z_pos = round(middle_z + sensor_elem_mat(3, j, i) / dz);
        if grid3D
            sensor_value(x_pos, y_pos, z_pos) = i;
            sensor_mask(x_pos, y_pos, z_pos) = 1;
        else
            sensor_value(x_pos, y_pos) = i;
            sensor_mask(x_pos, y_pos) = 1;
        end
        
    end
end