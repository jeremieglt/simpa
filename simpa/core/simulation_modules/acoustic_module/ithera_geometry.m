function [sensor_mask, sensor_value, m_theta, m_phi, sensor_cart_coord, sensor_elem_mat] = ithera_geometry(dx, dy, dz, grid_dim_y, Nx, Ny, Nz, n_elem, coverage, center_of_rotation, grid_3D)
% CAREFUL : Would have to be reverified if different resolutions are chosen in x, y
% and z.

%% Setup  detector

% Detector properties
r_sensor = 0.04; %[m], detector array radius
R_curve = 0.04; %[m], detector element curvature

% Computation of the azimuth angles (phi)
step = (coverage / n_elem) * (pi / 180) ; %[rad], angular step in detector plane
first_elem = ((180 - coverage) / 2) * (pi / 180) + step / 2; %[rad], first detector angle
last_elem = first_elem + (n_elem - 1) * step; %[rad], last detector angle
sensor_angles = (first_elem : step : last_elem) - pi / 2; %[rad], vector of detector angles
gap = 1e-4; %[m], gap between elements
elem_width = r_sensor * step - gap; %[m], element width in y

delta_phi = ((elem_width - gap) / (2 * pi * R_curve)) * 2 * pi; %[rad], angle step phi
m_phi = ceil(elem_width / dx); % number of sampling points per element phi

% Computation of the elevation angles (theta)
elem_length = 13e-3; %[m], y direction

if grid_3D
    length_y = min(elem_length, grid_dim_y - 2 * dy); %[m]
    % size in y direction, equals "iThera_sensor_elevation", and is smaller if the grid dimension along y is not enough
else
    length_y = dy; %[m], size in y direction equals 1 in the 2D case
end

delta_theta = 2 * asin(length_y / (2 * R_curve)); %[rad], angle step elevation
m_theta = round(length_y / dy); % number of sampling points per element theta

% Detector element center positions : theta = azimuth, phi = elevation
pos_elem_arc_sph = zeros(n_elem, 3); % column 1 is unchanged, the center element is at theta = 0
pos_elem_arc_sph(:, 2) = sensor_angles; %[rad], phi
pos_elem_arc_sph(:, 3) = ones(n_elem, 1) * r_sensor; %[m] r
pos_elem_arc = zeros(size(pos_elem_arc_sph));
% sending positions in our coordinate system
[pos_elem_arc(:, 2), pos_elem_arc(:, 3), pos_elem_arc(:, 1)] = sph2cart(pos_elem_arc_sph(:, 1), pos_elem_arc_sph(:, 2), pos_elem_arc_sph(:, 3));

% Detector element sampling positions
angle_sensor_phi = linspace(-delta_phi/2, delta_phi/2, m_phi);
angle_sensor_theta = linspace(-delta_theta/2, delta_theta/2, m_theta);
[Ang_phi_0, Ang_theta_0] = meshgrid(angle_sensor_phi, angle_sensor_theta);
Ang_phi_mat = zeros(numel(Ang_phi_0), n_elem);
Ang_theta_mat = zeros(numel(Ang_theta_0), n_elem);
sensor_elem_mat = zeros(3, m_phi * m_theta, n_elem);

% Computing position of detector points
% CAREFUL : not the same coordinates as our setup, follows sph2cart
X = 0;
Y = 0;
Z = 0;

for i = 1:n_elem

    Ang_phi = Ang_phi_0 + sensor_angles(i);
    Ang_theta = Ang_theta_0;
    Ang_phi_mat(:, i) = Ang_phi(:);
    Ang_theta_mat(:, i) = Ang_theta(:);
    sensor_elem_mat(1, :, i) = r_sensor .* cos(Ang_theta(:)) .* sin(Ang_phi(:)); % position of the detection points in the x direction
    sensor_elem_mat(2, :, i) = r_sensor .* sin(Ang_theta(:)); % position of the detection points in the y direction
    sensor_elem_mat(3, :, i) = r_sensor .* cos(Ang_theta(:)) .* cos(Ang_phi(:)); % position of the detection points in the z direction
    % order : coord (x, y or z), point on the element, element
    
    X = [X, sensor_elem_mat(1, :, i)];
    Y = [Y, sensor_elem_mat(2, :, i)];
    Z = [Z, sensor_elem_mat(3, :, i)]; % order reversed in kWave
    
end

% Changing order
sensor_cart_coord = [X;Y;Z];

sensor_mask = zeros(Nx, Ny, Nz);
sensor_value = zeros(Nx, Ny, Nz);

for i = 1:n_elem
    for j = 1:m_phi*m_theta % FLOOR HERE INSTEAD OF ROUND ????????
        x_pos = round((center_of_rotation(1) - sensor_elem_mat(3, j, i)) / dz); % not the same coord systems as in kWave
        y_pos = round((center_of_rotation(2) + sensor_elem_mat(2, j, i)) / dy);
        z_pos = round((center_of_rotation(3) + sensor_elem_mat(1, j, i)) / dx);
        if grid_3D
            sensor_value(x_pos, y_pos, z_pos) = n_elem - i + 1; % corresponding to kWave numerotation
            sensor_mask(x_pos, y_pos, z_pos) = 1;
        else
            sensor_value(x_pos, y_pos) = n_elem - i + 1; % corresponding to kWave numerotation
            sensor_mask(x_pos, y_pos) = 1;
        end
    end
end


end