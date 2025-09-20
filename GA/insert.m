function x = insert(x)
a = sort(randperm(length(x),2));
x(a(1):a(2)) = [x(a(1)),x(a(2)),x(a(1)+1:a(2)-1)];