%% NSGA-II
clear;clc;
tic
% load instance
load instance20
Num = 80; %��Ⱥ����
max_iter = 100;
data.alpha = 1; % ���������
data.DPI = 1;
data.API = 1;
%% ���ɳ�ʼ��Ⱥ��̰�ľ����㷨��
x1.route = [];%·��
x1.fit = [];%��Ӧ��ֵ
x1.rank = [];%����ȼ�
x1.doset = [];%��֧��ļ���
x1.docount = [];%��֧��Ĵ���
x1.CrowdDistance = 0;%ӵ������
x = repmat(x1,Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %��ʼ�����н�
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %������Ӧ��ֵ
end
[x, F] = NDS_CCD(x, Num); %��֧�������

%% main loop 
for i = 1: iter_max
    x1 = crossover(x,x1,data);%����
    x2 = mutation(x,x1,data);%����
    pop = [x;x1;x2]; %��Ⱥ�ϲ�
    [x, F] = NDS_CCD(pop,Num);%��֧��������ӵ���������
    F1 = x(F{1});
    disp(['Iteration ' num2str(i) ': Number of F1 Members = ' num2str(numel(F1))]);
end

%% stochastic simulation 
ad = zeros(400,numel(F1));%������ʻ����
ns = zeros(400,numel(F1));%�µķ��������
for i = 1 : 400
    data = simular_demand(data);
    [ad(i,:),ns(i,:)] = simu(F1,data);
end
additional_distance = sum(ad);
new_satisfactory = 1./sum(ns);
%% ��ͼ
figure
hold on
for i = 1: numel(F1)
    plot(F1(i).fitness(1),F1(i).fitness(2),'r*');
end
xlabel('f1'); ylabel('f2');
title('Pareto Optimal Front');
toc