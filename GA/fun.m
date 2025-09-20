function y = fun(x,D,C,F,O,I)
% D:距离矩阵 C ：单位距离费用 F： 车辆费用 O： 仓库开放费用 I ：仓库数量
if nargin <= 4
    I = 1;O = 0;
end
if C == 100
    D = ceil(D*C);
end
distance = 0;%计算车辆行驶距离
c = find(x<=I);
v_num = length(c); %车辆数目
dep = []; %记录启用的仓库
for i = 1 : v_num 
    if i == v_num
        if length(c(i):length(x))~=1
            for j = c(i) : length(x)-1
                distance = distance + D(x(j),x(j+1));
            end
            distance = distance +D(x(j+1),x(c(i)));  %OLRP不算最后一段
            dep = [dep,x(c(i))]; 
        end
    else
        if length(c(i):c(i+1))~=2
            for j = c(i):c(i+1)-2
                distance = distance + D(x(j),x(j+1));
            end
            distance = distance +D(x(j+1),x(c(i)));  %OLRP不算最后一段
            dep = [dep,x(c(i))];
        end
    end
end
cost_vehicle = v_num * F;%车辆启用费用
cost_depot = sum(O(unique(dep))); %仓库启用费用
cost_distance = distance; %距离费用
y = cost_distance+cost_vehicle+cost_depot; %总费用
end