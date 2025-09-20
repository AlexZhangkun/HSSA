%% NSGA-II
clear;clc;
tic
% load instance
% load instance20
load ceshi
Num = 80; %��Ⱥ����
max_iter = 200;
data.alpha = 1; % ���������
data.DPI = 0.6;
data.API = 1;
%% ���ɳ�ʼ��Ⱥ��̰�ľ����㷨��
ex.route = [];%·��
ex.fit = [];%��Ӧ��ֵ
ex.rank = [];%����ȼ�
ex.doset = [];%��֧��ļ���
ex.docount = [];%��֧��Ĵ���
ex.CrowdDistance = 0;%ӵ������
x = repmat(ex,Num,1);
t=1;
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
for i = 1: max_iter
    x1 = crossover(x,ex,data,F);%����
    x2 = mutation(x,ex,data);%����
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
    additional_distance = sum(ad)/400;
    new_satisfactory = sum(ns)/400;
    count = numel(F1);
    for i = 1: count
        F1(i).ad = additional_distance(i);
        F1(i).ns = new_satisfactory(i);
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
%% ��ͼ
    figure
%     hold on
%     drawpath(F1,additional_distance,new_satisfactory);
    draw2(F1)
    toc