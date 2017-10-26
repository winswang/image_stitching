function img_out = Erosion(img_in, SE)
% img_in is the input image
% img_out is the output image
% SE is the structuring element

Nhood = getnhood(SE);       % get the neighborhood of SE
row = floor(size(Nhood,1)/2); % get the dimensions for padding
col = floor(size(Nhood,2)/2);
Pad = padarray(img_in, [row, col], 1);  % pad array with 1s
[new_row, new_col] = size(Pad);

% creat a new canvas
img = zeros(size(img_in));

for i = 1:new_row-(2*row)
    for j = 1:new_col-(2*col)
        Temp = Pad(i:i+(2*row), j:j+(2*col));
        img(i,j) = min(min(Temp - Nhood));
    end
end
img_out = ~img;
end