function img_out = skindetnrg(img,hist,raxis,gaxis,thres)
% this is a function that detects the sub region according to the histogram
% in N-RG space
% [row, col] = size(img);
label = hist<=thres;    
R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));
sum = R+G+B;
r = R./sum; g = G./sum;% b = B./sum;

rnum = numel(raxis);
gnum = numel(gaxis);

rhwid = 0.5/rnum;   %half width
ghwid = 0.5/gnum;   %half width

for i = 1:rnum
    for j = 1:gnum
        if label(i,j)   % if the RG range is thresholded to 0, RGB should be set 0
            % find the RG range
            Rlow = raxis(i) - rhwid; Rup = raxis(i) + rhwid;
            Glow = gaxis(j) - ghwid; Gup = gaxis(j) + ghwid;
            Ridx = (r>=Rlow)&(r<Rup);
            Gidx = (g>=Glow)&(g<Gup);
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
% a = img-img_out;

% imshow(img_out);
end