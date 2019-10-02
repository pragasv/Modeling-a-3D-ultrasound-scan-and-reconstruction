close all;
clear all; 
clc;

%%%this code block is used to create the images %%%%%
%%%later part of this code block is used to save images %%%%%%%

%%theta=(2*pi)/180; %in radian
%%r=2;
%%Xus=10;
angle=-(pi/10):theta:(pi/10);  %%outf this angle no images are taken 
[alpha,beta]=size(angle);
%num_pixel=Xus/0.1;

im=zeros(Xus/0.1,Xus/0.1,beta);
for alpha=1:beta
    notice=waitbar(0,'loading visualization angles, please wait...');
    % Define the input grid (in 3D) %%that sutta code
    figure;
    xlabel('X');ylabel('Y');zlabel('Z');
    [x3, y3, z3] = meshgrid(linspace(-10,10));
    % Compute the implicitly defined function x^2 + (y-6)^2 + z^3 - 2^2 = 0
    f1 = x3.^2 + (y3-6).^2 + z3.^2 - 2^2;                    %%why is this taking an elipse 

    % This surface plane, which can also be expressed as
    f2 = z3-tan(angle(alpha))*y3 - 0*x3.^3 ;
    % Also compute plane in the 'traditional' way.
    [x2, y2] = meshgrid(linspace(-10,10));
    z2 = tan(angle(alpha))*y2 - 0*x2;
    % Visualize the two surfaces.
    patch(isosurface(x3, y3, z3, f1, 0), 'FaceColor', [0.5 1.0 0.5], 'EdgeColor', 'none');
    patch(isosurface(x3, y3, z3, f2, 0), 'FaceColor', [1.0 0.0 0.0], 'EdgeColor', 'none');
    view(3); camlight; axis vis3d;
    set(gca,'xlim',[-5 5 ], 'ylim',[1 11], 'zlim',[-5 5]);
    
    %title('visualization at',angle(alpha),'radians');
    
    
    % Find the difference field.
    f3 = f1 - f2;
    % Interpolate the difference field on the explicitly defined surface.
    f3s = interp3(x3, y3, z3, f3, x2, y2, z2);

    % Find the contour where the difference (on the surface) is zero.
    C = contours(x2, y2, f3s, [0 0]);
    % Extract the x- and y-locations from the contour matrix C.
    xL = C(1, 2:end);
    yL = C(2, 2:end);
    % Interpolate on the first surface to find z-locations for the intersection
    % line.
    
    if ~isempty(xL) & ~isempty(yL) 
        zL = interp2(x2, y2, z2, xL, yL);
        % Visualize the line.
        line(xL,yL,zL,'Color','k','LineWidth',3);

        %xL_1=ceil(xL/0.2)+50; %conversion to pixels
        %yL_1=ceil(yL/0.2)+50; %conversion to pixels   %%commented since errors

        max_xL=max(xL);
        min_xL=min(xL);
        max_yL=max(yL);
        min_yL=min(yL);

        
        %%direct substuition into eclipse formula
        a=(max_xL-min_xL)/2; %average to reduce errors
        b=(max_yL-min_yL)/2; 

        a=a/0.1;        %convertion to pixels
        b=b/0.1;

        H=0;Y=0; %center of the eclipse
        for i=1:num_pixel
            for j=1:num_pixel
                    if ((i-num_pixel/2)/a)^2+((j-num_pixel/2)/b)^2 <= 1 %no need to worry about the world cordinates for now
                        im(i,j,alpha)=255;
                    end
            end
        end
    end
    
%figure, 
%imshow(im);
    close(notice)
end


%%%%%%image save%%%%%%%%

%%% a total of 61 image slices will be saved <as 0 is included as well>%%%%%%%%
%%% need to add a total of 21 empty images both at the front and back %%%%%%%%% 

im_main=zeros(Xus/0.1,Xus/0.1,61);
for i=[22:40]
    im_main(:,:,i)=im(:,:,i-21);
end

%%run this loop if you wish to save the images
%%for i=[1:61]
    %%imsave(im_main(:,:,i));
%%end
    

