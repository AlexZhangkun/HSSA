function y = time_satis_compute(tw,time)
%tw:时间窗，time:抵达时间，ft：模糊行驶时间
%% 计算服务时间的满意度
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
% tt = zeros(M+N,M+N); %记录每个点之间的行驶时间
% mu = cell(1,Num); %记录每一次迭代的隶属度函数值
% for l = 1 : Num
%     for i = 1 : l
%         for j = i + 1 : l
%             tt(i,j) = randi([ft{i,j}(1),ft{i,j}(3)]); %行驶时间
%             mu{l} = min([mu{l},mumembership(tt(i,j),ft{i,j})]); %计算隶属度函数值
%         end
%     end
% end
    
    
        
    