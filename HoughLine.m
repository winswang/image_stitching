function I = HoughLine(Img, tq, rq, vote, rin, cin)
% this function performs the hough transform
% assume the input image is an RGB image

if nargin == 5  % missing cin
    cin = 3;
end
if nargin == 4  % missing rin
    rin = 3;
end

I = double(rgb2gray(Img));

% get the edge
% E = CannyEdge(Img, N, sigma, perc);
E = edge(I);
subplot(221);
imshow(E);xlabel('Edge');

[row, col] = size(E);

thdis = pi/tq;  % interval for theta
theta = linspace(-0.5*pi,0.5*pi-thdis,tq);

diag = sqrt(row^2 + col^2);
rou = linspace(-diag,diag,rq);

thval = theta+thdis/2;

% construct the map
map = zeros(numel(thval), numel(rou));

T = [cos(thval);sin(thval)]';
for r = 1:row
    for c = 1:col
        if E(r, c) == 1
%             x = c; y = -r;
            cord = [c;-r];
            rval = T*cord;
            rmap = round((rval+diag)*rq/2/diag);
            for tt = 1:tq   % loop for every theta value
                map(tt,rmap(tt)) = map(tt,rmap(tt)) + 1;
            end
        end
    end
end

subplot(222);
imagesc(rou,thval,map); xlabel('parameter space');axis square;

% find the significant intersections
sig = zeros(tq, rq);

xx = 1:col;

for v = 1:vote
    [ridx, cidx] = find(map == max(map(:))); % find the index of the max value
    thetav = thval(ridx);
    rouv = rou(cidx);
    sig(ridx(1),cidx(1)) = 1;
    
    yy = round(-cot(thetav(1))*xx + rouv(1)/sin(thetav(1)));
    yy = -yy;
    for cc = 1:col
        if yy(cc)>0 && yy(cc)<row
            if I(yy(cc),cc) ~=255
                I(yy(cc),cc) = 255;
            end
        end
    end
    % draw lines again in terms of y
    y2 = 1:row;y2 = -y2;
    x2 = round(-tan(thetav(1))*y2 + rouv(1)/cos(thetav(1)));
    for rr = 1:row
        if x2(rr)>0 && x2(rr)<col
            if I(rr,x2(rr)) ~=255
                I(rr,x2(rr)) = 255;
            end
        end
    end
    
    
    % erase the neighbourhood of the peak
    rlow = ridx(1)-rin;
    rhigh = ridx(1)+rin;
    clow = cidx(1)-cin;
    chigh = cidx(1)+cin;
    if rlow<1
        rlow = 1;
    end
    if rhigh>rq
        rhigh = rq;
    end
    if clow<1
        clow = 1;
    end
    if chigh>tq
        chigh = tq;
    end
    map(rlow:rhigh,clow:chigh) = 0;
end
subplot(223);
imagesc(I); xlabel('Detected lines');
subplot(224);
imagesc(rou,thval,sig); xlabel('Significant intersections'); axis square;

end