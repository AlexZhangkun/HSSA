function x = swap2or3(x)
b = randi(3); %%单点，2，3
a = sort(randperm(length(x) - b,2));
x(a(1):a(2)+b-1) = [x(a(1)),x(a(2):a(2)+ b-1),x(a(1)+1:a(2)-1)];
a = sort(randperm(length(x),2));
x(a(1):a(2)) = [x(a(1)),x(a(2)),x(a(1)+1:a(2)-1)];