function [weak, strong] = FindThreshold(Mag, percentageOfNonEdge)
% this is a function that sets up the threshold of the image gradient
weak = zeros(size(Mag));
strong = zeros(size(Mag));

max_v = max(Mag(:));
bins = ceil(max_v);

% construct a histogram
h = hist(Mag(:), bins);
c = cumsum(h);
c = c/max(c); % cumulative histogram
% set the high threshold
for i = 1:numel(c)
    if c(i)>=percentageOfNonEdge
        T_high = i;
        break;
    end
end
T_low = 0.5*T_high;

strongidx = Mag>=T_high;
strong(strongidx) = Mag(strongidx);
weakidx = Mag>=T_low;
weak(weakidx) = Mag(weakidx);
end