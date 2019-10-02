%test - dicom image process =
close all; 
clear all ; 
clc ;


m=dicominfo('bmode.dcm');
X=dicomread(im);
a_1=rgb2gray(X(29:568,235:790,:,1)); %extraction of first image // the range to extract jst the image
a_2=rgb2gray(X(29:568,235:790,:,2)); %extraction of the second image


figure, 
subplot(1,2,1);imshow(X(:,:,:,1));
subplot(1,2,2);imshow(X(:,:,:,2));
impixelinfo;

%figure, 
%i=[1:36];
%montage(X(29:568,235:790,:,i));

%detect feature points 
imagepoints1=detectSURFFeatures(a_1,'MetricThreshold',1000);
imagepoints2=detectSURFFeatures(a_2,'MetricThreshold',1000);

%extract feature discryptors
feature_1=extractFeatures(a_1,imagepoints1);
feature_2=extractFeatures(a_2,imagepoints2);

%plot the extracted features
figure;
subplot(1,2,1);
imshow(a_1);
hold on; 
plot(selectStrongest(imagepoints1,500));

subplot(1,2,2);
imshow(a_2);
hold on; 
plot(selectStrongest(imagepoints2,500));
title('extracted features on the image');


%MATCH EXTRACTED FEATURES
%indexPairs_1=matchFeatures(feature_1,feature_2,'maxRatio',0.9); 
%ommitted as too many outliers are produced


indexPairs_1=matchFeatures(feature_1,feature_2,'Unique',true);

matchedPoints1 = imagepoints1(indexPairs_1(:, 1));
matchedPoints2 = imagepoints2(indexPairs_1(:, 2));

figure; 
showMatchedFeatures(a_1,a_2,matchedPoints1,matchedPoints2);
title('features matched in the original image');


%outliers delete
c=[];
for z=1:422 
    if sumsqr(matchedPoints2(z).Location-matchedPoints1(z).Location)>10
       c=[c,z];
    end
end
matchedPoints1(c)=[];
matchedPoints2(c)=[];
  
figure; 
showMatchedFeatures(a_1,a_2,matchedPoints1,matchedPoints2);
title('features matched after deletion of outliers');

%create point cloud




