function ic22 = sift(img)
if size(img,3) == 3
    img = double(rgb2gray(img));
end

% input img is gray scale
im1 = img;
im2 = imresize(img, 0.5, 'bilinear');
% im3 = imresize(img, 0.25, 'bilinear');

% construct filters
filnum = 4;
for i = 1:filnum
    sigma(i) = sqrt(2)^(i-1);   
    gauss(:,:,i) = fspecial('gaussian', 7, sigma(i));
end

% gaussian
for i = 1:filnum
    i1(:,:,i) = imfilter(im1,gauss(:,:,i));
    i2(:,:,i) = imfilter(im2,gauss(:,:,i));
%     i3(:,:,i) = imfilter(im3,gauss(:,:,i));
end

% Difference of Gaussian
for i = 1:filnum-1
    dog1(:,:,i) = abs(i1(:,:,i+1) - i1(:,:,i));
    dog2(:,:,i) = abs(i2(:,:,i+1) - i2(:,:,i));
%     dog3(:,:,i) = abs(i3(:,:,i+1) - i3(:,:,i));
end

dthres1 = 0.1*max(dog1(:));
dthres2 = 0.1*max(dog2(:));
% dthres3 = 0.05*max(dog3(:));

dog1(dog1<dthres1) = 0;dog2(dog2<dthres2) = 0;

% find local maximum
ex1 = localmax(dog1,dog2);

% removing edges
h = [-1,0,1];
for i = 2:size(ex1,1)-1
    for j = 2:size(ex1,2)-1
        level = ex1(i,j);
        if ex1(i,j) ~= 0
            neighbor = img(i-level:i+level,j-level:j+level);
            gx = abs(imfilter(neighbor,h));gy = abs(imfilter(neighbor,h'));
            x = sum(gx(:,1+level)); y = sum(gy(1+level,:));
            if x<0.5*y || y<0.5*x
                ex1(i,j) = 0;
            end
        end
    end
end

figure(1);
imshow(uint8(img));
hold on
[r1, c1] = find(ex1==1);
[r2, c2] = find(ex1==2);
[r3, c3] = find(ex1==4);
plot(c1, r1, 'r+');plot(c2,r2,'g+');plot(c3,r3,'b+');
% compute orientation
for i = 2:size(ex1,1)-1
    for j = 2:size(ex1,2)-1
        level = ex1(i,j);
        if ex1(i,j) ~= 0
            h = zeros(1,37);
            if level<4
                neighbor = i1(i-level:i+level,j-level:j+level,level);
            else
                level = mod(level,3);
                neighbor = i2(i-level:i+level,j-level:j+level,level);
            end
            [mag,dir] = imgradient(neighbor);
            his_idx = floor((dir+180)/10) + 1;
            for num = 1:numel(his_idx)
                h(his_idx(num)) = h(his_idx(num)) + mag(num);
            end
            [M, midx] = max(h);
            orien = 10*(midx-1) - 180 + 18; 
            if ~exist('keyr','var')
                keyr = i;
                keyc = j;
                keyo = orien;
            else
                keyr = [keyr, i];
                keyc = [keyc, j];
                keyo = [keyo, orien];
            end
        end
    end
end

% e1 = extrema1(:,:,1);e2 = extrema1(:,:,2);e3 = extrema1(:,:,3);
% d1 = dog1(:,:,1);d2 = dog1(:,:,2);d3 = dog1(:,:,3);
% ex2 = localmax(dog2);
% % ex3 = localmax(dog3);
% extrema = zeros(size(img));
% extrema(ex1(:,:,1)==1) = 1;extrema(ex1(:,:,2)==1) = 2;extrema(ex1(:,:,3)==1) = 3;
% [r,c] = find(ex2(:,:,1)==1);r = 2*r; c = 2*c;
% extrema(r,c) = 4;
% [r,c] = find(ex2(:,:,2)==1);r = 2*r; c = 2*c;
% extrema(r,c) = 5;
% [r,c] = find(ex2(:,:,3)==1);r = 2*r; c = 2*c;
% extrema(r,c) = 6;
% [r,c] = find(ex3(:,:,1)==1);r = 4*r; c = 4*c;
% extrema(r,c) = 7;
% [r,c] = find(ex3(:,:,2)==1);r = 4*r; c = 4*c;
% extrema(r,c) = 8;
% [r,c] = find(ex3(:,:,3)==1);r = 4*r; c = 4*c;
% extrema(r,c) = 9;


function locmax = localmax(image1, image2)
[roww, colw, heightw] = size(image1);
[row2, col2, height2] = size(image2);
locmax = zeros(roww,colw);
padimage1 = padarray(image1, [1,1,1]);
padimage2 = padarray(image2, [1,1,1]);
% padimage3 = padarray(image3, [1,1,1]);
for rr = 2:(roww+1)
    for cc = 2:(colw+1)
        for hh = 2:(heightw+1)
            self = padimage1(rr,cc,hh);
            neighbour(:) = padimage1(rr-1:rr+1,cc-1:cc+1,hh-1:hh+1);
            neighbour(14) = 0;
            if self > max(neighbour(:))
                locmax(rr-1,cc-1) = hh - 1;
                nrr = round((rr-1)/2)+1; ncc = round((cc-1)/2)+1;
                for nhh = 2:(height2+1)
                    newself = padimage2(nrr,ncc,nhh);
                    if newself > self
                        self = newself;
                        neighbour(:) = padimage2(nrr-1:nrr+1,ncc-1:ncc+1,nhh-1:nhh+1);
                        neighbour(14) = 0;
                        if self > max(neighbour(:))
                            locmax(nrr-1,ncc-1) = nhh + 2;
                        end
                    end
                end
            end
        end
    end
end
end
end