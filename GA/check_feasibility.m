function y = check_feasibility(x,I,P,Q,demand,customer,depot)
a = find(x<= I);
len = length(a);
q = zeros(1,len);
p = zeros(1,I);
new_x = cell(1,I);
for i = 1: len
    if i < len
        q(i) = sum(demand(x(a(i)+1:a(i+1)-1)-I));
        new_x{x(a(i))} = [new_x{x(a(i))},x(a(i)+1:a(i+1)-1)];
    else
        q(i) = sum(demand(x(a(i)+1:end)-I));
        new_x{x(a(i))} = [new_x{x(a(i))},x(a(i)+1:end)];
    end
    p(x(a(i))) = p(x(a(i))) + q(i);
end

if sum(p>P) <= 0 %�ֿ��Ƿ񳬹�����
    if sum(q>Q)>0%������������
        y = [];
        b = unique(x(a(q>Q)));
        for i = 1: length(b)
            new = greedy(length(new_x{b(i)}),Q,demand(new_x{b(i)}-I),customer(new_x{b(i)}-I,:),depot(b(i),:));
            c = [b(i),new_x{b(i)}];
            y = [y,c(new)];
        end
        v = x(a);
        for i = 1: length(b) 
            v(v == b(i)) = [];
        end
        v = unique(v); %ʣ��ֿ�
%         v = setdiff(x(a),b);
        if ~isempty(v)
            for j = 1 : length(v)
                g = find(x(a) == v(j));
                for k = 1: length(g)
                    if g(k) ~= len
                        y = [y,x(a(g(k)):a(g(k)+1)-1)];
                    else
                        y = [y,x(a(g(k)):end)];
                    end
                end
            end
        end
    else
        y = x;
    end
else
    de = find(p>P);%�ҵ����������Ĳֿ�
    cust = [];
    for i = 1: length(de)
        while p(de(i))>P(de(i))
            cust = [cust,new_x{de(i)}(end)];
            p(de(i)) = p(de(i)) - demand(new_x{de(i)}(end)-I);
            new_x{de(i)}(end) =  [];
        end
    end
    for i = 1: length(cust)
        rest = P-p-demand(cust(i)-I);
        nd = find(rest>=0);
        [~,d] = sort(rest(nd));
        dep = nd(d(1)); %ѡ��ʣ��������С�Ĳֿ�
%         dep = nd(randperm(length(nd),1)); %���ѡ��ֿ�
        new_x{dep} = [new_x{dep},cust(i)];
        p(dep) = p(dep) + demand(cust(i)-I);
    end
    y = [];
    if sum(q>Q)<=0  %�ֿⳬ������������δ����
        for  i = 1 : length(new_x)
            if ~isempty(new_x{i})
                    new = greedy(length(new_x{i}),Q,demand(new_x{i}-I),customer(new_x{i}-I,:),depot(i,:));
                c = [i,new_x{i}];
                y = [y,c(new)];
            end
        end
    else%�ֿ⳵������������
        for  i = 1: length(new_x)
            if ~isempty(new_x{i})
                    new = greedy(length(new_x{i}),Q,demand(new_x{i}-I),customer(new_x{i}-I,:),depot(i,:));
                c = [i,new_x{i}];
                y = [y,c(new)];
            end
        end
    end  
end
end

    
