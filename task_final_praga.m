close all ; 
clear all ; 
clc; 
%%author - Praga
%%process time - 13 sec (without thresholding) 
%%             - 1 minute (with thresolding)
%%%%%%%%  Task 1  %%%%%%%%%%%%%%%%%%%%%%%
%%the conditions for R %%%%%%%%%%%%%%%%%%

%% 1) tan(theta/2) > R/Yp
%% 2) Yus*cos(theta/2) > 2R
%% 3) Xus*cos(theta/2) > 2R
%% 4) Yus - Yp > R
%% 5) Xus > 2R
%%

%%%%%%% Task 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%defining all the variables%%%%%%%%

FOV=120;             %degree
theta=(pi*2)/180;    %radian 
R=2;                 %cm
Yp=6;                %cm
Xus=10;              %cm
Yus=10;              %cm
Sx=0.1;              %cm
Sy=0.1;              %cm
num_pixel=Xus/Sx;  %done only for X as both are equal

%%to get the main image over here
[im_main]=createmainimage(Xus,R,theta,num_pixel);

%%%%%%%%% Task 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%creation and visualization of the empty voxel%%%
VoxelMat=zeros(num_pixel,num_pixel,num_pixel);

for i=1:num_pixel
    for j=1:num_pixel
        for k=1:num_pixel
            if (i-num_pixel/2)^2+(j-num_pixel/2)^2+(k-num_pixel/2)^2<(R/Sx)^2
                VoxelMat(i,j,k)=255;
            end
            
        end
    end
end

%view of voxels
[vol_handle,FV]=VoxelPlotter(VoxelMat,1); 
view(3);
daspect([1,1,1]);
set(gca,'xlim',[0 num_pixel], 'ylim',[0 num_pixel], 'zlim',[0 num_pixel]);
title('actual sphere in Voxels without the reconstruction algorithem');
xlabel('X');ylabel('Y');zlabel('Z');

%push of taken image back into a 3D array as reconstruction 
%reconstruction view will be differnt as it makes coding easy
%rotating the reconstructed matrix by 90 degrees will give the original
%will be working with X and Z axis 

%%nearest neighbour voxel mapping

array_recon=zeros(num_pixel,num_pixel,num_pixel);
angle_1=-pi/3:theta:pi/3; %in radians

%special case handled first .......
%array_recon(:,:,num_pixel/2)=im_main(:,:,31);

%delete the angle zero from array 
%angle_1= angle_1([1:30, 32:end]);

for k=1:size(angle_1,2)
    %rotation matrix with respect to y axis 
    %Rot = [cos(angle(k)) 0 sin(angle(k));0 1 0;-sin(angle(k)) 0 cos(angle(k))];
    x=size(im_main,1);
    y=size(im_main,2);
    
    for i =1:1:x
        for j=1:1:y
            new_cord=rotx(angle_1(k)*180/pi)*[i,j,0]';
            new_cord(3)=new_cord(3)+50;
            new_cord=ceil(new_cord);
            if new_cord(3)>0
                array_recon(new_cord(1),new_cord(2),new_cord(3))=im_main(i,j,k);
                array_recon=uint8(array_recon);
            end
            
        end
    end    
end

%%print voxel after nearest neighbour map
figure;
[array_recon_1]=VoxelPlotter(array_recon,1); 
view(3);
daspect([1,1,1]);
set(gca,'xlim',[0 num_pixel], 'ylim',[0 num_pixel], 'zlim',[0 num_pixel]);
title('Voxels without the interpolation');
xlabel('X');ylabel('Y');zlabel('Z');

%%%%%bilinear interpolation %%%%%%%%%%%%
zoomed=zeros(size(array_recon));
%%%bilinear interpolation  
for j=1:size(array_recon,3)
    zoomed(:,:,j)=bilinear( array_recon(:,:,j) );
end

figure;
[zoomed_1]=VoxelPlotter(zoomed,1); 
view(3);
daspect([1,1,1]);
set(gca,'xlim',[0 num_pixel], 'ylim',[0 num_pixel], 'zlim',[0 num_pixel]);
title('Voxels after bilinear interpolation');
xlabel('X');ylabel('Y');zlabel('Z');

%%%%%%%safe images after reconstruction %%%%%%%%%
mkdir('final3Dimagesafterrecon');
cd('final3Dimagesafterrecon');
%save the image
image_index=1;

for i=1:100
    filename = 'p%d.bmp';
    filename = sprintf(filename,image_index);
    image_index = image_index + 1;
    imwrite(zoomed(:,:,i),filename);
end
