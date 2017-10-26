function [h,rr,gg] = nrghist(r,g,rbin,gbin)
% this function constructs a histogram
% input r and g should be in 0-1 scale
raxis = linspace(0,1,rbin+1);
gaxis = linspace(0,1,gbin+1);
rr = raxis(1:end-1) + 0.5/rbin;
gg = gaxis(1:end-1) + 0.5/gbin;
% 
% temp(:,1)=r(:);
% temp(:,2)=g(:);


h = zeros(rbin,gbin);
num = numel(r);
for i = 1:num
    R = r(i); G = g(i);
    for j = 1:rbin
        for k = 1:gbin
            if R>=raxis(j) && R<raxis(j+1) && G>=gaxis(k) && G<gaxis(k+1)
                h(j,k) = h(j,k) + 1;
            end
        end
    end
end
h = h./max(h(:));
bar3(h);title('NR-NG Histogram');
end