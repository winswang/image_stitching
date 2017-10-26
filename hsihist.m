function [hist,hh,ss] = hsihist(H,S,hbin,sbin)
% this function constructs a histogram
% input h 0-2pi; s 0-1
haxis = linspace(0,2*pi,hbin+1);
saxis = linspace(0,1,sbin+1);
hh = haxis(1:end-1) + pi/hbin;
ss = saxis(1:end-1) + 0.5/sbin;

hist = zeros(hbin,sbin);
num = numel(H);
for i = 1:num
    h = H(i); s = S(i);
    for j = 1:hbin
        for k = 1:sbin
            if h>=haxis(j) && h<haxis(j+1) && s>=saxis(k) && s<saxis(k+1)
                hist(j,k) = hist(j,k) + 1;
            end
        end
    end
end
hist = hist./max(hist(:));
bar3(hist);title('H-S Histogram');
end