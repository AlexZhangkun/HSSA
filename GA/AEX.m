function x = AEX(E,X2,I)
%X1:��Ӣ���� X2:��ͨ����
%���ȱ�������һ���������ȵľ�Ӣ�������壬Ȼ��ʹ��AEX���н���
len = length(E);
index = randperm(floor(len/2),1);
x = E(1:index);
a = 0; %ָ��,��һ��ѡ��ĸ���
for i = 1 : len-index+1
    if a == 0
%         nc = find(X2 == x(index+i-1)); %�ҵ�X2����X1��ͬ���ֵ�λ��
        nc = find(X2 == x(end));
        if ~isempty(nc)
            if nc == length(X2)
                nc = 0;
            else
                nc = nc(1);
            end
            if sum(x == X2(nc+1)) == 0 || X2(nc+1)<= I
                x = [x,X2(nc+1)];
            else
                c = setdiff(X2,x);
                if ~isempty(c)
                    b = randperm(length(c),1);
                    x = [x,b];
                end
            end
        else
            c = setdiff(X2,x);
            if ~isempty(c)
                b = randperm(length(c),1);
                x = [x,b];
            end
        end
        a = 1;
    else
%         nc = find(X1 == x(index+i-1));
        nc = find(E == x(end));    
        if ~isempty(nc)
            if nc == len
                nc = 0;
            else
                nc = nc(1);
            end
            if sum(x == E(nc+1)) == 0 ||  E(nc+1)<= I 
                x = [x,E(nc+1)];
            else
                c = setdiff(E,x);
                if ~isempty(c)
                    b = c(randperm(length(c),1));
                    x = [x,b];
                end
            end
        else
            c = setdiff(E,x);
            if ~isempty(c)
                b = c(randperm(length(c),1));
                x = [x,b];
            end
        end
        a = 0;
    end
end
cust = setdiff(I+1:max(E),unique(x));
x = [x,cust];
end
