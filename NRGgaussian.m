function img_out = NRGgaussian(r,g,img,thres)
% get the gaussian model
r = double(r); g = double(g); 
imgR = double(img(:,:,1)); imgG = double(img(:,:,2)); imgB = double(img(:,:,3));
sum = imgR+imgG+imgB;
imgr = imgR./sum;
imgg = imgG./sum;

muR = mean(r(:)); muG = mean(g(:));
Sigma = cov(r(:),g(:));

num = numel(imgR(:));
for i = 1:num
    c = [imgr(i) - muR;imgg(i) - muG];
%     temp = c'*Sigma*c;
    disc = exp(-0.5*c'*inv(Sigma)*c);
    if disc <=thres
        imgR(i) = 0;imgG(i) = 0;imgB(i) = 0;
    end
end
img_out = uint8(cat(3, imgR, imgG, imgB));
end