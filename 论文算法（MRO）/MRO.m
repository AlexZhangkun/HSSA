%% Ģ����ֳ�㷨��mushroom reproduction optimization algorithm��
%% ��ʼ������
clear;clc;   
tic
load instance
data.alpha = 1; % ���������
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
r = 10;                                                    %�ֲ������İ뾶
c = 12;                                                      %��ֵ
iter_max = 400;                                             %�㷨��������    
Num = 60; c_num = 1;                                        %��Ⱥ������ÿ�������������Ӵ�����
t = 1;
%% ��ʼ����Ⱥ
x = repmat(ex,Num,1);
x_child = repmat(ex,c_num*Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
average = zeros(Num,2);
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %��ʼ�����н�
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %������Ӧ��ֵ
    for j = 1 : c_num
        x_child((i-1)*c_num + j) = mutation(x(i),ex,data);
        x_child((i-1)*c_num + j).fit = fun(x_child((i-1)*c_num + j).route,x_child((i-1)*c_num + j).arrtime,data);
    end
    fit = [x(i).fit,x_child((i-1)*c_num + 1:(i-1)*c_num + j).fit];
    average(i,1) = sum(fit(1:2:end))/(c_num+1);
    average(i,2) = sum(fit(2:2:end))/(c_num+1);
end
T_ave = sum(average)/Num;
[x,x_child, F, data] = NS([x;x_child], data, Num+Num*c_num,c_num); %��֧�������

%% ��ѭ��
iter_num = 1;
while iter_num <= iter_max 
    for i = 1 : Num
        if sum(average(i,:)+T_ave/c < T_ave)>0                                                                           %c:��ֵ�����ھ����Ƿ�ɾ����Ⱥ
            for k = 1 : Num                                                                                
                for j = 1 : c_num
                    if dominate(x(i),x(k)) ~= 0
                        x1 = repmat(ex,c_num,1);
                        if rand <=0.5           %x(i),x((i-1)*c_cum + j)
                            x1(j) = crossover(x(i),x((i-1)*c_num + j),ex,data);%����
                        else                %F1(randperm(numel(F1),1)),x((i-1)*c_cum + j) ��F1�������ѡ��һ�����н���
                            if iter_num == 1
                                E = x(F{1}(randperm(length(F{1}),1)));
                            else
                                E = F1(randperm(numel(F1),1));
                            end
                            x1(j) = crossover(E,x((i-1)*c_num + j),ex,data);%����
                        end
                    end
                end
                x = [x;x1];
            end
        end
        x2 = repmat(ex,c_num,1);
        for j = 1 : c_num                                                               
            x2(j) = mutation(x(i),ex,data);%��������
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
    T_ave = sum(average)/Num;                                              %�������������Ⱥ����ƽ��ֵ     
    disp(['Iteration ' num2str(iter_num) ': Number of F1 Members = ' num2str(numel(F1))]);         
    iter_num = iter_num + 1;
end

%% simulation procedure
ad = zeros(400,numel(F1));%������ʻ����
ns = zeros(400,numel(F1));%�µķ��������
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
%     drawpath(F1,additional_distance,new_satisfactory);%������������ά
    draw2(F1) %2ά
toc

    
