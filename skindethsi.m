function img_out = skindethsi(img,hist,haxis,saxis,thres)
% this is a function that detects the sub region according to the histogram
% in N-RG space
% [row, col] = size(img);
label = hist<=thres;    
R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));
[h,s] = rgb2hsi(R,G,B,0);

hnum = numel(haxis);
snum = numel(saxis);

hhwid = pi/hnum;   %half width
shwid = 1/snum/2;   %half width

for i = 1:hnum
    for j = 1:snum
        if label(i,j)   % if the RG range is thresholded to 0, RGB should be set 0
            % find the RG range
            hlow = haxis(i) - hhwid; hup = haxis(i) + hhwid;
            slow = saxis(j) - shwid; sup = saxis(j) + shwid;
            hidx = (h>=hlow)&(h<hup);
            sidx = (s>=slow)&(s<sup);
            Idx = hidx & sidx;
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

end