function img_out = HSIgaussian(h,s,img,thres)
% get the gaussian model
imgR = double(img(:,:,1)); imgG = double(img(:,:,2)); imgB = double(img(:,:,3));
[imgh, imgs] = rgb2hsi(imgR, imgG, imgB, 0);

muR = mean(h(:)); muG = mean(s(:));
Sigma = cov(h(:),s(:));

num = numel(imgR(:));
for i = 1:num
    c = [imgh(i) - muR;imgs(i) - muG];
%     temp = c'*Sigma*c;
    disc = exp(-0.5*c'*inv(Sigma)*c);
    if disc <=thres
        imgR(i) = 0;imgG(i) = 0;imgB(i) = 0;
    end
end
img_out = uint8(cat(3, imgR, imgG, imgB));
end