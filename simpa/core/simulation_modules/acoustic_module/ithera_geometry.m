function [sensor_mask, sensor_value, m_phi, m_theta, sensor_cart_coord, sensor_elem_mat] = ithera_geometry(dx, dy, dz, grid_dim_y, Nx, Ny, Nz, num_el, coverage, grid3D)

%% Setup  detector

% Detector properties
r_sensor = 0.0405; %[m], detector array radius
R_curve = 0.04; %[m], detector element curvature

% Computation of the angles facing the sensor array (in the x-z plane)
step = (coverage / num_el) * (pi / 180) ; %[rad], angular step in detector plane
first_elem = ((180 - coverage) / 2) * (pi / 180) + step / 2; %[rad], first detector angle
last_elem = first_elem + (num_el - 1) * step; %[rad], last detector angle
sensor_angles = (first_elem : step : last_elem) - pi / 2; %[rad], vector of detector angles
gap = 1e-4; %[m], gap between elements
elem_width = r_sensor * step - gap; %[m], element width in y
delta_theta = (elem_width / (2 * pi * R_curve)) * 2 * pi; %[rad], angle step theta
m_theta = ceil(elem_width / dx); % number of sampling points per element theta

% Definition of the length needed in the y direction
elem_length = 13e-3; %[m], y direction
if grid3D
    length_y = min(elem_length, grid_dim_y - 2 * dy); %[m]
    % size in y direction, equals "iThera_sensor_elevation", and is smaller if the grid dimension along y is not enough
else
    length_y = dy; %[m], size in y direction equals 1 in the 2D case
end
delta_phi = 2 * asin(length_y / (2 * R_curve)); %[rad], angle step elevation
m_phi = round(length_y / dy); % number of sampling points per element phi

% Detector element center positions : phi = azimuth, theta = elevation
pos_elem_arc_sph = zeros(num_el, 3); % column 1 is unchanged, the center element is at phi = 0
pos_elem_arc_sph(:, 2) = sensor_angles; %[rad], theta
pos_elem_arc_sph(:, 3) = ones(num_el, 1) * r_sensor; %[m] r
pos_elem_arc = zeros(size(pos_elem_arc_sph));
[pos_elem_arc(:, 1), pos_elem_arc(:, 2), pos_elem_arc(:, 3)] = sph2cart(pos_elem_arc_sph(:, 1), pos_elem_arc_sph(:, 2), pos_elem_arc_sph(:, 3));

% Detector element sampling positions
angle_sensor_theta = linspace(-delta_theta/2, delta_theta/2, m_theta);
angle_sensor_phi = linspace(-delta_phi/2, delta_phi/2, m_phi);
[Ang_theta_0, Ang_phi_0] = meshgrid(angle_sensor_theta, angle_sensor_phi);
Ang_theta_mat = zeros(numel(Ang_theta_0), num_el);
Ang_phi_mat = zeros(numel(Ang_phi_0), num_el);
sensor_elem_mat = zeros(3, m_theta * m_phi, num_el);

% Computing position of detector points
% CAREFUL : not the same coordinates as our setup, follows sph2cart
X = 0;
Y = 0;
Z = 0;

for i = 1:num_el

    Ang_theta = Ang_theta_0 + sensor_angles(i);
    Ang_phi = Ang_phi_0;
    Ang_theta_mat(:, i) = Ang_theta(:);
    Ang_phi_mat(:, i) = Ang_phi(:);
    sensor_elem_mat(1, :, i) = r_sensor .* cos(Ang_theta(:)) .* cos(Ang_phi(:)); % position of the detection points in the z direction
    % order : coord (x, y or z), point on the element, element
    sensor_elem_mat(2, :, i) = r_sensor .* cos(Ang_theta(:)) .* sin(Ang_phi(:)); % position of the detection points in the y direction
    sensor_elem_mat(3, :, i) = r_sensor .* sin(Ang_theta(:)); % position of the detection points in the x direction
    
    X = [X, sensor_elem_mat(1, :, i)];
    Y = [Y, sensor_elem_mat(2, :, i)];
    Z = [Z, sensor_elem_mat(3, :, i)];
    
end

% Changing order
sensor_cart_coord = [X;Y;Z]; % exchanging Z and X

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

% Transpose to correspond to SIMPA coordinates
sensor_mask = permute(sensor_mask, [2,3,1]);
sensor_value = permute(sensor_value, [2,3,1]);