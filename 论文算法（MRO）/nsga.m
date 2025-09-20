%% NSGA求解带模糊需求的多车型多目标带时间窗的选址路径问题
clear;clc;close all;
tic
% load 10-3 %载入数据 depot customer demand Q P O F tw 
load instance
Num = 60; %种群数量
max_iter = 100;
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
%% 初始种群生成
x = repmat(ex,Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %初始化可行解
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %计算适应度值
end
[x, F, data] = NS(x, data, Num); %非支配解排序

%% main Loop
for iter = 1 : max_iter
    x1 = crossover(x,ex,data);%交叉
    x2 = mutation(x,ex,data);%变异
    newx = [x;x1;x2]; %合并种群
    [x, F, para] = NS(newx, data, Num); %非支配解排序
    F1 = x(F{1});
    disp(['Iteration ' num2str(iter) ': Number of F1 Members = ' num2str(numel(F1))]);
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