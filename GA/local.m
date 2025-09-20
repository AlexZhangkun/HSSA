function x = local(x,Q,demand)
A = 1;I = 1;
while A == 1
    if rand<=1/3
        a = find(x<=I);
        if length(a) < 2
            b = randperm(length(x)-1,2)+1;
            c = x(b(1));x(b(1)) = x(b(2)); x(b(2)) = c;
        else
            b = sort(randperm(length(a),2));%随机选择两条路线
            c = randperm(a(b(1)+1)-a(b(1)),1) + a(b(1));
            if b(2) ~= length(a)
                d = randperm(a(b(2)+1)-a(b(2)),1) + a(b(2));
                x(c:a(b(2)+1)-1) = [x(d:a(b(2)+1)-1),x(a(b(1)+1):d-1),x(c:a(b(1)+1)-1)];
            else
                d = randperm(length(a(end)-a(b(2))),1) + a(b(2));
                x(c:end) = [x(d:end),x(a(b(1)+1):d-1),x(c:a(b(1)+1)-1)];
            end
        end
    elseif 1/3<rand<=2/3
        a = sort(randperm(length(x),2));
        x(a(1):a(2)) = [x(a(1)),x(a(2)),x(a(1)+1:a(2)-1)];
    else
        a = sort(randperm(length(x)-1,2))+1;%随机选择两个点进行两点之间元素的逆转
        x = [x(1:a(1)-1),x(a(2):-1:a(1)),x(a(2)+1:end)];
    end
    %可行性检验
    a = find(x<=I);
    b = length(a);
    i = 1;
    x1 = x -1;
    while i <= b
        if i < b
            q = sum(demand(x1(a(i)+1:a(i+1)-1)));
            if q > Q
                break
            end
        else
            q = sum(demand(x1(a(i)+1:end)));
            if q > Q
                break
            else
                A = 0;
            end
        end
        i = i + 1;
    end
end