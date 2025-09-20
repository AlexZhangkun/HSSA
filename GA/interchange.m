function x = interchange(x,I)
a = find(x<=I);
b = sort(randperm(length(a),2));%随机选择两条路线
c = randperm(a(b(1)+1)-a(b(1)),1) + a(b(1));
if b(2) ~= length(a)
    d = randperm(a(b(2)+1)-a(b(2)),1) + a(b(2));
    x(c:a(b(2)+1)-1) = [x(d:a(b(2)+1)-1),x(a(b(1)+1):d-1),x(c:a(b(1)+1)-1)];
else
    d = randperm(length(a(end)-a(b(2))),1) + a(b(2));
    x(c:end) = [x(d:end),x(a(b(1)+1):d-1),x(c:a(b(1)+1)-1)];
end