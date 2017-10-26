function img_out = skindetRG(img,hist,raxis,gaxis,thres)
% this is a function that detects the sub region according to the histogram
% [row, col] = size(img);
% thres: thresholding level, in the scale of 0-1
label = hist<=thres;    
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

rnum = numel(raxis);
gnum = numel(gaxis);

rhwid = 255/rnum/2;   %half width
ghwid = 255/gnum/2;   %half width

for i = 1:rnum
    for j = 1:gnum
        if label(i,j)   % if the RG range is thresholded to 0, RGB should be set 0
            % find the RG range
            Rlow = raxis(i) - rhwid; Rup = raxis(i) + rhwid;
            Glow = gaxis(j) - ghwid; Gup = gaxis(j) + ghwid;
            Ridx = (R>=Rlow)&(R<=Rup);
            Gidx = (G>=Glow)&(G<=Gup);
            Idx = Ridx & Gidx;
            R(Idx) = 0; G(Idx) = 0; B(Idx) = 0;
%             for ii = 1:row
%                 for jj = 1:col
%                     r = R(ii,jj); g = G(ii,jj);
%                     if r>=Rlow && r<=Rup && g>=Glow && g<=Gup
%                         R(ii,jj) = 0;G(ii,jj) = 0;B(ii,jj) = 0;
%                     end
%                 end
%             end
        end
    end      
end
img_out = uint8(cat(3, R, G, B));
imshow(img_out);
end