function [ad,ns] = simu(F1,data)
%% ���ģ�����ģ����⳵����ʻ�����Լ�����ʱ�䴰�µĿͻ����������
ad = zeros(1,numel(F1)); ns = zeros(1,numel(F1));        
for i = 1: numel(F1) 
    satisfactory = zeros(1,data.N);
    ad_distance = 0;
    time = zeros(1,data.N);  
    point = find(F1(i).route <= data.M);%�ָ���·
    for k = 1 : numel(point)
        if k < numel(point)
            x = F1(i).route(point(k):point(k+1)-1);
        else
            x = F1(i).route(point(k):end);
        end
        if length(x)>1
            q = data.Q; p = data.P; 
            t = F1(i).time(x(2)-data.M);%��ʼʱ��� 
            for l = 2 : numel(x)
                if q >= data.actualDemand(x(l)-data.M) && p(x(1)) >= data.actualDemand(x(l)-data.M) %�����ǲֿ���������������������ʵ��
                    q = q - data.actualDemand(x(l)-data.M);
                    p(x(1)) = p(x(1)) - data.actualDemand(x(l)-data.M);
                    if l == 2
                        t = F1(i).time(x(l)-data.M);
                    else
                        t = t + data.time(x(l-1),x(l));
                    end
                    time(x(l)-data.M) = t; % ��¼����ʱ���
                    t = t + data.tw(x(l)-data.M,5);
                    satisfactory(x(l)-data.M) = satisfactory(x(l)-data.M) + time_c(data.tw(x(l)-data.M,:),time(x(l)-data.M));%������������
                elseif q < data.actualDemand(x(l)-data.M) && p(x(1)) >= data.actualDemand(x(l)-data.M) %����ʣ�����������Է���ͻ����ǲֿ��㹻
                    ad_distance = ad_distance + 2 * data.D(x(l),x(1)); %������ʻ����
                    t = t + 2 * data.time(x(l),x(1));
                    time(x(l)-data.M) = t; %ʱ�䴰�䶯 
                    t = t + data.tw(x(l)-data.M,5);
                    satisfactory(x(l)-data.M) = satisfactory(x(l)-data.M) + time_c(data.tw(x(l)-data.M,:),time(x(l)-data.M));%��������ȱ䶯
                    p(x(1)) = p(x(1)) - data.actualDemand(x(l)-data.M);
                    q = data.Q - data.actualDemand(x(l)-data.M); 
                end
            end
        end
    end
    ad(i) = sum(ad_distance); %������ʻ����
    ns(i) = 1/sum(sum(satisfactory)); %�����
end
end