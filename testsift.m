% im1 = imread('imsti1.jpg');
% im2 = imread('imsti2.jpg');
% im1 = imresize(im1,0.5);
% im2 = imresize(im2,0.5);
% im1 = imread('lena.bmp');
% 
% sift(im1);
num = match('imsti1.jpg','imsti2.jpg');

% x = zeros(5,5);
% x1 = x; x1(:,3:5) = 1;
% x2 = x; x2(3:5,:) = 1;
% x3 = x; x3(3:5,3:5) = 1;
% x4 = x; x4(1,5) = 1;x4(2,4:5) = 1;x4(3,3:5) = 1;x4(4,2:5) = 1;x4(5,:) = 1;
% x5 = x4; x5(1,4) = 1;x5(3:4,2) = 0;x5(5,1) = 0;
% h = [-1,0,1];
% gx5x = imfilter(x5,h);
% gx5y = imfilter(x5,h');
% g5 = gx5x.*gx5y;