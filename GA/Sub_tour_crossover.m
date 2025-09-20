function [x1,x2] = Sub_tour_crossover(E,X)
if length(E)<length(X)
    len = length(E);
else
    len = length(X);
end
index = sort(randperm(len,2));
x1 = E(1:index(1)-1);
for i = index(1):index(2)
    a = X(X == E(i));
    if ~isempty(a)
        x1 = [x1,a(1)];
    else
        x1 = [x1,E(i)];
    end
end
if index(2) == length(E) || index(2) == length(X)
else
    x1 = [x1,E(index(2)+1:end)];
end
if unique(x1)<50
    b = 0;
end
x2 = X(1:index(1)-1);
for i = index(1):index(2)
    a = E(E == X(i));
    if ~isempty(a)
        x2 = [x2,a(1)];
    else
        x2 = [x2,E(i)];
    end
end
if index(2) == length(E) || index(2) == length(X)
else
    x2 = [x2,X(index(2)+1:end)];
end
if unique(x2)<50
    b = 0;
end
