function y = time_satis_compute(tw,time)
%tw:ʱ�䴰��time:�ִ�ʱ�䣬ft��ģ����ʻʱ��
%% �������ʱ��������
if time <= tw(1)
    y = 0;
elseif tw(1) < time && time <= tw(2)
    y = (time - tw(1))/(tw(2)-tw(1));
elseif tw(2) < time && time <= tw(3)
    y = 1;
elseif tw(3) < time && time <= tw(4)
    y = (tw(4) - time)/(tw(4)-tw(3));
else
    y = 0;
end
% tt = zeros(M+N,M+N); %��¼ÿ����֮�����ʻʱ��
% mu = cell(1,Num); %��¼ÿһ�ε����������Ⱥ���ֵ
% for l = 1 : Num
%     for i = 1 : l
%         for j = i + 1 : l
%             tt(i,j) = randi([ft{i,j}(1),ft{i,j}(3)]); %��ʻʱ��
%             mu{l} = min([mu{l},mumembership(tt(i,j),ft{i,j})]); %���������Ⱥ���ֵ
%         end
%     end
% end
    
    
        
    