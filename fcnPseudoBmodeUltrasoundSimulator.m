function [imageOut, rfEnvelope] = fcnPseudoBmodeUltrasoundSimulator(echoModel,f0,c,sigma_x,sigma_y,speckleVariance)

% fcnPseudoBmodeUltrasoundSimulator generates a simulated Pseudo B-Mode
%   Ultrasound image given the echogenicity model for the structure to be
%   imaged.
%
%   OUTPUTIMAGE = fcnPseudoBmodeUltrasoundSimulator(ECHO_MODEL) generates
%   the simulated B-Mode Ultrasound image using default parameter settings.
%   The size of the simulated image is same as size of the echogenity
%   matrix provided. The OUTPUTIMAGE is of type uint8. Supported classes
%   for ECHO_MODEL are uint8, uint16, single, double.
%   
%   OUTPUTIMAGE = fcnPseudoBmodeUltrasoundSimulator(ECHO_MODEL, F_0, C,
%   SIGMA_X, SIGMA_Y, SPECKLE_VARIANCE) generates the simulated B-Mode
%   Ultrasound image using the specified parameters based on the ECHO_MODEL
%   provided.
%
%       F_0 - Center frequency of the ultrasonic wave. Default valus is 10e6
%       C - Velocity of sound in media (m/s). Default valus is 1540
%       SIGMA_X - Pulse-width of transmitting ultrasonic wave. Default
%       value is 2
%       SIGMA_Y - Beam-width) of transmitting ultrasonic wave. Default
%       value is 1.5
%       SPECKLE_VARIANCE - Variance of Speckle distribution of the media.
%       Default value is 0.01
%
%   [OUTPUTIMAGE, RF_ENVELOPE] = fcnBPDFHE(...) returns also the
%   rf Envelope matrix for further usage.
% 
%   Details of the method are available in
%
%   Yongjian Yu, Acton, S.T., "Speckle reducing anisotropic diffusion," 
%   IEEE Trans. Image Processing, vol. 11, no. 11, pp. 1260-1270, Nov 2002.
%   [http://dx.doi.org/10.1109/TIP.2002.804276]
%
%   J. C. Bambre and R. J. Dickinson, "Ultrasonic B-scanning: A computer
%   simulation", Phys. Med. Biol., vol. 25, no. 3, pp. 463479, 1980.
%   [http://dx.doi.org/10.1088/0031-9155/25/3/006]
%
%   2011 (c) Debdoot Sheet, Indian Institute of Technology Kharagpur, India
%       Ver 1.0   27 October 2011
%
% Example
% -------
% echoModel = imread('phantom.bmp');
% outputImage = fcnPseudoBmodeUltrasoundSimulator(echoModel);
% figure, subplot 121, imshow(echoModel,[]), subplot 122,
% imshow(outputImage);
%

% 2011 (c) Debdoot Sheet, Indian Institute of Technology Kharagpur, India
% All rights reserved.
% 
% Permission is hereby granted, without written agreement and without 
% license or royalty fees, to use, copy, modify, and distribute this code 
% (the source files) and its documentation for any purpose, provided that 
% the copyright notice in its entirety appear in all copies of this code, 
% and the original source of this code. Further Indian Institute of 
% Technology Kharagpur (IIT Kharagpur / IITKGP)  is acknowledged in any
% publication that reports research or any usage using this code. 
% 
% In no circumstantial cases or events the Indian Institute of Technology
% Kharagpur or the author(s) of this particular disclosure be liable to any
% party for direct, indirectm special, incidental, or consequential 
% damages if any arising out of due usage. Indian Institute of Technology 
% Kharagpur and the author(s) disclaim any warranty, including but not 
% limited to the implied warranties of merchantability and fitness for a 
% particular purpose. The disclosure is provided hereunder "as in" 
% voluntarily for community development and the contributing parties have 
% no obligation to provide maintenance, support, updates, enhancements, 
% or modification.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input argument support check
iptcheckinput(echoModel,{'uint8','uint16','single','double'}, {'nonsparse','2d'}, mfilename,'I',1);

if nargin == 1
    f0 = 10e6;
    c = 1540;
    sigma_x = 2;
    sigma_y = 1.5;
    speckleVariance = 0.01;
elseif nargin == 6
    if f0 <= 0
        error('Center frequency (f0) should be non-zero positive');
    elseif c<=0
        error('Velocity of sound (c) in media should be non-zero positive');
    elseif sigma_x<=0
        error('Pulse-width (sigma_x) of transmitting ultrasonic wave should be non-zero positive');
    elseif sigma_y<=0
        error('Beam-width (sigma_y) of transmitting ultrasonic wave should be non-zero positive');
    elseif speckleVariance<=0
        error('Variance of Speckle distribution (speckleVariance) of the media should be non-zero positive');
    end
else
    error('Unsupported calling of fcnPseudoBmodeUltrasoundSimulator');
end

k0 = 2*pi*f0/c;

[nRows nCols] = size(echoModel);

echoModel = mat2gray(echoModel);

G = rand([nRows nCols],'double');

G = (G-mean(G(:)))*speckleVariance;




T = double(echoModel).*G;

x = -10*sigma_x:10*sigma_x; %-20 :20
y = -10*sigma_y:10*sigma_y; %-15 :15

hx = (sin(k0*x).*exp(-(x.^2)/(2*sigma_x^2)))';
hy = exp(-(y.^2)/(2*sigma_y^2));

V = imfilter(imfilter(T,hx),hy);

Vcap = hilbert(V);

Va = V + (1i*Vcap);

rfEnvelope = abs(Va);
imageOut = im2uint8(mat2gray(log10(rfEnvelope)));