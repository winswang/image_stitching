function [img_c,img_s] = LightCorQua(img_in)
% convert image to double
img_in = double(img_in);
[row, col] = size(img_in);
u = 1:col; v = 1:row;
[uu, vv] = meshgrid(u, v);
A = [(uu(:).^2)';(vv(:).^2)';(uu(:).*vv(:))';uu(:)';vv(:)';ones(size(uu(:)))']';
y = img_in(:);
x = pinv(A)*y;
yp = (uu.^2)*x(1) + (vv.^2)*x(2) + uu.*vv*x(3) + uu*x(4) + vv*x(5) + x(6);

img_c = uint8(img_in - yp + ones(row, col)*mean(yp(:)));
img_s = img_in./yp; immax = max(img_s(:));
img_s = uint8(img_s/immax*200+55);

% plot the results
subplot(311);imshow(uint8(img_in));xlabel('Original');
subplot(312);mesh(uu,vv,yp);xlabel('Quadratic fitting');
subplot(325);imshow(img_c);xlabel('Truncated');
subplot(326);imshow(img_s);xlabel('Scaled');
end