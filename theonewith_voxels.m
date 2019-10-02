clear all; close all; clc;

gridesize=11;
% numbers are arbitrary
cube=zeros(11,11,11);
cube(3:9,3:9,3:9)=5; % Create a cube inside the region

% Boring: faces of the cube are a different color.
cube(3:9,3:9,3)=1;
cube(3:9,3:9,9)=1;
cube(3:9,3,3:9)=1;
cube(3:9,9,3:9)=1;
cube(3,3:9,3:9)=2;
cube(9,3:9,3:9)=1;

H=vol3d('Cdata',cube,'alpha',cube/5) %what is alpha?

figure;
[vol_handle]=VoxelPlotter(cube,0.5); %size of each voxel  
view(3);
daspect([1,1,1]);
set(gca,'xlim',[0 gridesize], 'ylim',[0 gridesize], 'zlim',[0 gridesize]);
xlabel('X');ylabel('Y');zlabel('Z');

%figure;
%plot3(cube(:,:,1),cube(:,1,:));

%connects surfaces with specified value

figure;
x = 1:11;
y = 1:11;
z = 1:11;
v = cube;
alpha=isosurface(x,y,z,v,1);
p = patch(isosurface(x,y,z,v,5));
isonormals(x,y,z,v,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';

daspect([1,1,1])
view(3); axis tight
camlight 
lighting gouraud
