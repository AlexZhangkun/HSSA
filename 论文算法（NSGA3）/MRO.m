%% Ģ����ֳ�㷨��mushroom reproduction optimization algorithm��
%% ��ʼ������
clear;clc;   
tic
load instance
data.alpha = 0.8; % ���������
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
r = 10;                                                    %�ֲ������İ뾶
c = 12;                                                      %��ֵ
iter_max = 100;                                             %�㷨��������    
Num = 30; c_num = 3;                                        %��Ⱥ������ÿ�������������Ӵ�����
%% ��ʼ����Ⱥ
x = repmat(ex,Num,1);
x_child = repmat(ex,c_num*Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %��ʼ�����н�
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %������Ӧ��ֵ
    for j = 1 : c_num
        x_child((i-1)*c_num + j) = mutation(x(i),ex,data);
        x_child((i-1)*c_num + j).fit = fun(x_child((i-1)*c_num + j).route,x_child((i-1)*c_num + j).arrtime,data);
    end
end

[x, F, data] = NS(x, data, Num); %��֧�������
%% ��ѭ��
iter_num = 1;
while iter_num <= iter_max 
    for i = 1 : M
        if average(i)+T_ave/c < T_ave                                                                           %c:��ֵ�����ھ����Ƿ�ɾ����Ⱥ
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
            x2 = mutation(x,ex,data);%��������
        end
        average(i) = sum(fitness(i,:))/N;                                       %����������Ⱥ��Ӧ�Ⱦ�ֵ    
    end
    T_ave = sum(average)/length(average);                                                                   %�������������Ⱥ����ƽ��ֵ                                                                               %��¼ÿһ��������ֵ            
    iter_num = iter_num + 1;
end

%% simulation procedure
ad = zeros(400,numel(F1));%������ʻ����
ns = zeros(400,numel(F1));%�µķ��������
for i = 1 : 400
    data = simular_demand(data);
    [ad(i,:),ns(i,:)] = simu(F1,data);
end

%% draw picture
    figure(1)
    drawpath(F1);
toc


    
