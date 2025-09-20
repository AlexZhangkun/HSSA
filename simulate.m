function [ad,ns] = simulate(F1,data)
%% 随机模拟程序模拟额外车辆行驶距离以及更新时间窗下的客户服务满意度
ad = zeros(1,numel(F1)); ns = zeros(1,numel(F1));        
for i = 1: numel(F1) 
    satisfactory = zeros(data.l,data.N);
    ad_distance = zeros(1,data.l); 
    time = zeros(data.l,data.N);  
    point = find(F1(i).route <= data.M);%分割线路
    for k = 1 : numel(point)
        if k < numel(point)
            x = F1(i).route(point(k):point(k+1)-1);
        else
            x = F1(i).route(point(k):end);
        end
        if length(x)>1
            q = data.Q; p = data.P; 
            t = F1(i).arrtime(x(2)-data.M);%初始时间点 
            for l = 2 : numel(x)
                if q >= data.actualDemand(x(l)-data.M) && p(x(1)) >= data.actualDemand(x(l)-data.M) %判断车辆与仓库容量是否满足限制，基本不用考虑仓库容量不足的情况，不符合实际
                    q = q - data.actualDemand(x(l)-data.M);
                    p(x(1)) = p(x(1)) - data.actualDemand(x(l)-data.M);
                    if l == 2
                        t = F1(i).arrtime(x(l)-data.M);
                    else
                        t = t + data.time(x(l-1),x(l));
                    end
                    time(x(l)-data.M) = t; % 记录运输时间点
                    t = t + data.tw(x(l)-data.M,5);
                    satisfactory(x(l)-data.M) = satisfactory(x(l)-data.M) + time_satis_compute(data.tw(x(l)-data.M,:),time(x(l)-data.M));%计算服务满意度
                elseif q < data.actualDemand(x(l)-data.M) && p(x(1)) >= data.actualDemand(x(l)-data.M) %车辆剩余容量不足以服务客户但是仓库容量足够
                    ad_distance = ad_distance + 2 * data.D(x(l),x(1)); %额外行驶距离
                    t = t + 2 * data.time(x(l),x(1));
                    time(x(l)-data.M) = t; %时间窗变动 
                    t = t + data.tw(x(l)-data.M,5);
                    satisfactory(x(l)-data.M) = satisfactory(x(l)-data.M) + time_satis_compute(data.tw(x(l)-data.M,:),time(x(l)-data.M));%服务满意度变动
                    p(x(1)) = p(x(1)) - data.actualDemand(x(l)-data.M);
                    q = data.Q - data.actualDemand(x(l)-data.M); 
                end
            end
        end
    end
    ad(i) = sum(ad_distance); %额外行驶距离
    ns(i) = 1/sum(sum(satisfactory)); %满意度
end
end