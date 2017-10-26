function [H, key1, key2] = findtrans(Dot1,Dot2)
% This function finds the projective transform
% %%%ransac
Size=size(Dot1);
max=0;
temp=[];
C1=[];
C2=[];
%% shuffle the dots
for s=Size(1):-1:1
    number=unidrnd(s,1,1);
    tmp1=Dot1(:,number);
    tmp2=Dot2(:,number);
    Dot1(:,number)=Dot1(:,s);
    Dot2(:,number)=Dot2(:,s);
    Dot1(:,s)=tmp1;
    Dot2(:,s)=tmp2;
end
% idx=1:1:4;   
% while idx(4)+3<Size(2)
for i=1:1:100
    %%%randomly choose four points
    idx=randperm(Size(2),4);
    sample1=Dot1(:,idx);
    sample2=Dot2(:,idx);
    dot1=Dot1;
    dot2=Dot2;
    %%compute homography
    % construct matrix
    for i=1:4
        xi=sample1(1,i);
        yi=sample1(2,i);
        nsize=size(dot1,2);
        d=dot1;
        dot1=dot1(:,~all(d==repmat([xi;yi],[1,nsize])));
        xxi=sample2(1,i);
        yyi=sample2(2,i);
        dot2=dot2(:,~all(d==repmat([xi;yi],[1,nsize])));
        a = [xi, yi, 1, 0, 0, 0, -xi*xxi, -xxi*yi;...
            0, 0, 0, xi, yi, 1, -yyi*xi, -yyi*yi];
        b = [xxi;
             yyi];
    if  i == 1
        A = a;
        B = b;
    else
        A = [A;a];
        B = [B;b];
    end
    end
    h = pinv(A)*B;
    H = [h(1), h(2), h(3); h(4), h(5), h(6); h(7), h(8), 1];
    candidate1=sample1;
    candidate2=sample2;
    count=0;
    for j=1:1:size(dot1,2)
        h_dot = H*[dot1(1,j);dot1(2,j);1];
        h_x = h_dot(1)/h_dot(3);
        h_y = h_dot(2)/h_dot(3);
        dis=sqrt((dot2(1,j)-h_x)^2+(dot2(2,j)-h_y)^2);
        if dis<=2
            count=count+1;
            candidate1=[candidate1,dot1(:,j)];
            candidate2=[candidate2,dot2(:,j)];
        end
    end
    if count>max
        max=count;
        temp=H;
        C1=candidate1;
        C2=candidate2;
    end
%     idx=idx+4;
end

key1 = C1;
key2 = C2;
ptnum = numel(C1)/2;
for i = 1:ptnum
    xi = C1(1,i);
    yi = C1(2,i);
    xxi = C2(1,i);
    yyi = C2(2,i);
    a = [xi, yi, 1, 0, 0, 0, -xi*xxi, -xxi*yi;...
            0, 0, 0, xi, yi, 1, -yyi*xi, -yyi*yi];
    if i == 1
        A = a;
        b = [xxi;yyi];
    else
        A = [A;a];
        b = [b; xxi; yyi];
    end
end

h = pinv(A)*b;
H = [h(1), h(2), h(3); h(4), h(5), h(6); h(7), h(8), 1];



end