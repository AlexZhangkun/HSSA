function x = mutation(X,data,ex,x3)
%mu 变异次数 可以将交换和逆转结合起来当作变异使用
a1 = 0; a2 = 0.15; a3 = 0.3;  a4 = 0.6;
% a1 = 0; a2 = 1/4; a3 = 2/4;  a4 = 3/4;
% x = repmat(ex,numel(X),1);
x = ex; count = 1;
for j = 1: 1 %randi([2,5])
    for i = 1: numel(X)
        x1 = X(i).route;
        if rand <= a1 %交换
            a = randperm(length(x1),1);
            if x1(a) <= data.M
                b = setdiff(find(x1<=data.M),a);
                c = b(randperm(length(b),1));%寻找下一个仓库
            else
                b = setdiff(find(x1>data.M),a);
                c = b(randperm(length(b),1));%寻找下一个客户
            end
            d = x1(a); x1(a) = x1(c); x1(c) = d;  
        elseif a1<rand && rand <= a2%逆转
            a = sort(randperm(length(x1)-1,2))+1;%随机选择两个点进行两点之间元素的逆转
            x1 = [x1(1:a(1)-1),x1(a(2):-1:a(1)),x1(a(2)+1:end)];
        elseif a2 <rand && rand  <= a3  %变异（仓库）
           a = find(x1<=data.M);
           b = randperm(length(a),1);
           c = setdiff(1:data.M,a(b));
           x1(a(b)) = c(randperm(length(c),1));
        elseif  a3 < rand && rand<= a4% 把后面的数插入到前面的数后面
%             b = randi(3); %%单点，2，3
%             a = sort(randperm(length(x1) - b,2));
%             x1(a(1):a(2)+b-1) = [x1(a(1)),x1(a(2):a(2)+ b-1),x1(a(1)+1:a(2)-1)];
            a = sort(randperm(length(x1),2));
            x1(a(1):a(2)) = [x1(a(1)),x1(a(2)),x1(a(1)+1:a(2)-1)];
        else %路径内多个元素交换
            a = find(x1<=data.M);
            b = sort(randperm(length(a),2));%随机选择两条路线
            c = randperm(a(b(1)+1)-a(b(1)),1) + a(b(1));
            if b(2) ~= length(a)
                d = randperm(a(b(2)+1)-a(b(2)),1) + a(b(2));
                x1(c:a(b(2)+1)-1) = [x1(d:a(b(2)+1)-1),x1(a(b(1)+1):d-1),x1(c:a(b(1)+1)-1)];
            else
                d = randperm(length(a(end)-a(b(2))),1) + a(b(2));
                x1(c:end) = [x1(d:end),x1(a(b(1)+1):d-1),x1(c:a(b(1)+1)-1)];
            end
        end
        x1_time = zeros(1,data.N);
        for l = 1 : numel(x1)
            if x1(l) > data.M
                if x1(l-1) <= data.M
                    time = data.tw(x1(l)-data.M,2);
                    x1_time(x1(l)-data.M) = time;
                else   
                    x1_time(x1(l)-data.M) = time + data.tw(x1(l-1)-data.M,5) + data.time(x1(l-1)-data.M,x1(l));
                end
            end
        end
        x2 = ex; x2.route = x1; x2.time = x1_time;
        x2 = feasible(x2,data);
        x2.fitness = fun(x2.route,x2.time,data);
        fi = reshape([x.fitness,X.fitness,x3.fitness],2,size([x.fitness,X.fitness,x3.fitness],2)/2)';
        if ~ismember(x2.fitness,fi,'rows') 
            x(count) = x2; 
            count = count + 1;
        end
    end
end


            
            

