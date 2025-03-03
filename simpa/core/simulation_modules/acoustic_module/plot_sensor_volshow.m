function [] = plot_sensor_volshow()

dx = 1e-4; %[m]
dy = 1e-4; %[m]
dz = 1e-4; %[m]
grid_dim_y = 15e-3; %[m]
Nx = 800;
Ny = 800;
Nz = 800;
num_el = 256;
coverage = 125; %[°]
grid_3D = true;
center_arc = [0, 0, 0];
[~, sensor_value, ~, ~, ~, ~] = ithera_geometry(dx, dy, dz, grid_dim_y, Nx, Ny, Nz, num_el, coverage, grid_3D, center_arc, rotation_angles);

volshow(sensor_value);

end