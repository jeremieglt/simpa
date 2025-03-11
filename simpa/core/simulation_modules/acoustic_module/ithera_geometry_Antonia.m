function [sensor_mask,sensor_value,m_phi,m_theta,sensor_cart_coord,sensor_el_mat]=ithera_geometry_Antonia(dx,dy,dz,Nx,Ny,Nz,num_el,cov)

%% setup  detector
% detector parameters
r_sensor = 0.0405; %detector radius


coverage = cov; %angular coveragwe in degress

elementstep = coverage/360*2*pi/num_el; %angular step in rad
firstelement = (180-coverage)/2/360*2*pi + (coverage/360*2*pi/num_el/2); % first angle in rad
angle_sensor = (firstelement:elementstep:firstelement+(num_el-1)*elementstep)-pi/2; %vector the detector angles
gap=0.1e-3; %gap between elements

size_azimuith=(r_sensor*pi*coverage/180)/num_el-gap; %element width

size_elevation=15e-3; %size in elevation


Rcurve=0.04; %element curvature
delta_theta=((size_azimuith-gap)/(2*pi*Rcurve))*2*pi; %angle step azimuth
delta_phi=2*asin(size_elevation/(2*Rcurve)); %angle step elevation


m_scale=1;
% el_res=(4*0.05*2/(512-1));
el_res=dz;
m_phi=round(m_scale*size_elevation/el_res); %number of sampling elements elevation
% el_res=(0.05*2/(512-1));
el_res=dx;
m_theta=ceil(size_azimuith/el_res); %number of sampling elements azimuth

% detector element center positions
pos_elements_arc_sph=zeros(num_el,3);
pos_elements_arc_sph(:,2)=angle_sensor;
pos_elements_arc_sph(:,3)=ones(num_el,1)*r_sensor;
pos_elements_arc=zeros(size(pos_elements_arc_sph));
[pos_elements_arc(:,1),pos_elements_arc(:,3),pos_elements_arc(:,2)]=sph2cart(pos_elements_arc_sph(:,1),pos_elements_arc_sph(:,2),pos_elements_arc_sph(:,3));

% detector element sampling positions
angle_sensor_xz=linspace(-delta_theta/2,delta_theta/2,m_theta);
angle_sensor_xy=linspace(-delta_phi/2,delta_phi/2,m_phi);
[Ang_xy0,Ang_xz0] = meshgrid(angle_sensor_xy,angle_sensor_xz);
n_proj_tot = length(Ang_xy0(:));
Ang_xy_mat=zeros(numel(Ang_xy0),num_el); 
Ang_xz_mat=zeros(numel(Ang_xz0),num_el);
% sensor_el_mat=zeros(m_theta*m_phi,3,num_el);
sensor_el_mat=zeros(3,m_theta*m_phi,num_el);


X=0;
Y=0;
Z=0;

for i=[1:num_el]
    Ang_xz=Ang_xz0+angle_sensor(i);
    Ang_xy=Ang_xy0;  
    Ang_xz_mat(:,i)=Ang_xz(:);
    Ang_xy_mat(:,i)=Ang_xy(:);
    sensor_el_mat(1,:,i) = r_sensor.*cos(Ang_xy(:)).*cos(Ang_xz(:)); % position of the detection points in the x direction
    sensor_el_mat(2,:,i) = r_sensor.*cos(Ang_xy(:)).*sin(Ang_xz(:)); % position of the detection points in the y direction
    sensor_el_mat(3,:,i) = r_sensor.*sin(Ang_xy(:)); % position of the detection points in the z direction
    
    X=[X,sensor_el_mat(1,:,i)];
    Y=[Y,sensor_el_mat(2,:,i)];
    Z=[Z,sensor_el_mat(3,:,i)];
 
end
sensor_cart_coord=[X;Y;Z];


% figure;
% plot3(0,0,0,'r*');
% hold
% for i=1:num_el
%     if rem(i, 2) == 0
%             plot3(sensor_el_mat(1,:,i),sensor_el_mat(2,:,i),sensor_el_mat(3,:,i),'.','Color',[0.9,0.9,0.9]);
% 
%     else
%             plot3(sensor_el_mat(1,:,i),sensor_el_mat(2,:,i),sensor_el_mat(3,:,i),'.','Color',[0.3,0.3,0.3]);
% 
%     end
% end
% hold
% axis image,grid on,xlabel('x'),ylabel('y'),zlabel('z')
% hold on
% 
% 
% 
% x=[-0.0125:0.0005:0.0125];
% y=x;


% for i=1:length(x)
%     for j=1:1:length(y)
%     plot3(x(i),y(j),0,'b.');
%     plot3(x(i),y(j),0.007,'g.');
%     plot3(x(i),y(j),-0.007,'g.');
%     end
% end





middle_x=round(Nx/2);
middle_y=round(Ny/2);
middle_z=round(Nz/2);





sensor_mask=zeros(Nx,Ny,Nz);
sensor_value=zeros(Nx,Ny,Nz);




for i=1:num_el
    for j=1:m_theta*m_phi
        x_pos = middle_x+round(sensor_el_mat(1,j,i)/dx);
        y_pos = middle_y+round(sensor_el_mat(2,j,i)/dy);
        z_pos = middle_z+round(sensor_el_mat(3,j,i)/dz);
    
        sensor_value(x_pos,y_pos,z_pos)=i;
        sensor_mask(x_pos,y_pos,z_pos)=1;
    end
end

% Transpose to correspond to SIMPA coordinates
sensor_mask = permute(sensor_mask, [2,3,1]);
sensor_value = permute(sensor_value, [2,3,1]);

end
