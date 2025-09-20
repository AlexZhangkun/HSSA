function [ad,ns] = simu(F1,data)
%% ���ģ�����ģ����⳵����ʻ�����Լ�����ʱ�䴰�µĿͻ����������
ad = zeros(1,numel(F1)); ns = zeros(1,numel(F1));        
for i = 1: numel(F1) 
    satisfactory = zeros(data.l,data.N);
    ad_distance = zeros(1,data.l); 
    time = zeros(data.l,data.N);  
    for j = 1 : data.l
        point = find(F1(i).route{j} <= data.M);%�ָ���·
        for k = 1 : numel(point)
            if k < numel(point)
                x = F1(i).route{j}(point(k):point(k+1)-1);
            else
                x = F1(i).route{j}(point(k):end);
            end
            if length(x)>1
                q = data.Q(j); p = data.P(:,j); 
                t = data.tw{j}(x(2)-data.M,2);%��ʼʱ��� 
                for l = 2 : numel(x)
                    if q >= data.actualDemand{j}(x(l)-data.M) && p(x(1)) >= data.actualDemand{j}(x(l)-data.M) %�����ǲֿ���������������������ʵ��
                        q = q - data.actualDemand{j}(x(l)-data.M);
                        p(x(1)) = p(x(1)) - data.actualDemand{j}(x(l)-data.M);
                        t = t + data.time{j}(x(l-1),x(l))+ data.tw{j}(x(l)-data.M,5);
                        time(j,x(l)-data.M) = t; % ��¼����ʱ���
                        satisfactory(j,x(l)-data.M) = satisfactory(j,x(l)-data.M) + time_c(data.tw{j}(x(l)-data.M,:),time(j,x(l)-data.M));%������������
                    elseif q < data.actualDemand{j}(x(l)-data.M) && p(x(1)) >= data.actualDemand{j}(x(l)-data.M) %����ʣ�����������Է���ͻ����ǲֿ��㹻
                        ad_distance(j) = ad_distance(j) + 2 * data.D{j}(x(l),x(1)); %������ʻ����
                        t = t + 2 * data.time{j}(x(l),x(1));
                        time(j,x(l)-data.M) = t; %ʱ�䴰�䶯 
                        satisfactory(j,x(l)-data.M) = satisfactory(j,x(l)-data.M) + time_c(data.tw{j}(x(l)-data.M,:),time(j,x(l)-data.M));%��������ȱ䶯
                        p(x(1)) = p(x(1)) - data.actualDemand{j}(x(l)-data.M);
                        q = data.Q(j) - data.actualDemand{j}(x(l)-data.M); 
                    end
                end
            end
        end
    end
    ad(i) = sum(ad_distance); %������ʻ����
    ns(i) = 1/sum(sum(satisfactory)); %�����
end
end