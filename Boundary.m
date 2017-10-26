function img_out = Boundary(img_in)
% this function calculates the boundary

% define the structuring element
SE = strel('disk', 5, 0);

% our input image is noisy, so we need to use the closing operator
img = Closing(img_in, SE);

se = strel('diamond', 1);   % the SE for erosion
imge = Erosion(img, se);

img_out = img - imge;

end
