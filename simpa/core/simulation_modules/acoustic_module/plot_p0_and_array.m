function[] = plot_p0_and_array()

data_p0 = load("C:\Users\jeremie.gillet\Desktop\p0_gt_5.mat");
data_sensor = load("C:\Users\jeremie.gillet\Desktop\sensor_mask_gt_5.mat");
data_sos = load("C:\Users\jeremie.gillet\Desktop\sos_gt_5.mat");

% whos data_p0
% whos data_sensor

% fieldnames(data_p0)

p0 = data_p0.p0;
sensor = data_sensor.sensor_mask;
sos = data_sos.sos;

% size(p0)
% size(sensor)
% size(sos)

%% Plot 2D

p0_middle = p0(:,58,:);
sensor_middle = sensor(:,58,:);
sos_middle = sos(:,58,:);

p0_middle = squeeze(p0_middle);
sensor_middle = squeeze(sensor_middle);
sos_middle = squeeze(sos_middle);

% size(p0_middle)
% size(sensor_middle)
% size(sos_middle)

% Normalisation des données pour les afficher en RGB
p0_norm = mat2gray(p0_middle);
sensor_norm = mat2gray(sensor_middle);
sos_norm = mat2gray(sos_middle);

% Création d'une image couleur (R = p0, G = sensor, B = sos)
rgb_image = cat(3, p0_norm, sensor_norm, sos_norm);

figure;
imshow(rgb_image);
title('p0 + sos + sensor mask');

% Ajout des axes
axis on;
xlabel('X (pixels)');
ylabel('Y (pixels)');

% % Showing only the sos
% figure;
% imagesc(sos_middle); % Affiche la matrice sous forme d'image colorée
% colormap(jet); % Applique une colormap (ex: jet, parula, hot, cool...)
% colorbar; % Ajoute une barre de couleur pour interpréter les valeurs

% Ajout des axes
% axis on;
% xlabel('X (pixels)');
% ylabel('Y (pixels)');

end