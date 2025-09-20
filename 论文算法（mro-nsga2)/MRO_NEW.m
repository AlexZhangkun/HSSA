%% 蘑菇繁殖算法（mushroom reproduction optimization algorithm）
%% 初始化参数
clear;clc;   
tic
% load instance
% load 30-5
% load 30-5_t1
% load 30-5_t2
% load 50-5
% load 100-10
load real_instance
data.alpha = 1; % 服务满意度
data.API = 1;
data.C = 0.006;
data.DPI = 0.6;
ex.arrtime = [];
ex.route = [];%路线
ex.fit = [];%适应度值
ex.rank = [];%排序等级
ex.doset = [];%被支配的集合
ex.docount = [];%被支配的次数
ex.CrowdDistance = 0;%拥挤距离                                               
r = 10;                                                     %局部搜索的半径
c = 12;                                                     %阈值
iter_max = 600;                                             %算法迭代次数    
Num = 50; c_num = 1;                                        %种群数量和每个父代产生的子代数量
result = cell(1,10); sol1 = cell(10,5); sol2=cell(10,5);
for l = 1 : 1
%     data.alpha = 0.9; % 服务满意度
%     data.API = 1;
%     data.C = 1;
for o = 1 : 1
%     result{o} = zeros(5,9); 
%     data.DPI = 0.1*6;
for t = 1 : 1
%% 初始化种群
    x = repmat(ex,Num,1);
    x_child = repmat(ex,c_num*Num,1);
%         data.D{i} = dis([data.depot{i};data.customer],[data.depot{i};data.customer]);
%         data.p2c(i,:) = dis(data.park,[data.depot{i};data.customer]);
    data = calculatell(data);
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
    [x,x_child, F] = NDS_CCD([x,x_child], Num+Num*c_num,c_num);

%% 主循环
    iter_num = 1;
    while iter_num <= iter_max 
        for i = 1 : Num
            if sum(average(i,:)+T_ave/c < T_ave)>0                                                                           %c:阈值，用于决定是否删除种群
                for k = 1 : Num                                                                                
                    for j = 1 : c_num
                        index1 = dominate(x(i),x(k));
                        index2 = dominate(x(k),x(i));
                        if (index1  == 0 && rand<=0.5) || index1 == 1  
                            x1 = crossover(x(i),x(k),ex,data);
                            x = [x,x1];
                        elseif (index2  == 0 && rand<=0.5) || index2 == 1
                            x1 = crossover(x(k),x(i),ex,data);
                            x = [x,x1];
                        end
                    end
                end
            end
            for j = 1 : c_num                                                               
                x2 = mutation(x(i),ex,data);%邻域搜索
                x = [x,x2]; 
            end         
        end
        [x,x_child, F] = NDS_CCD([x,x_child], Num+Num*c_num,c_num);
        if numel(F{1}) > length(x)
            x = [x,x_child];
        end
        F1 = x(F{1});
        fit = [x.fit,x_child.fit];    fit1 = fit(1:2:end);    fit2 = fit(2:2:end);
        for j = 1 : Num
            average(j,1) = sum([fit1(j),fit1(Num+1+(j-1)*c_num : Num+j*c_num)])/(c_num+1);
            average(j,2) = sum([fit2(j),fit2(Num+1+(j-1)*c_num : Num+j*c_num)])/(c_num+1);
        end
        T_ave = sum(average)/Num;                                              %计算代数所有种群的总平均值     
        disp(['Iteration ' num2str(iter_num) ': Number of F1 Members = ' num2str(numel(F1))]);         
        iter_num = iter_num + 1;
    end

%% simulation procedure
    count = numel(F1);
    sol1{o,t} = F1;
    fit = [F1.fit];
    fit1 = fit(1:2:end);
    result{o}(t,7) = length(unique(fit1));
    if result{o}(t,7) ~= 1
        [~,b] = min([F1.CrowdDistance]);
        F2 = F1(b); a = F1(b).fit(1);
        for h = 1 : count
            if F1(h).CrowdDistance == F1(b).CrowdDistance
                if   ~ismember(F1(h).fit(1), a)
                    F2 = [F2,F1(h)]; a = [a, F1(h).fit(1)];
                end
            end
        end
    else
        F2 = F1(1);
    end
    ad = zeros(400,numel(F2));%额外行驶距离
    ns = zeros(400,numel(F2));%新的服务满意度
    for i = 1 : 400
        data = simular_demand(data);
        [ad(i,:),ns(i,:)] = simu(F2,data);
    end
        additional_distance = sum(ad)/400;
        new_satisfactory = sum(ns)/400;
        toc
    for i = 1: numel(F2)
        F2(i).ad = additional_distance(i);
        F2(i).ns = new_satisfactory(i);
        [F2(i).depot,F2(i).vehicle] = depot(F2(i),data);
    end
        sol2{o,t} = F2;
        num = numel(F2);
        fit = [F2.fit];
        fit1 = fit(1:2:end);
        fit2 = fit(2:2:end)*1000;
        result{o}(t,1) = min(fit1);
        result{o}(t,2) = min(fit2);
        result{o}(t,3) = sum(fit1)/num;
        result{o}(t,4) = sum(fit2)/num;
        result{o}(t,5) = sum(additional_distance)/num;
        result{o}(t,6) = sum(new_satisfactory)/num*1000;
      
        result{o}(t,8) = sum([F2.depot])/num;
        result{o}(t,9) = sum([F2.vehicle])/num;
        result{o}(t,10) = toc;
%         [~,a1] = min(fit1);
%         [~,a2] = min(fit2);
%         solu1((o-1)*5 + t) = F1(a1);
%         solu2((o-1)*5 + t) = F1(a2);

end
end
end

%% draw picture
    figure(1)
%     drawpath(F1,additional_distance,new_satisfactory);%带额外距离的三维
    draw2(F1) %2维


    
