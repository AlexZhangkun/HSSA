%% NSGA-II
clear;clc;
tic
% load instance
load instance20
Num = 80; %种群数量
max_iter = 100;
data.alpha = 1; % 服务满意度
data.DPI = 1;
data.API = 1;
%% 生成初始种群（贪心聚类算法）
x1.route = [];%路线
x1.fit = [];%适应度值
x1.rank = [];%排序等级
x1.doset = [];%被支配的集合
x1.docount = [];%被支配的次数
x1.CrowdDistance = 0;%拥挤距离
x = repmat(x1,Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %初始化可行解
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %计算适应度值
end
[x, F] = NDS_CCD(x, Num); %非支配解排序

%% main loop 
for i = 1: iter_max
    x1 = crossover(x,x1,data);%交叉
    x2 = mutation(x,x1,data);%变异
    pop = [x;x1;x2]; %种群合并
    [x, F] = NDS_CCD(pop,Num);%非支配解排序和拥挤距离计算
    F1 = x(F{1});
    disp(['Iteration ' num2str(i) ': Number of F1 Members = ' num2str(numel(F1))]);
end

%% stochastic simulation 
ad = zeros(400,numel(F1));%额外行驶距离
ns = zeros(400,numel(F1));%新的服务满意度
for i = 1 : 400
    data = simular_demand(data);
    [ad(i,:),ns(i,:)] = simu(F1,data);
end
additional_distance = sum(ad);
new_satisfactory = 1./sum(ns);
%% 绘图
figure
hold on
for i = 1: numel(F1)
    plot(F1(i).fitness(1),F1(i).fitness(2),'r*');
end
xlabel('f1'); ylabel('f2');
title('Pareto Optimal Front');
toc