function img_out = Closing(img_in, SE)
% Morphological Closing function
% first dilate and then erode using the same SE

img = Dilation(img_in, SE);
img_out = Erosion(img, SE);
end