function x = swap(x,I)
% a = find(x<=I);
% b = sort(randperm(length(a),2));%随机选择两条路线
% d = randi([a(b(1))+1,a(b(1)+1)-1],1); %第一个点
% if b(2) ~= length(a)
%     c = randi([a(b(2))+1,a(b(2)+1)-1],1); %第二个点
% else
%     c = randi([a(b(2))+1,length(x)],1);
% end
d = randperm(length(find(x>I)),1);
if x(d) <= I
    b = setdiff(find(x<=I),d);
    c = b(randperm(length(b),1));%寻找下一个仓库
else
    b = setdiff(find(x>I),d);
    c = b(randperm(length(b),1));%寻找下一个客户
end
da = x(d); x(d) = x(c); x(c) = da;