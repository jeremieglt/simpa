function [] = plot_sensor_plot3()

dx = 1e-4; %[m]
dy = 1e-4; %[m]
dz = 1e-4; %[m]
grid_dim_y = 13e-3; %[m]
Nx = 800;
Ny = 200;
Nz = 800;
num_el = 256;
coverage = 125; %[°]
grid_3D = true;
COR = [37.5, 7.5, 11.2004 + 40]*1e-3;

[sensor_mask, sensor_value, ~, ~, ~, sensor_elem_mat] = ithera_geometry(dx, dy, dz, grid_dim_y, Nx, Ny, Nz, num_el, coverage, COR, grid_3D);

figure;
plot3(0,0,0,'r*');
hold
for i=1:num_el
    if rem(i, 2) == 0
        plot3(sensor_elem_mat(1,:,i),sensor_elem_mat(2,:,i),sensor_elem_mat(3,:,i),'.','Color',[0.9,0.9,0.9]);
    else
        plot3(sensor_elem_mat(1,:,i),sensor_elem_mat(2,:,i),sensor_elem_mat(3,:,i),'.','Color',[0.3,0.3,0.3]);
    end
end
hold
axis image,grid on,xlabel('x'),ylabel('y'),zlabel('z')
hold on

% Get the indices where the mask is true (1)
[ix, iy, iz] = ind2sub(size(sensor_mask), find(sensor_mask));

figure;
plot3(ix, iy, iz, 'k.');
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Sensor mask visualization');
grid on;

% Get the indices where the sensor has a positive value (> 0)
[ix2, iy2, iz2] = ind2sub(size(sensor_value), find(sensor_value > 0));

figure;
plot3(ix2, iy2, iz2, 'k.');
axis equal;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Sensor value visualization');
grid on;
end

