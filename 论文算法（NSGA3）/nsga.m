%% NSGA求解带模糊需求的多车型多目标带时间窗的选址路径问题
clear;clc;close all;
tic
% load 100-10
% load 30-5
load 30-5
Num = 80; %种群数量
max_iter = 400;
data.alpha = 1; % 服务满意度
data.DPI = 0.1;
data.API = 1;
data.C = 1;
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
sol = cell(1,10);
result = zeros(10,10);
%% 初始种群生成
for t = 1
    data.DPI = 0.1*t;
    x = repmat(ex,Num,1);
    for i = 1 : data.l
        data.D{i} = dis([data.depot{i};data.customer],[data.depot{i};data.customer]);% 计算点之间的距离
        data.p2c(i,:) = dis(data.park,[data.depot{i};data.customer]);
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
    additional_distance = sum(ad)/400;
    new_satisfactory = sum(ns)/400;    
    toc
    count = numel(F1);
    for i = 1: count
        F1(i).ad = additional_distance(i);
        F1(i).ns = new_satisfactory(i);
        [F1(i).depot,F1(i).vehicle] = depot(F1(i),data);
    end
    sol{t} = F1;
    fit = [F1.fit];
    fit1 = fit(1:2:end);
    fit2 = fit(2:2:end);
    result(t,7) = length(unique(fit1));
    result(t,1) = min(fit1);
    result(t,2) = min(fit2)*1000;
    result(t,3) = sum(fit1)/count;
    result(t,4) = sum(fit2)/count*1000;
    result(t,5) = sum(additional_distance)/count;
    result(t,6) = sum(new_satisfactory)/count*1000;
    result(t,8) = sum([F1.depot])/count;
    result(t,9) = sum([F1.vehicle])/count;
    result(t,10) = toc;
end
%% draw picture
    figure
%     hold on
    drawpath(F1,[F1.ad],[F1.ns]);
    draw2(F1)
