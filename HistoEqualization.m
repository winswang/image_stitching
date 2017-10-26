function img_out = HistoEqualization(img_in)
% get size of image
img_in = double(img_in);
[row, col] = size(img_in);
img_out = zeros(size(img_in));

% construct a histogram
h = zeros(1,256);
x = 0:255;          % axis
for r = 1:row
    for c = 1:col
        h(img_in(r,c)+1) = h(img_in(r,c)+1) + 1;
    end
end
h_max = max(h);
h = h/h_max;
subplot(311); plot(x,h); xlabel('Original Histogram');
axis([0,255,0,1]);

% construct the cummulative histogram
h_c = zeros(1,256);h_c(1) = h(1);
for i = 2:256
    h_c(i) = h(i) + h_c(i - 1);
end
h_c = h_c/max(h_c);
subplot(312); plot(x,h_c); xlabel('Cummulative Histogram');
axis([0,255,0,1]);

% construct a look-up table
table = round(h_c*255);

for j = 0:255
    index = img_in == j;
    img_out(index) = table(j+1);
end

% compute the new histogram
h_new = zeros(1, 256);
for r = 1:row
    for c = 1:col
        h_new(img_out(r,c)+1) = h_new(img_out(r,c)+1) + 1;
    end
end
h_max = max(h_new);
h_new = h_new/h_max;
subplot(313); plot(x,h_new); xlabel('New Histogram');
axis([0,255,0,1]);

img_out = uint8(img_out);
end

