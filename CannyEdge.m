function E = CannyEdge(Img, N, sigma, perc)
I = double(rgb2gray(Img));
% gaussian smoothing
I = GaussSmoothing(I, N, sigma);
% image gradient
[grad, dir] = ImageGradient(I);
% non-maxima supression
newgrad = NonmaximaSupress(grad, dir);
% find threshold
[weak, strong] = FindThreshold(newgrad, perc);
% edge linking
E = EdgeLinking(weak, strong);

function S = GaussSmoothing(I, N, Sigma)
% construct a gaussian kernel
h = fspecial('gaussian', N, Sigma);
% padding
n = floor(N/2);
I = padarray(I,[n,n],'replicate');
% convolve with kernel
S = imfilter(I, h, 'conv');
S = S(n+1:end-n,n+1:end-n);
end

function [Mag, Theta] = ImageGradient(S)
% this function performs the sobel gradient of an image
gx = [-1 0 1;-2 0 2;-1 0 1];gy = gx';
Gx = imfilter(S, gx, 'replicate');
Gy = imfilter(S, gy, 'replicate');
Mag = sqrt(Gx.^2 + Gy.^2);
Theta = atan2(-Gy, Gx)*180/pi;

end

function newMag = NonmaximaSupress(Mag, Theta)
% using the LUT method
[row, col] = size(Mag);
newMag = zeros(row, col);
for r = 2:row-1
    for c = 2:col-1
        % get the rounded gradient angle
        ang = Theta(r,c);
        if (ang<26.5 && ang>=-26.5) || (ang>=153.5) || (ang<-153.5)
            ang = 0;
        elseif (ang>=26.5 && ang<73.5) || (ang>=-161.5 && ang<-108.5)
            ang = 45;
        elseif (ang>=73.5 && ang<108.5) || (ang>=-108.5 && ang<-73.5)
            ang = 90;
        else
            ang = 135;
        end
        mag = Mag(r, c);
        switch ang
            case 90
                n1 = Mag(r-1, c); n2 = Mag(r+1, c);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
            case 135
                n1 = Mag(r-1, c-1); n2 = Mag(r+1, c+1);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
            case 0
                n1 = Mag(r, c-1); n2 = Mag(r, c+1);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
            case 45
                n1 = Mag(r-1, c+1); n2 = Mag(r+1, c-1);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
        end
        
    end
end
end

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

function E = EdgeLinking(Mag_low, Mag_high)
% this function uses the recursive method to link the edges from strong to
% weak
set(0,'recursionlimit',2000);
[row, col] = size(Mag_low);
E = zeros(row, col);
while(~all(~Mag_high(:)))   % check if still exist strong edges
    for rr = 2:row-1
        for cc = 2:col-1
            if Mag_high(rr,cc)  % find a start point of a strong edge
                checkend(rr,cc);
                
            end
        end
    end
end

function [rend,cend] = checkend(r, c)
    rend = r;
    cend = c;
    E(r, c) = 1;    % the point is an edge
    Mag_high(r, c) = 0;  % in case later recursion will find this point again
    Mag_low(r,c) = 0;   %also the weak edges
    neighbour = Mag_high(r+1,c+1)||Mag_high(r,c+1)||Mag_high(r-1,c+1)||Mag_high(r-1,c)||...
        Mag_high(r-1,c-1)||Mag_high(r,c-1)||Mag_high(r+1,c-1)||Mag_high(r+1,c);
    if neighbour == 0   % an end point in strong edge
        [rend,cend] = checkendweak(r,c);
%         [rend,cend] = checkend(rend,cend);
        return;
    end
%     else
    if Mag_high(r+1,c+1)
        [rend,cend] = checkend(r+1,c+1);
    end
    if Mag_high(r,c+1)
        [rend,cend] = checkend(r,c+1);
    end
    if Mag_high(r-1,c+1)
        [rend,cend] = checkend(r-1,c+1);
    end
    if Mag_high(r-1,c)
        [rend,cend] = checkend(r-1,c);
    end
    if Mag_high(r-1,c-1)
        [rend,cend] = checkend(r-1,c-1);
    end
    if Mag_high(r,c-1)
        [rend,cend] = checkend(r,c-1);
    end
    if Mag_high(r+1,c-1)
        [rend,cend] = checkend(r+1,c-1);
    end
    if Mag_high(r+1,c)
        [rend,cend] = checkend(r+1,c);
    end
    return;
end

function [rend,cend] = checkendweak(r, c)
    rend = r;
    cend = c;
    E(r,c) = 1;
    Mag_low(r,c) = 0;
    neighbour = Mag_low(r+1,c+1)||Mag_low(r,c+1)||Mag_low(r-1,c+1)||Mag_low(r-1,c)||...
        Mag_low(r-1,c-1)||Mag_low(r,c-1)||Mag_low(r+1,c-1)||Mag_low(r+1,c);
    if neighbour == 0
        return;
    end
    if Mag_low(r+1,c+1)
        [rend,cend] = checkendweak(r+1,c+1);
    end
    if Mag_low(r,c+1)
        [rend,cend] = checkendweak(r,c+1);
    end
    if Mag_low(r-1,c+1)
        [rend,cend] = checkendweak(r-1,c+1);
    end
    if Mag_low(r-1,c)
        [rend,cend] = checkendweak(r-1,c);
    end
    if Mag_low(r-1,c-1)
        [rend,cend] = checkendweak(r-1,c-1);
    end
    if Mag_low(r,c-1)
        [rend,cend] = checkendweak(r,c-1);
    end
    if Mag_low(r+1,c-1)
        [rend,cend] = checkendweak(r+1,c-1);
    end
    if Mag_low(r+1,c)
        [rend,cend] = checkendweak(r+1,c);
    end
    return;
end
end
end