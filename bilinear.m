function [im_zoom] = bilinear( array_recon )
%bilinear interpolation of an image is done here 
a=array_recon;
factor=1;   %zooming factor

[m n d] = size(a);  %2 dimentional array values              
rows=factor*m;
columns=factor*n;

for i=1:rows  
    x=i/factor;   
    x1=floor(x); %bilinear in X direction
    x2=ceil(x);
    if x1==0
        x1=1;
    end
    xrem=rem(x,1);
    for j=1:columns        
        y=j/factor;
        
        y1=floor(y);    %bilinear in Y direction
        y2=ceil(y);
        if y1==0
            y1=1;
        end
        yrem=rem(y,1);
        
        BottomLeft=a(x1,y1,:);
        TopLeft=a(x1,y2,:);
        BottomRight=a(x2,y1,:);
        TopRight=a(x2,y2,:);
        
        R1=BottomRight*yrem+BottomLeft*(1-yrem);
        R2=TopRight*yrem+TopLeft*(1-yrem);
        
        im_zoom(i,j)=R1*xrem+R2*(1-xrem);
    end
end
%size(im_zoom)
%size(imagebig)
%ssd=sum(sum(sum((imagebig-im_zoom).*(imagebig-im_zoom))))
%imwrite(im_zoom,'bilinear zoom.png');
%imshow(im_zoom);

end

