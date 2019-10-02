function [vol_handle,FV]=VoxelPlotter(VoxelMat,Vox_Size)
%detect the external voxels and faces
vol_handle=0;
if nargin==1
Vox_Size=1;
end
    FV=FindExternalVoxels(VoxelMat,Vox_Size);
%plot only external faces of external voxels
cla;
if size(FV.vertices,1)==0
    cla;
else
%patch voxel 
vol_handle=patch(FV,'FaceColor','r');
end
end