clc;
clear all;
im1 = imread('im3.jpg');
im2 = imread('im4.jpg');
im1 = imresize(im1,0.5);
im2 = imresize(im2,0.5);
a = [size(im1,1), size(im1,2)];
im2 = imresize(im2,a);

% [im1c, mu1] = k_mean_clustering(im1,5);
% [im2c, mu2] = k_mean_clustering(im2,5,mu1);
% r = im1c(:,:,1);
% figure(5);
% subplot(121);
% imshow(uint8(im1c*255));
% subplot(122);
% imshow(uint8(im2c*255));

% scaler = mu1(1)/mu2(1);scaleg = mu1(2)/mu2(2);scaleb = mu1(3)/mu2(3);
% 
% R2 = im2(:,:,1);G2 = im2(:,:,2);B2 = im2(:,:,3);
% R2 = double(R2);G2 = double(G2);B2 = double(B2);
% r2 = R2*scaler;g2 = G2*scaleg; b2 = B2*scaleb;
% new2 = uint8(cat(3,r2,g2,b2));
% figure;
% imshow(new2);
% R1 = im1(:,:,1);G1 = im1(:,:,2);B1 = im1(:,:,3);
% R1 = double(R1);G1 = double(G1);B1 = double(B1);
% R2 = im2(:,:,1);G2 = im2(:,:,2);B2 = im2(:,:,3);
% R2 = double(R2);G2 = 
% im1 = rgb2gray(im1);
% im2 = rgb2gray(im2);
%call the sift function
[m1,m2] = match(im1, im2);
[H,C1,C2] = findtrans(m1,m2);
if size(im1,1) == size(im2,1) && size(im1,2) == size(im2,2)
    c=[im1 im2];
    C2(1,:)=C2(1,:)+size(im1,2)*ones(1,size(C2,2));
    figure(1);
    imshow(c,[]);
    hold on;
    plot(C1(1,:),C1(2,:),'o');
    plot(C2(1,:),C2(2,:),'o');
    for n=1:1:size(C1,2)
    line([C1(1,n),C2(1,n)],[C1(2,n);C2(2,n)]);
    end
end

[whole, a1,a2,blend] = stitch(im1,im2,H);

figure(6);
[hdr1,hdr2] = hdrblend(a1,a2,im1,im2,0.7);
% im1 = hdr1;im2 = hdr2;
subplot(121);imshow(hdr1);
subplot(122);imshow(hdr2);

figure(2);
imshow(whole);
figure(3);
subplot(121);imshow(a1);
subplot(122);imshow(a2);

figure(4);
[n1,n2] = colblend(a1,a2,im1,im2,2);
figure(5);
subplot(221);imshow(im1);
subplot(222);imshow(im2);
subplot(223);imshow(n1);
subplot(224);imshow(n2);



out = stitch(hdr1,hdr2,H);
figure(7);
imshow(out);