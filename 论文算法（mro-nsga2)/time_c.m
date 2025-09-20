function y = time_c(tw,time)
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