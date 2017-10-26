function [Image, mu] = k_mean_clustering(Image, k, mu)
% This is a function that implements K-mean clustering algorithm for image
% segmentations.
% Inputs:
% Image: Image that needs to be clustered
% k: number of cluster centers
channel = 3;
if size(Image, 3) == channel
    R = double(Image(:,:,1))/255;
    G = double(Image(:,:,2))/255;
    B = double(Image(:,:,3))/255;
    rows = size(R, 1);
    cols = size(R, 2);
    R = R(:);
    G = G(:);
    B = B(:);
    oneRow = ones(size(R));
else
    channel = 1;
end
% initialize the centers
if nargin < 3
    mu = rand(channel, k);
end
last_mu = rand(channel, k);
oneCol = ones(1, k);
RR = R*oneCol;
GG = G*oneCol;
BB = B*oneCol;
iter = 1;
itmax = 100;

while iter < itmax & last_mu ~= mu
    last_mu = mu;
    % compute the distance to the centers
    disR = RR - oneRow*mu(1, :);
    disG = GG - oneRow*mu(2, :);
    disB = BB - oneRow*mu(3, :);

    dis = disR.^2 + disG.^2 + disB.^2;

    r = dis == (min(dis,[],2)*oneCol);

    mu(1,:) = sum(r.*RR)./sum(r);
    mu(2,:) = sum(r.*GG)./sum(r);
    mu(3,:) = sum(r.*BB)./sum(r);
    sig = isnan(mu);
    flag = sum(sig(:));
    iter = iter + 1;
    
    if flag~=0
        mu = rand(channel, k);
    end

end

R = r*mu(1,:)';
G = r*mu(2,:)';
B = r*mu(3,:)';


R = reshape(R, rows, cols);
G = reshape(G, rows, cols);
B = reshape(B, rows, cols);
Image = cat(3, R, G, B);
end