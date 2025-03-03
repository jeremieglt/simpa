%% Initialization

dx = 1e-4;
grid_dim_y = 15e-3;
Nx = 750;
Ny = 150;
Nz = 800;
n_elem = 256;
coverage = 125;
center_of_rotation = [51.2e-3, Ny/2*dx, Nx/2*dx];
grid_3D = true;

[sensor_mask, sensor_value, m_theta, m_phi, sensor_cart_coord, sensor_elem_mat] = ...
    ithera_geometry(dx, dx, dx, grid_dim_y, Nx, Ny, Nz, n_elem, coverage, center_of_rotation, grid_3D);

%% Plotting the number of  points per array element

found_idxs = zeros(1, n_elem);

for sensor_idx = 1:n_elem
    found_idxs(sensor_idx) = sum(sensor_value(:) == (n_elem - sensor_idx + 1));
end

plot(found_idxs, '-o', 'LineWidth', 2);  % Line plot with markers
xlabel('Number of detector');
ylabel('Number of points');
title('Number of detector points per element');
grid on;