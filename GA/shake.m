function x = shake(X,kmax,I)
a = floor(1+rand*kmax);
x = X;
if a == 1 %����
    x = swap(x,I);
%     d = randperm(length(x),1);
%     if x(d) <= I
%         b = setdiff(find(x<=I),d);
%         c = b(randperm(length(b),1));%Ѱ����һ���ֿ�
%     else
%         b = setdiff(find(x>I),d);
%         c = b(randperm(length(b),1));%Ѱ����һ���ͻ�
%     end 
elseif a == 2%��ת
    a = sort(randperm(length(x)-1,2))+1;%���ѡ���������������֮��Ԫ�ص���ת
    x = [x(1:a(1)-1),x(a(2):-1:a(1)),x(a(2)+1:end)];
elseif a == 4 %����
   a = find(x<=I);
   b = randperm(length(a),1);
   c = setdiff(1:I,a(b));
   x(a(b)) = c(randperm(length(c),1));
elseif a == 3% �Ѻ���������뵽ǰ���������
    a = sort(randperm(length(x),2));
    x(a(1):a(2)) = [x(a(1)),x(a(2)),x(a(1)+1:a(2)-1)];
% elseif index == 5 %·���ڽ���
%     a = find(x<I);
%     b = randperm(length(a),1);
%     if b <length(a)
%         c = sort(randperm(a(b+1)-a(b),2) + a(b));
%         d = x(c(1));x(c(2)) = x(c(1)); x(c(1)) = d;
%     else
%         c = sort(randperm(length(x)-a(b),2) + a(b));
%         d = x(c(1));x(c(2)) = x(c(1)); x(c(1)) = d;
%     end
elseif a == 5
    x = interchange(x,I);
end
end