function y = fun(x,D,C,F,O,I)
% D:������� C ����λ������� F�� �������� O�� �ֿ⿪�ŷ��� I ���ֿ�����
if nargin <= 4
    I = 1;O = 0;
end
if C == 100
    D = ceil(D*C);
end
distance = 0;%���㳵����ʻ����
c = find(x<=I);
v_num = length(c); %������Ŀ
dep = []; %��¼���õĲֿ�
for i = 1 : v_num 
    if i == v_num
        if length(c(i):length(x))~=1
            for j = c(i) : length(x)-1
                distance = distance + D(x(j),x(j+1));
            end
            distance = distance +D(x(j+1),x(c(i)));  %OLRP�������һ��
            dep = [dep,x(c(i))]; 
        end
    else
        if length(c(i):c(i+1))~=2
            for j = c(i):c(i+1)-2
                distance = distance + D(x(j),x(j+1));
            end
            distance = distance +D(x(j+1),x(c(i)));  %OLRP�������һ��
            dep = [dep,x(c(i))];
        end
    end
end
cost_vehicle = v_num * F;%�������÷���
cost_depot = sum(O(unique(dep))); %�ֿ����÷���
cost_distance = distance; %�������
y = cost_distance+cost_vehicle+cost_depot; %�ܷ���
end