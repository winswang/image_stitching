function S = GaussSmoothing(I, N, Sigma)
% construct a gaussian kernel
h = fspecial('gaussian', N, Sigma);
% padding
n = floor(N/2);
I = padarray(I,[n n]);
% convolve with kernel
S = imfilter(I, h, 'conv');
S = S(n:end-n,n:end-n);
end