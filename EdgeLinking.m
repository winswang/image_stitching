function E = EdgeLinking(Mag_low, Mag_high)
% this function uses the recursive method to link the edges from strong to
% weak
set(0,'recursionlimit',2000);
[row, col] = size(Mag_low);
E = zeros(row, col);
while(~all(~Mag_high(:)))   % check if still exist strong edges
    for rr = 2:row-1
        for cc = 2:col-1
            if Mag_high(rr,cc)  % find a start point of a strong edge
                checkend(rr,cc);
                
            end
        end
    end
end

function [rend,cend] = checkend(r, c)
    rend = r;
    cend = c;
    E(r, c) = 1;    % the point is an edge
    Mag_high(r, c) = 0;  % in case later recursion will find this point again
    Mag_low(r,c) = 0;   %also the weak edges
    neighbour = Mag_high(r+1,c+1)||Mag_high(r,c+1)||Mag_high(r-1,c+1)||Mag_high(r-1,c)||...
        Mag_high(r-1,c-1)||Mag_high(r,c-1)||Mag_high(r+1,c-1)||Mag_high(r+1,c);
    if neighbour == 0   % an end point in strong edge
        [rend,cend] = checkendweak(r,c);
%         [rend,cend] = checkend(rend,cend);
        return;
    end
%     else
    if Mag_high(r+1,c+1)
        [rend,cend] = checkend(r+1,c+1);
    end
    if Mag_high(r,c+1)
        [rend,cend] = checkend(r,c+1);
    end
    if Mag_high(r-1,c+1)
        [rend,cend] = checkend(r-1,c+1);
    end
    if Mag_high(r-1,c)
        [rend,cend] = checkend(r-1,c);
    end
    if Mag_high(r-1,c-1)
        [rend,cend] = checkend(r-1,c-1);
    end
    if Mag_high(r,c-1)
        [rend,cend] = checkend(r,c-1);
    end
    if Mag_high(r+1,c-1)
        [rend,cend] = checkend(r+1,c-1);
    end
    if Mag_high(r+1,c)
        [rend,cend] = checkend(r+1,c);
    end
    return;
end

function [rend,cend] = checkendweak(r, c)
    rend = r;
    cend = c;
    E(r,c) = 1;
    Mag_low(r,c) = 0;
    neighbour = Mag_low(r+1,c+1)||Mag_low(r,c+1)||Mag_low(r-1,c+1)||Mag_low(r-1,c)||...
        Mag_low(r-1,c-1)||Mag_low(r,c-1)||Mag_low(r+1,c-1)||Mag_low(r+1,c);
    if neighbour == 0
        return;
    end
    if Mag_low(r+1,c+1)
        [rend,cend] = checkendweak(r+1,c+1);
    end
    if Mag_low(r,c+1)
        [rend,cend] = checkendweak(r,c+1);
    end
    if Mag_low(r-1,c+1)
        [rend,cend] = checkendweak(r-1,c+1);
    end
    if Mag_low(r-1,c)
        [rend,cend] = checkendweak(r-1,c);
    end
    if Mag_low(r-1,c-1)
        [rend,cend] = checkendweak(r-1,c-1);
    end
    if Mag_low(r,c-1)
        [rend,cend] = checkendweak(r,c-1);
    end
    if Mag_low(r+1,c-1)
        [rend,cend] = checkendweak(r+1,c-1);
    end
    if Mag_low(r+1,c)
        [rend,cend] = checkendweak(r+1,c);
    end
    return;
end
end
