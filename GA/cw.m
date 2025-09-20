function x = cw(J,Q,demand,customer,depot)
%节约算法求解最优路径
D = dis([depot;customer],[depot;customer]); %各个顶点之间的距离