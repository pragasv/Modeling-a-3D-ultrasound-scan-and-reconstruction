%test - dicom image process =
close all; 
clear all ; 
clc ;


im=dicominfo('US-MONO2-8-8x-execho.dcm');
X=dicomread(im);
a=zeros(120,128,8);

for i=[1:8]
   a(:,:,i)=X(:,:,:,i); 
   figure,
   imshow(uint8(a(:,:,1)));
end
%a_1=X(:,:,:,1); %extraction of first image // the range to extract jst the image
%a_2=X(:,:,:,2); %extraction of the second image

%figure, 
%i=[1:8];
%montage(a(:,:,i)); 
%impixelinfo;