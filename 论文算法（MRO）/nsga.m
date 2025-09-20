%% NSGA����ģ������Ķ೵�Ͷ�Ŀ���ʱ�䴰��ѡַ·������
clear;clc;close all;
tic
% load 10-3 %�������� depot customer demand Q P O F tw 
load instance
Num = 60; %��Ⱥ����
max_iter = 100;
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
%% ��ʼ��Ⱥ����
x = repmat(ex,Num,1);
for i = 1 : data.l
    data.D{i} = dis1([data.depot{i};data.customer],[data.depot{i};data.customer]);
    data.time{i} = data.D{i}/data.v;
end
for i = 1 : Num
    [x(i).route,x(i).arrtime] = greedy_cluster(data); %��ʼ�����н�
    x(i).fit = fun(x(i).route,x(i).arrtime,data); %������Ӧ��ֵ
end
[x, F, data] = NS(x, data, Num); %��֧�������

%% main Loop
for iter = 1 : max_iter
    x1 = crossover(x,ex,data);%����
    x2 = mutation(x,ex,data);%����
    newx = [x;x1;x2]; %�ϲ���Ⱥ
    [x, F, para] = NS(newx, data, Num); %��֧�������
    F1 = x(F{1});
    disp(['Iteration ' num2str(iter) ': Number of F1 Members = ' num2str(numel(F1))]);
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