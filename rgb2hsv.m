function [H, S, V] = rgb2hsv(R,G,B)
% this function converts RGB to HSV
r = R/255; g = G/255; b = B/255;
Cmaxrg = max(r,g); Cmax = max(Cmaxrg,b);
Cminrg = min(r,g); Cmin = min(Cminrg,b);
delta = Cmax - Cmin;

% hue
if delta ==0
    H = zeros(size(r));
elseif Cmax == r
    H = 60*mod((g - b)./delta, 6);
elseif Cmax == g
    H = 60*((b - r)./delta + 2);
else
    H = 60*((r - g)./delta + 4);
end

% saturation
if Cmax == 0
    S = zeros(size(r));
else
    S = delta./Cmax;
end

% value
V = Cmax;
    
end