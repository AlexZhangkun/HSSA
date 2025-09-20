function y = check_feasibility(x,data)%data.M,data.P,data.Q,data.demand,data.customer,data.depot)
a = find(x<= data.M);
len = length(a);
q = zeros(1,len);
p = zeros(1,data.M);
new_x = cell(1,data.M);
for i = 1: len
    if i < len
        q(i) = sum(data.demand(x(a(i)+1:a(i+1)-1)-data.M));
        new_x{x(a(i))} = [new_x{x(a(i))},x(a(i)+1:a(i+1)-1)];
    else
        q(i) = sum(data.demand(x(a(i)+1:end)-data.M));
        new_x{x(a(i))} = [new_x{x(a(i))},x(a(i)+1:end)];
    end
    p(x(a(i))) = p(x(a(i))) + q(i);
end

if sum(p>data.P) <= 0 %²Ö¿âÊÇ·ñ³¬¹ıÈİÁ¿
    if sum(q>data.Q)>0%³µÁ¾³¬¹ıÈİÁ¿
        y = [];
        b = unique(x(a(q>data.Q)));
        for i = 1: length(b)
            new = greedy(length(new_x{b(i)}),data.Q,data.demand(new_x{b(i)}-data.M),data.customer(new_x{b(i)}-data.M,:),data.depot(b(i),:));
            c = [b(i),new_x{b(i)}];
            y = [y,c(new)];
        end
        v = x(a);
        for i = 1: length(b) 
            v(v == b(i)) = [];
        end
        v = unique(v); %Ê£Óà²Ö¿â
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
    de = find(p>data.P);%ÕÒµ½ÈİÁ¿³¬¹ıµÄ²Ö¿â
    cust = [];
    for i = 1: length(de)
        while p(de(i))>data.P(de(i))
            cust = [cust,new_x{de(i)}(end)];
            p(de(i)) = p(de(i)) - data.demand(new_x{de(i)}(end)-data.M);
            new_x{de(i)}(end) =  [];
        end
    end
    for i = 1: length(cust)
        rest = data.P-p-data.demand(cust(i)-data.M);
        nd = find(rest>=0);
        [~,d] = sort(rest(nd));
        dep = nd(d(1)); %Ñ¡ÔñÊ£ÓàÈİÁ¿×îĞ¡µÄ²Ö¿â
%         dep = nd(randperm(length(nd),1)); %Ëæ»úÑ¡Ôñ²Ö¿â
        new_x{dep} = [new_x{dep},cust(i)];
        p(dep) = p(dep) + data.demand(cust(i)-data.M);
    end
    y = [];
    if sum(q>data.Q)<=0  %²Ö¿â³¬¹ıÈİÁ¿£¬³µÁ¾Î´³¬¹ı
        for  i = 1 : length(new_x)
            if ~isempty(new_x{i})
                new = greedy(length(new_x{i}),data.Q,data.demand(new_x{i}-data.M),data.customer(new_x{i}-data.M,:),data.depot(i,:));
                c = [i,new_x{i}];
                y = [y,c(new)];
            end
        end
    else%²Ö¿â³µÁ¾¶¼³¬¹ıÈİÁ¿
        for  i = 1: length(new_x)
            if ~isempty(new_x{i})
                new = greedy(length(new_x{i}),data.Q,data.demand(new_x{i}-data.M),data.customer(new_x{i}-data.M,:),data.depot(i,:));
                c = [i,new_x{i}];
                y = [y,c(new)];
            end
        end
    end  
end
end

    
