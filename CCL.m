function [label_img, num] = CCL(img)
% img is the imput image matrix
% u is the row index of the image
% v is the column index of the image
u = 1; v = 1;   % initialize to the upper-left pixel

[row, col] = size(img);
label_img = zeros(row, col);
k = 1;  % index of E_table
label = 1;
while (u <= row && v <= col)
    if img(u,v) == 1
        % label of the upper pixel
        if v > 1
            Lup = label_img(u - 1, v);
        else
            Lup = 0;
        end
        % label of the left pixel
        if u > 1
            Llt = label_img(u, v - 1);
        else
            Llt = 0;
        end
        
        if (Lup == Llt && Lup ~= 0 && Llt ~=0) % the same label
            label_img(u, v) = Lup;
        elseif (Lup ~= Llt && ~(Lup && Llt)) % either is 0
            label_img(u, v) = max(Lup, Llt);
        elseif (Lup ~= Llt && Lup > 0 && Llt > 0) % both
            label_img(u, v) = min(Lup, Llt);
            E_table(Lup, Llt);
        else                                % none
            label = [label, k+1];
            label_img(u, v) = label(k);
            k = k + 1;
        end
    end
    v = v + 1;
    if v > col
        u = u + 1;
        v = 1;
    end
end

% Rearranging the table
uni = unique(label);
num = numel(uni) - 1;
for i = 1:num;
    label(label==uni(i)) =i;
end

% Renumbering the labels
u = 1; v = 1;
while (u <= row && v <= col)
    if label_img(u, v) ~=0
        label_img(u, v) = label(label_img(u, v));
    end
    v = v + 1;
    if v > col
        u = u + 1;
        v = 1;
    end
end

% apply the size filter
new_img = size_filter(label_img, 50);
label_img = new_img;
uni = unique(new_img);
num = numel(uni) - 1;

% Additional functions that have been called
function E_table(Lup, Llt)
if label(Lup) < label(Llt)
    label(Llt) = label(Lup);
else 
    label(Lup) = label(Llt);
end
end

function new_img = size_filter(img, filter_size)
    label_num = max(img(:));
    for j = 1:label_num
        count = sum(img(:) == j);
        if count < filter_size
            for uu = 1:row
                for vv = 1:col
                    if img(uu,vv) == j
                        img(uu,vv) = 0;
                    end
                end
            end
        end
    end
    new_img = img;
end

end



















