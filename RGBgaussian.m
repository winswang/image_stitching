function img_out = RGBgaussian(R,G,img,thres)
% get the gaussian model
R = double(R); G = double(G); 
imgR = double(img(:,:,1)); imgG = double(img(:,:,2)); imgB = double(img(:,:,3));
muR = mean(R(:)); muG = mean(G(:));
Sigma = cov(R(:),G(:));

num = numel(imgR(:));
for i = 1:num
    c = [imgR(i) - muR;imgG(i) - muG];
    temp = c'*Sigma*c;
    disc = exp(-0.5*c'*inv(Sigma)*c);
    if disc <=thres
        imgR(i) = 0;imgG(i) = 0;imgB(i) = 0;
    end
end

% tempR = imgR(:) - muR; tempG = imgG(:) - muG;
% c = [tempR';tempG'];
% discriminant = exp(-0.5*c'*Sigma*c);
% discriminant = discriminant/max(discriminant);


% [muR, sigmaR] = normfit(R(:));
% [muG, sigmaG] = normfit(G(:));
% pdfR = pdf('Normal',imgR,muR,sigmaR); pdfR = pdfR/max(pdfR(:));
% pdfG = pdf('Normal',imgG,muG,sigmaG); pdfG = pdfG/max(pdfG(:));
% tR = pdfR <= thres;
% tG = pdfG <= thres;
% Idx = tR & tG;
% imgR(Idx) = 0; imgG(Idx) = 0; imgB(Idx) = 0;
img_out = uint8(cat(3, imgR, imgG, imgB));
end