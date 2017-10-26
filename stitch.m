function [canvas, area1, area2, blend] = stitch(img1,img2,H)
% This function performs the stitching procedure

R1 = img1(:,:,1);G1 = img1(:,:,2);B1 = img1(:,:,3);
R2 = img2(:,:,1);G2 = img2(:,:,2);B2 = img2(:,:,3);
im1 = rgb2gray(img1);
im2 = rgb2gray(img2);
% original size
[im1row, im1col] = size(im1);
[im2row, im2col] = size(im2);

% define the border points
borders = [1,1,1;1,im2col,1;im2row,im2col,1;im2row,1,1]';
bdr2in1 = inv(H)*borders;
for i = 1:4
    bdr2in1(1,i) = bdr2in1(1,i)/bdr2in1(3,i);
    bdr2in1(2,i) = bdr2in1(2,i)/bdr2in1(3,i);
end
xmax = ceil(max([max(bdr2in1(1,:)),im1col]));
xmin = floor(min([min(bdr2in1(1,:)),1]));
ymax = ceil(max([max(bdr2in1(2,:)),im1row]));
ymin = floor(min([min(bdr2in1(2,:)),1]));

row = ymax-ymin;
col = xmax-xmin;
% 
% row = 790;
% col = 1210;
canvas = zeros(row, col, 3);
a1 = zeros(im1row,im1col);
a2 = zeros(im2row,im2col);

for r = 1:row
    for c = 1:col
        x1 = c + xmin - 1; y1 = r + ymin - 1;
        x = H*[x1;y1;1];
        x2 = x(1)/x(3);y2 = x(2)/x(3);
        if x1>=1 && x1<=im1col && y1>=1 && y1<=im1row % the pixel is in the first image
            canvas(r,c,1) = R1(y1,x1);
            canvas(r,c,2) = G1(y1,x1);
            canvas(r,c,3) = B1(y1,x1);
            
            if x2>=1 && x2<=im2col && y2>=1 && y2<=im2row % in the second image
                d1 = min([x1, y1, im1col-x1+1, im1row - y1+1]);
                d2 = min([x2, y2, im2col+1-x2, im2row+1 - y2]);
                w1 = d1/(d1+d2); w2 = d2/(d1+d2);
                % find the neighbors
                xl = floor(x2); xh = ceil(x2);
                yl = floor(y2); yh = ceil(y2);
                alpha = x2 - xl; beta = y2 - yl;
                % assign the value
                red = (1-alpha)*(1-beta)*R2(yl,xl)...
                    + (1-alpha)*beta*R2(yh,xl)...
                    + alpha*(1-beta)*R2(yl,xh)...
                    + alpha*beta*R2(yh,xh);
                green = (1-alpha)*(1-beta)*G2(yl,xl)...
                    + (1-alpha)*beta*G2(yh,xl)...
                    + alpha*(1-beta)*G2(yl,xh)...
                    + alpha*beta*G2(yh,xh);
                blue = (1-alpha)*(1-beta)*B2(yl,xl)...
                    + (1-alpha)*beta*B2(yh,xl)...
                    + alpha*(1-beta)*B2(yl,xh)...
                    + alpha*beta*B2(yh,xh);
                canvas(r,c,1) = w1*canvas(r,c,1) + w2*red;
                canvas(r,c,2) = w1*canvas(r,c,2) + w2*green;
                canvas(r,c,3) = w1*canvas(r,c,3) + w2*blue;
                a1(y1,x1) = 1;
                a2(yl:yh,xl:xh) = 1;
                if ~exist('blendr','var')
                    blendr = canvas(r,c,1);
                    blendg = canvas(r,c,2);
                    blendb = canvas(r,c,3);
                else
                    blendr = [blendr, canvas(r,c,1)];
                    blendg = [blendg, canvas(r,c,2)];
                    blendb = [blendb, canvas(r,c,2)];
                end
%                 if ~exist('areax1','var')
%                     areax1 = x1;
%                     areay1 = y1;
%                     areax2 = x2;
%                     areay2 = y2;
%                 else
%                     
%                     areax1 = [areax1, x1];
%                     areay1 = [areay1, y1];
%                     areax2 = [areax2, x2];
%                     areay2 = [areay2, y2];
%                 end
                   
            end
        elseif x2>=1 && x2<=im2col && y2>=1 && y2<=im2row % in the second image
            
            % find the neighbors
            xl = floor(x2); xh = ceil(x2);
            yl = floor(y2); yh = ceil(y2);
            alpha = x2 - xl; beta = y2 - yl;
            % assign the value
            canvas(r,c,1) = (1-alpha)*(1-beta)*R2(yl,xl)...
                + (1-alpha)*beta*R2(yh,xl)...
                + alpha*(1-beta)*R2(yl,xh)...
                + alpha*beta*R2(yh,xh);
            canvas(r,c,2) = (1-alpha)*(1-beta)*G2(yl,xl)...
                + (1-alpha)*beta*G2(yh,xl)...
                + alpha*(1-beta)*G2(yl,xh)...
                + alpha*beta*G2(yh,xh);
            canvas(r,c,3) = (1-alpha)*(1-beta)*B2(yl,xl)...
                + (1-alpha)*beta*B2(yh,xl)...
                + alpha*(1-beta)*B2(yl,xh)...
                + alpha*beta*B2(yh,xh);
            
        end
            
    end
end

[r1,c1] = find(a1==1);
r1min = min(r1);r1max = max(r1);
c1min = min(c1);c1max = max(c1);

[r2,c2] = find(a2==1);
r2min = min(r2);r2max = max(r2);
c2min = min(c2);c2max = max(c2);
area1 = img1(r1min:r1max,c1min:c1max,:);
area2 = img2(r2min:r2max,c2min:c2max,:);
% area1x = [min(areax1), max(areax1)];
% area1y = [min(areay1), max(areay1)];
% area1 = img1(area1y(1):area1y(2),area1x(1):area1x(2),:);
% area2x = [min(areax2), max(areay2)];
% area2y = [min(areay2), max(areay2)];
% area2 = img2(area2y(1):area2y(2),area2x(1):area2x(2),:);
blend = cat(3,blendr, blendg, blendb);
canvas = uint8(canvas);

end
