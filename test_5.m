load example_us_bmode_scan_lines.mat
echoModel= scan_lines;
[imageOut, rfEnvelope] = fcnPseudoBmodeUltrasoundSimulator(echoModel);

figure, 
imshow(imageOut);
