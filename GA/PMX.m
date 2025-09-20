function x = PMX(E,X,I)
%% 均匀部分映射交叉
if length(E)>length(X)
    len = length(X);
else
    len = length(E);
end
count = 1;
for i = 1 : len
    if E(i) ~= X(i)
        count = count + 1;
    end
end
for i = 1 : count
    a = randperm(max(E),1);
    pos1 = find(E == a);
    b = X(pos1);
    pos2 = E(b);
    if (E(pos1) > I & E(pos2) > I) | (E(pos1) <= I & E(pos2) <= I) %保证交换的位置
        c = E(pos1);
        E(pos1) = E(pos2);
        E(pos2) = c;
    end
end
x = E;