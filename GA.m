clear;clc;   
% load 30-5
load real_instance
% load 50-5
% load 100-10
%% 初始化
value = zeros(1,10);
% kmax = 5;
Num = 40;  %种群数量
iter_max = 800; %最大迭代次数
ex.fitness = [];ex.route = []; ex.time = []; 
ex.rank = [];%排序等级
ex.doset = [];%被支配的集合
ex.docount = [];%被支配的次数
ex.CrowdDistance = 0;%拥挤距离
x = repmat(ex,Num,1); 
data.DPI = 0.6; data.API = 1; data.alpha = 0.9;
tic
for j = 1 : 1
%     data.DPI = 0.1*j;
    for i = 1 : Num
        [x(i).route,x(i).time] = greedy_cluster(data);
        x(i).fitness = fun(x(i).route,x(i).time,data);
    end
    [x, F] = NonDominatingSort(x,Num);
    %% 主循环
    iter = 1; 
    while iter <= iter_max 
        x1 = sc_select(x,x(F{1}),data,Num,ex);
        x2 = mutation(x,data,ex,x1);
        x3 = crossover(x(F{1}),data,ex,x1,x2);
        if ~isempty([x3.fitness])
            pop = [x;x1';x2';x3'];
        else
            pop = [x;x1';x2'];
        end
        [x, F] = NonDominatingSort(pop,Num);
        F1 = x(F{1});
        disp(['Iteration ' num2str(iter) ': Number of F1 Members = ' num2str(numel(F{1}))]);
        iter = iter + 1;
    end

    ad = zeros(400,numel(F{1}));%额外行驶距离
    ns = zeros(400,numel(F{1}));%新的服务满意度
    for i = 1 : 400
        data = simular_demand(data);
        [ad(i,:),ns(i,:)] = simu(x(F{1}),data);
    end
    additional_distance = sum(ad)/400;
    new_satisfactory = sum(ns)/400;
    count = numel(F1);
    for i = 1: count
        F1(i).ad = additional_distance(i);
        F1(i).ns = new_satisfactory(i);
        [F1(i).depot,F1(i).vehicle] = depot(F1(i),data);
    end
    fit = [F1.fitness];
    fit1 = fit(1:2:end);
    fit2 = fit(2:2:end);
    result(j,7) = length(unique(fit1));
    result(j,1) = min(fit1);
    result(j,2) = min(fit2);
    result(j,3) = sum(fit1)/count;
    result(j,4) = sum(fit2)/count;
    result(j,5) = sum(additional_distance)/count;
    result(j,6) = sum(new_satisfactory)/count*1000;
    result(j,8) = sum([F1.depot])/count;
    result(j,9) = sum([F1.vehicle])/count;
    result(j,10) = toc;
    solution{j} = F1;
end
    %帕累托平面
    figure(1)
    draw2(x(F{1}));
    toc
