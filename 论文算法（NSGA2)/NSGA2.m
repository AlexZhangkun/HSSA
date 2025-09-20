%% NSGA-II
clear;clc;
tic
% load instance
load 30-5
% load 50-5
% load 100-10
Num = 60; %种群数量
max_iter = 300;
data.alpha = 0.9; % 服务满意度
data.DPI = 0.6;
data.API = 1;
data.C = 1;
%% 生成初始种群（贪心聚类算法）
ex.route = [];%路线
ex.fit = [];%适应度值
ex.rank = [];%排序等级
ex.doset = [];%被支配的集合
ex.docount = [];%被支配的次数
ex.CrowdDistance = 0;%拥挤距离
result = zeros(5,9);
for t =  1: 1
    x = repmat(ex,Num,1);
    for i = 1 : data.l
        data.D{i} = dis([data.depot{i};data.customer],[data.depot{i};data.customer]);
        data.p2c(i,:) = dis(data.park,[data.depot{i};data.customer]);
        data.time{i} = data.D{i}/data.v;
    end
    for i = 1 : Num
        [x(i).route,x(i).arrtime] = greedy_cluster(data); %初始化可行解
        x(i).fit = fun(x(i).route,x(i).arrtime,data); %计算适应度值
    end
    [x, F] = NDS_CCD(x, Num); %非支配解排序

    %% main loop 
    for i = 1: max_iter
        x1 = crossover(x,ex,data,F);%交叉
        x2 = mutation(x,ex,data);%变异
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
    additional_distance = sum(ad)/400;
    new_satisfactory = sum(ns)/400;
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
    result(t,2) = min(fit2);
    result(t,3) = sum(fit1)/count;
    result(t,4) = sum(fit2)/count;
    result(t,5) = sum(additional_distance)/count;
    result(t,6) = sum(new_satisfactory)/count;
    result(t,8) = sum([F1.depot])/count;
    result(t,9) = sum([F1.vehicle])/count;
end
%% 绘图
    figure
%     hold on
%     drawpath(F1,additional_distance,new_satisfactory);
    draw2(F1)
    toc