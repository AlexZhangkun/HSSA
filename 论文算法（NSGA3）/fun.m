function y = fun(x1,x2,data)
%% ��һ��Ŀ�꣺�������֮����С,�ڶ���Ŀ�꣺�ͻ����������  
    len = numel(x1);
    distance = zeros(1,len);d = cell(1,2);k = zeros(1,len); statisfy = zeros(1,data.N);
    for i = 1: len
        for j = 1 : length(x1{i})
            if  x1{i}(j)<= data.M %·�߽���
                if j < length(x1{i})
                    if x1{i}(j+1) > data.M
                        k(i) = k(i) + 1;
                        distance(i) = distance(i) + data.p2c(i,(x1{i}(j)))+ data.p2c(i,x1{i}(j+1));
                        d{i} = [d{i},x1{i}(j)]; %��¼���õĲֿ�
                    end
                end
            else
                if j < length(x1{i})
                    if x1{i}(j+1) <= data.M
                        distance(i) = distance(i) + data.D{i}(x1{i}(j),d{i}(end));
                        statisfy(x1{i}(j)-data.M) = statisfy(x1{i}(j)-data.M) + time_c(data.tw{i}(x1{i}(j)-data.M,:),x2(i,x1{i}(j)-data.M));
                    else
                        distance(i) = distance(i) + data.D{i}(x1{i}(j),x1{i}(j+1));
                        statisfy(x1{i}(j)-data.M) = statisfy(x1{i}(j)-data.M) + time_c(data.tw{i}(x1{i}(j)-data.M,:),x2(i,x1{i}(j)-data.M));
                    end
                else
                    distance(i) = distance(i) + data.D{i}(x1{i}(j),d{i}(end));
                    statisfy(x1{i}(j)-data.M) = statisfy(x1{i}(j)-data.M) + time_c(data.tw{i}(x1{i}(j)-data.M,:),x2(i,x1{i}(j)-data.M));
                end
            end
        end
    end
    y1 = sum(distance)*data.C;
    y2 = sum(k(1)*data.F(1)+k(2)*data.F(2));
    y3 = sum(data.O(unique(d{1}),1)) + sum(data.O(unique(d{2}),2));
    y(1) = y1 + y2 + y3; %�̶�����
    y(2) = 1/sum(statisfy); %�����
end
    
