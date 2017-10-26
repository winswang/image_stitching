function [img1, img2] = hdrblend(a1,a2,img1,img2,gamma)
if size(a1,3) == 3
    im1 = rgb2gray(a1);
    im2 = rgb2gray(a2);
end
mean1 = mean(double(im1(:)));
mean2 = mean(double(im2(:)));
img1 = double(img1);
r1 = img1(:,:,1);
g1 = img1(:,:,2);
b1 = img1(:,:,3);
img2 = double(img2);
r2 = img2(:,:,1);
g2 = img2(:,:,2);
b2 = img2(:,:,3);
if mean2 >=mean1
    scale = mean2/mean1;
    r1 = r1*scale;
    g1 = g1*scale;
    b1 = b1*scale;
    sr = 1/max(r1(:));
    sg = 1/max(g1(:));
    sb = 1/max(b1(:));
    r1 = (r1*sr).^gamma;
    g1 = (g1*sg).^gamma;
    b1 = (b1*sb).^gamma;
    r2 = (r2*sr).^gamma;
    g2 = (g2*sg).^gamma;
    b2 = (b2*sb).^gamma;
    img1 = uint8(255*cat(3,r1,g1,b1));
    img2 = uint8(255*cat(3,r2,g2,b2));
else 
    scale = mean1/mean2;
    r2 = r2*scale;
    g2 = g2*scale;
    b2 = b2*scale;
    sr = 1/max(r2(:));
    sg = 1/max(g2(:));
    sb = 1/max(b2(:));
    r2 = (r2*sr).^gamma;
    g2 = (g2*sg).^gamma;
    b2 = (b2*sb).^gamma;
    r1 = (r1*sr).^gamma;
    g1 = (g1*sg).^gamma;
    b1 = (b1*sb).^gamma;
    img1 = uint8(255*cat(3,r1,g1,b1));
    img2 = uint8(255*cat(3,r2,g2,b2));
end