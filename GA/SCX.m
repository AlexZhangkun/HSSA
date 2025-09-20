function x1 = SCX(E,X,I,J,D)
cust = I+1 : I+J;
x1 = E(1);
while ~isempty(cust)
    a1 = find(E == x1(end));
    a2 = find(X == x1(end));
    if ~isempty(a1)
        if a1(1) ~= length(E) 
            b1 = E(a1(1)+1);
        else
            b1 = E(1);
        end
        a = 1;
    else
        a = 0;
    end
    if ~isempty(a2)
        if a2(1) ~= length(X)
            b2 = X(a2(1)+1);
        else
            b2 = X(1);
        end
        b = 1;
    else
        b = 0;
    end
    if a == 1 && b == 1 
        if D(x1(end),b1) < D(x1(end),b2)
            x1 = [x1,b1];
        else
            x1 = [x1,b2];
        end
    elseif a == 1 && b == 0
        x1 = [x1,b1];
    elseif a == 0 && b == 1
        x1 = [x1,b2];
    end
    if sum(X == x1(end-1)) >=2
        c1 = find(X == x1(end-1));
        X(c1(1)) = [];
    else
        X(X == x1(end-1)) = [];
    end
    if sum(E == x1(end-1)) >=2
        c2 = find(E == x1(end-1));
        E(c2(1)) = [];
    else
        E(E == x1(end-1)) = [];
    end
    if x1(end) > I
        cust(cust == x1(end)) = [];
    end
end
end