function y = dis1(x1,x2)
% x1，x2为经纬度坐标
%维度坐标转换
y = zeros(size(x1,1),size(x2,1));
for i = 1: size(x1,1)
    for j = i : size(x2,1)
        y(i,j) = distance(x1(i,2),x1(i,1),x2(j,2),x2(j,1))/180*pi*6371*1000;
        if size(x1,1) ~= 1
            y(j,i) = y(i,j);
        end
    end
end
end