%% 蘑菇繁殖算法（mushroom reproduction optimization algorithm）
%% 初始化参数
clear;clc;   
tic
load instance
data.alpha = 1; % 服务满意度
data.DPI = 1; 
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
iter_max = 400;                                             %算法迭代次数    
Num = 60; c_num = 1;                                        %种群数量和每个父代产生的子代数量
t = 1;
%% 初始化种群
x = repmat(ex,Num,1);
x_child = repmat(ex,c_num*Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
average = zeros(Num,2);
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %初始化可行解
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %计算适应度值
    for j = 1 : c_num
        x_child((i-1)*c_num + j) = mutation(x(i),ex,data);
        x_child((i-1)*c_num + j).fit = fun(x_child((i-1)*c_num + j).route,x_child((i-1)*c_num + j).arrtime,data);
    end
    fit = [x(i).fit,x_child((i-1)*c_num + 1:(i-1)*c_num + j).fit];
    average(i,1) = sum(fit(1:2:end))/(c_num+1);
    average(i,2) = sum(fit(2:2:end))/(c_num+1);
end
T_ave = sum(average)/Num;
[x,x_child, F, data] = NS([x;x_child], data, Num+Num*c_num,c_num); %非支配解排序

%% 主循环
iter_num = 1;
while iter_num <= iter_max 
    for i = 1 : Num
        if sum(average(i,:)+T_ave/c < T_ave)>0                                                                           %c:阈值，用于决定是否删除种群
            for k = 1 : Num                                                                                
                for j = 1 : c_num
                    if dominate(x(i),x(k)) ~= 0
                        x1 = repmat(ex,c_num,1);
                        if rand <=0.5           %x(i),x((i-1)*c_cum + j)
                            x1(j) = crossover(x(i),x((i-1)*c_num + j),ex,data);%交叉
                        else                %F1(randperm(numel(F1),1)),x((i-1)*c_cum + j) 从F1里面随机选择一个进行交叉
                            if iter_num == 1
                                E = x(F{1}(randperm(length(F{1}),1)));
                            else
                                E = F1(randperm(numel(F1),1));
                            end
                            x1(j) = crossover(E,x((i-1)*c_num + j),ex,data);%交叉
                        end
                    end
                end
                x = [x;x1];
            end
        end
        x2 = repmat(ex,c_num,1);
        for j = 1 : c_num                                                               
            x2(j) = mutation(x(i),ex,data);%邻域搜索
        end   
        x = [x;x2];       
    end
    [x,x_child, F, data] = NS([x;x_child], data, Num+Num*c_num,c_num); 
    F1 = x(F{1});
    fit = [x.fit,x_child.fit];
    fit1 = fit(1:2:end);
    fit2 = fit(2:2:end);
    for j = 1 : Num
        average(j,1) = sum([fit1(j),fit1(Num+1+(j-1)*c_num : Num+j*c_num)])/(c_num+1);
        average(j,2) = sum([fit2(j),fit2(Num+1+(j-1)*c_num : Num+j*c_num)])/(c_num+1);
    end
    T_ave = sum(average)/Num;                                              %计算代数所有种群的总平均值     
    disp(['Iteration ' num2str(iter_num) ': Number of F1 Members = ' num2str(numel(F1))]);         
    iter_num = iter_num + 1;
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
%% draw picture
    figure(1)
%     drawpath(F1,additional_distance,new_satisfactory);%带额外距离的三维
    draw2(F1) %2维
toc

    
