function x = Split(X,D)
len = length(X);
c = zeros(1,len)+inf;
c(len+1) = 0;
for i = 1 : len
    s = len;
    dis = 0;
    for j = i : len
        t = dj;
        pt = dj-1;
        if i == j
            dis = dis + D(x(1),s);
        else
            dis = dis - D(x(1),pt) + D(pt,t) + D(t,x(1));
        end
        if dis + c(i-1) < c(j)
            c(j) = dis + c(i-1);
            Sj = i-1;
        end
    end
end
end
            