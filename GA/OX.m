function [x1,x2] = OX(E,X2,I)
%E:精英父代 X2:普通父代
%首先保留随机长度的精英父代个体，然后使用OX进行交叉
    if length(E) < length(X2)
        len = length(E);
    else
        len = length(X2);
    end
    a = sort(randperm(len,2));
    x1(a(1):a(2)) = E(a(1):a(2));
    p2 = X2;
    for i = a(1):a(2)
        b = find(p2 == x1(i));   
        if ~isempty(b) && b(1) ~= 1 %判断是否为仓库
            p2(b(1)) = []; 
        end
    end
    if length(p2)<a(1)-1
        x1(1:length(p2)) = p2;
        x1(x1==0) = [];
    else
        x1(1:a(1)-1) = p2(1:a(1)-1);
        x1 =[x1, p2(a(1):end)];
    end
    pp = [];
    for i = 1: length(x1)
        if i < length(x1)
            if x1(i)<=I && x1(i+1)<=I %x(i) == x(i+1)
               pp = [pp,i];
            end
        else
            if x1(i) <= I
                pp = [pp,i];
            end
        end
    end
    x1(pp) = [];
    x2(a(1):a(2)) = X2(a(1):a(2));
    p1 = E;
    for i = a(1):a(2)
        b = find(p1 == x2(i));   
        if ~isempty(b) && b(1) ~= 1 %判断是否为仓库
            p1(b(1)) = []; 
        end
    end
    if length(p1)<a(1)-1
        x2(1:length(p1)) = p1;
        x2(x2==0) = [];
    else
        x2(1:a(1)-1) = p1(1:a(1)-1);
        x2 =[x2, p1(a(1):end)];
    end
    pp = [];
    for i = 1: length(x2)
        if i < length(x2)
            if x2(i)<=I && x2(i+1)<=I
               pp = [pp,i];
            end
        else
            if x2(i) <= I
                pp = [pp,i];
            end
        end
    end
    x2(pp) = [];
end
