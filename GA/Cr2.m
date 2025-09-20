function y = Cr2(time,tw,alpha)
% tw : time window
tw1 = tw * alpha;
if time(1) >= tw1(1) && time(3) <= tw(4)
    y = 1;
else
    y = 0;
end
end 
