function y = fun(x1,x2,data)
%% 第一个目标：各类费用之和最小,第二个目标：客户服务满意度  
    distance = 0;d = [];k = 0; statisfy = zeros(1,data.N);
    for j = 1 : length(x1)
        if  x1(j)<= data.M %路线结束
            if j < length(x1)
                if x1(j+1) > data.M
                    k = k + 1;
                    distance = distance + data.p2c(x1(j)) + data.p2c(x1(j+1)); %一段从停车场到第一个客户和从停车场到回收点的距离
                    d = [d,x1(j)]; %记录启用的仓库
                end
            end
        else
            if j < length(x1)
                if x1(j+1) <= data.M
                    distance = distance + data.D(x1(j),d(end));
                    statisfy(x1(j)-data.M) = statisfy(x1(j)-data.M) + time_c(data.tw(x1(j)-data.M,:),x2(x1(j)-data.M));
                else
                    distance = distance + data.D(x1(j),x1(j+1));
                    statisfy(x1(j)-data.M) = statisfy(x1(j)-data.M) + time_c(data.tw(x1(j)-data.M,:),x2(x1(j)-data.M));
                end
            else
                distance = distance + data.D(x1(j),d(end));
                statisfy(x1(j)-data.M) = statisfy(x1(j)-data.M) + time_c(data.tw(x1(j)-data.M,:),x2(x1(j)-data.M));
            end
        end
    end
    y1 = sum(distance);
    y2 = sum(k*data.F);
    y3 = sum(data.O(unique(d),1));
    y(1) = roundn(y1 + y2 + y3,-2); %固定费用
    y(2) = roundn(1/sum(statisfy)*100,-4); %满意度
end
    
