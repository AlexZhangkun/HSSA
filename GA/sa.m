function [x1,fit] = sa(E,fit,customer,depot,M,D,C,O,F,P,Q,demand)
%模拟退火算法求解车辆路径
T0 = 20; Tf = 0.01;%起始温度与终止温度
alpha = 0.98;%冷却因子
% K = 0.71; % 链长
% D = dis([depot;customer],[depot;customer]);
% x = 0;
% q = Q;%车辆剩余容量
% for i = 1 : J
%     if demand(i) <= q
%         x = [x,i];
%         q = q - demand(i);
%     else
%         x = [x,0,i];
%         q = Q - demand(i);
%     end
% end
x = x + 1;
x1 = x;
fbest = fun(x1,D,C,F);
g = 1;T = T0;G = 100;non = 1;
best = zeros(1,G);
while T > Tf && g < G && non <=20 
    x = local(x,Q,demand);
    fit = fun(x,D,C,F);
    if fit < fbest
        x1 = x; fit = fbest;
    else
        if rand<exp(-(fit-fbest)/(K*T))
            x1 = x; fit = fbest;
        end
    end
    T = T*alpha;
    if g == 1
        best(g) = fbest;
    else
        best(g) = fbest; 
        non = 1; 
        if best(g) == best(g-1)
            non = non + 1;
        else
            non = 1;
        end
    end
    g = g + 1;
end
end
        
    