%% 蘑菇繁殖算法（mushroom reproduction optimization algorithm）
%% 初始化参数
clear;clc;   
tic
load instance
data.alpha = 0.8; % 服务满意度
data.DPI = 0.6; 
data.API = 1;
data.zmin = [];
data.zmax = [];
data.smin = [];
ex.arrtime = [];
ex.route = [];
ex.fit = [];
ex.dset = [];
ex.dcount = [];
ex.rank = [];
ex.NormalizedCost = [];
ex.AssociatedRef = [];
ex.DistanceToAssociatedRef = [];                                                    
r = 10;                                                    %局部搜索的半径
c = 12;                                                      %阈值
iter_max = 100;                                             %算法迭代次数    
Num = 30; c_num = 3;                                        %种群数量和每个父代产生的子代数量
%% 初始化种群
x = repmat(ex,Num,1);
x_child = repmat(ex,c_num*Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %初始化可行解
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %计算适应度值
    for j = 1 : c_num
        x_child((i-1)*c_num + j) = mutation(x(i),ex,data);
        x_child((i-1)*c_num + j).fit = fun(x_child((i-1)*c_num + j).route,x_child((i-1)*c_num + j).arrtime,data);
    end
end

[x, F, data] = NS(x, data, Num); %非支配解排序
%% 主循环
iter_num = 1;
while iter_num <= iter_max 
    for i = 1 : M
        if average(i)+T_ave/c < T_ave                                                                           %c:阈值，用于决定是否删除种群
            for k = 1 : M                                                                                
                for j = 2 : N
                    if rand <=0.5 
                        [X{i}{j},f1] = crosschange(Xgbest,x{i}{1},C,F,O,P,Q,D,demand);
                    else
                        [X{i}{j},f1] = crosschange(x{k}{1},x{i}{1},C,F,O,P,Q,D,demand);
                    end
                end
            end
        end
        for j = 2 : N                                                               
            x2 = mutation(x,ex,data);%邻域搜索
        end
        average(i) = sum(fitness(i,:))/N;                                       %更新所有种群适应度均值    
    end
    T_ave = sum(average)/length(average);                                                                   %计算代数所有种群的总平均值                                                                               %记录每一代的最优值            
    iter_num = iter_num + 1;
end

%% simulation procedure
ad = zeros(400,numel(F1));%额外行驶距离
ns = zeros(400,numel(F1));%新的服务满意度
for i = 1 : 400
    data = simular_demand(data);
    [ad(i,:),ns(i,:)] = simu(F1,data);
end

%% draw picture
    figure(1)
    drawpath(F1);
toc


    
