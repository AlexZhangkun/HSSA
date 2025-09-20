function [ad,ns] = simu(F1,data)
%% 随机模拟程序模拟额外车辆行驶距离以及更新时间窗下的客户服务满意度
ad = zeros(1,numel(F1)); ns = zeros(1,numel(F1));        
for i = 1: numel(F1) 
    satisfactory = zeros(data.l,data.N);
    ad_distance = zeros(1,data.l); 
    time = zeros(data.l,data.N);  
    for j = 1 : data.l
        point = find(F1(i).route{j} <= data.M);%分割线路
        for k = 1 : numel(point)
            if k < numel(point)
                x = F1(i).route{j}(point(k):point(k+1)-1);
            else
                x = F1(i).route{j}(point(k):end);
            end
            if length(x)>1
                q = data.Q(j); p = data.P(:,j); 
                t = data.tw{j}(x(2)-data.M,2);%初始时间点 
                for l = 2 : numel(x)
                    if q >= data.actualDemand{j}(x(l)-data.M) && p(x(1)) >= data.actualDemand{j}(x(l)-data.M) %不考虑仓库容量不足的情况，不符合实际
                        q = q - data.actualDemand{j}(x(l)-data.M);
                        p(x(1)) = p(x(1)) - data.actualDemand{j}(x(l)-data.M);
                        t = t + data.time{j}(x(l-1),x(l))+ data.tw{j}(x(l)-data.M,5);
                        time(j,x(l)-data.M) = t; % 记录运输时间点
                        satisfactory(j,x(l)-data.M) = satisfactory(j,x(l)-data.M) + time_c(data.tw{j}(x(l)-data.M,:),time(j,x(l)-data.M));%计算服务满意度
                    elseif q < data.actualDemand{j}(x(l)-data.M) && p(x(1)) >= data.actualDemand{j}(x(l)-data.M) %车辆剩余容量不足以服务客户但是仓库足够
                        ad_distance(j) = ad_distance(j) + 2 * data.D{j}(x(l),x(1)); %额外行驶距离
                        t = t + 2 * data.time{j}(x(l),x(1));
                        time(j,x(l)-data.M) = t; %时间窗变动 
                        satisfactory(j,x(l)-data.M) = satisfactory(j,x(l)-data.M) + time_c(data.tw{j}(x(l)-data.M,:),time(j,x(l)-data.M));%服务满意度变动
                        p(x(1)) = p(x(1)) - data.actualDemand{j}(x(l)-data.M);
                        q = data.Q(j) - data.actualDemand{j}(x(l)-data.M); 
                    end
                end
            end
        end
    end
    ad(i) = sum(ad_distance); %额外行驶距离
    ns(i) = 1/sum(sum(satisfactory)); %满意度
end
end