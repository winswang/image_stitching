function [h,rr,gg] = rgbhist(R,G,rbin,gbin)
% this function constructs a histogram
% input R and G should be in 0-255 scale
if max(R(:))<=1
    R = R*255;
    G = G*255;
end
raxis = linspace(0,255,rbin+1);
gaxis = linspace(0,255,gbin+1);
rr = raxis(1:end-1) + 255/2/rbin;
gg = gaxis(1:end-1) + 255/2/gbin;

h = zeros(rbin,gbin);
num = numel(R);
for i = 1:num
    r = R(i); g = G(i);
    for j = 1:rbin
        for k = 1:gbin
            if r>=raxis(j) && r<raxis(j+1) && g>=gaxis(k) && g<gaxis(k+1)
                h(j,k) = h(j,k) + 1;
            end
        end
    end
end
h = h./max(h(:));
bar3(h);title('R-G Histogram');
end