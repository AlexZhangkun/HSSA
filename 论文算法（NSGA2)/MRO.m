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
Num = 20; c_num = 3;                                        %��Ⱥ������ÿ�������������Ӵ�����
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
        fit = [x(i).fit];
        if sum(average(i,:)+T_ave/c < T_ave)>0                                                                           %c:��ֵ�����ھ����Ƿ�ɾ����Ⱥ
            for k = 1 : Num                                                                                
                for j = 1 : c_num
                    if dominates(x(i),x(k)) == 1
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
            x2(j) = mutation(x,ex,data);%��������
        end   
        if ~isempty(x1)
            X = [x1;x2];
        else
            X = x2;
        end
        x = [x;x_child;X];
        [x,x_child, F, data] = NS([x;x_child], data, Num+Num*c_num,c_num);            
    end
    T_ave = sum(average)/Num;                                              %�������������Ⱥ����ƽ��ֵ                                                                               %��¼ÿһ��������ֵ            
    iter_num = iter_num + 1;
end

%% simulation procedure
ad = zeros(400,numel(F1));%������ʻ����
ns = zeros(400,numel(F1));%�µķ��������
for i = 1 : 400
    data = simular_demand(data);
    [ad(i,:),ns(i,:)] = simu(F1,data);
end
additional_distance = sum(ad);
new_satisfactory = 1/sum(ns);
%% draw picture
    figure(1,2)
%     drawpath(F1,additional_distance,new_satisfactory);%������������ά
    draw2(F1) %2ά
toc

    
