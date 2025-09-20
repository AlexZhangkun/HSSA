function x= inverse(x)
a = sort(randperm(length(x)-1,2))+1;%随机选择两个点进行两点之间元素的逆转
x = [x(1:a(1)-1),x(a(2):-1:a(1)),x(a(2)+1:end)];