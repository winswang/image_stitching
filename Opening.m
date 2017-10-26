function img_out = Opening(img_in, SE)
% Morphological Opening function
% first erode and then dilate using the same SE

img = Erosion(img_in, SE);
img_out = Dilation(img, SE);
end