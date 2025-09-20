function y = dis1(x1,x2)
% x1，x2为经纬度坐标
%维度坐标转换
y = zeros(size(x1,1),size(x2,1));
for i = 1: size(x1,1)
    for j = i : size(x2,1)
        R = 6371;
        X1 = x1(i,2);
        X2 = x2(i,2);
        X1(1,2) = 90 - x1(i,2);
        X2(1,2) = 90 - x2(j,2);
        C = sin(X1(1,2)) * sin(X2(1,2)) * cos(X1(1,1)-X2(1,1)) + cos(X1(1,2)) * cos(X2(1,2));
        y(i,j) = 1000 * R * acos(C) * pi / 180;
        y(j,i) = y(i,j);
    end
end
end