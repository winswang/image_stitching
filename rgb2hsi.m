function [H, S, I] = rgb2hsi(R, G, B, scale)
% This function converts RGB color space to HSI space
% RGB specifies each channel
% scale specifies the scale of the return values. 0: h[0,2pi] s[0,1] i[0,1]
R = double(R); G = double(G); B = double(B);
sumRGB = R + G + B;

r = R./sumRGB;
g = G./sumRGB;
b = B./sumRGB;

i = (R+G+B)/3;  % encodes the brightness
% if max(i(:)) > 1    % if I is in [0,255]
%     i = i/255;
% end
% R = double(R); G = double(G); B = double(B);
h = real(acos((2*r-g-b)./(2*sqrt((r-g).^2+(r-b).*(g-b)))));
% B1 = B(:,:,1);G1 = G(:,:,1);
hh = b>g;
h(hh) = 2*pi - h(hh);

minRG = min(r,g); minRGB = min(minRG,b);
s = 1 - minRGB./i;

if scale == 1
    H = h*180/pi;
    S = s*100;
    I = i*255;
else
    H = h;
    S = s;
    I = i;
end
end