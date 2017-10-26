function newMag = NonmaximaSupress(Mag, Theta)
% using the LUT method
[row, col] = size(Mag);
newMag = zeros(row, col);
for r = 2:row-1
    for c = 2:col-1
        % get the rounded gradient angle
        ang = Theta(r,c);
        if (ang<26.5 && ang>=-26.5) || (ang>=153.5) || (ang<-153.5)
            ang = 0;
        elseif (ang>=26.5 && ang<63.5) || (ang>=-153.5 && ang<-116.5)
            ang = 45;
        elseif (ang>=63.5 && ang<116.5) || (ang>=-116.5 && ang<-63.5)
            ang = 90;
        else
            ang = 135;
        end
        mag = Mag(r, c);
        switch ang
            case 90
                n1 = Mag(r-1, c); n2 = Mag(r+1, c);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
            case 135
                n1 = Mag(r-1, c-1); n2 = Mag(r+1, c+1);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
            case 0
                n1 = Mag(r, c-1); n2 = Mag(r, c+1);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
            case 45
                n1 = Mag(r-1, c+1); n2 = Mag(r+1, c-1);
                if mag>=n1 && mag>=n2
                    newMag(r,c) = mag;
                end
        end
        
    end
end
end