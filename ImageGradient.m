function [Mag, Theta] = ImageGradient(S)
% this function performs the sobel gradient of an image
gx = [-1 0 1;-2 0 2;-1 0 1];gy = gx';
Gx = imfilter(S, gx, 'replicate');
Gy = imfilter(S, gy, 'replicate');
Mag = sqrt(Gx.^2 + Gy.^2);
Theta = atan2(-Gy, Gx)*180/pi;

end