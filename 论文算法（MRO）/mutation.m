function X = mutation(x,ex,data)
%% 逆转，变异，交换，路径内交换
num = numel(x);
if num == 1
    pop = 1;
    X = ex;
else
    pop = randperm(num,num/2);
    X = repmat(ex,num/2,1);
end
a1 = 1/4; a2 = 1/2; a3 = 3/4; %每种邻域搜索方式概率分布
count = 1;
    for i = pop
        x1 = x(1).route;
        len = zeros(1,data.l);
        for j = 1: data.l
            len(j) = numel(x1{j});
        end
        len = min(len);
        if rand <=a1 %逆转 
            for j = 1 : numel(x1)
                a = sort(randperm(len-1,2))+1;%随机选择两个点进行两点之间元素的逆转
                x1{j} = [x1{j}(1:a(1)-1),x1{j}(a(2):-1:a(1)),x1{j}(a(2)+1:end)];  
            end
        elseif a1 < rand && rand <= a2 %变异仓库
            for j = 1 : numel(x1)  
                a = find(x1{j}<=data.M);
                b = randi(numel(a));
                c = setdiff(1:data.M,a(b));
                x1{j}(a(b)) = c(randi(numel(c)));
            end
        elseif a2 < rand && rand <= a3 %路径内元素交换
            for j = 1: numel(x1)
                if x1{j}(end) <= data.M
                    x1{j}(end) = [];
                end
                a = find(x1{j}<=data.M);
                b = sort(randperm(length(a),2));%随机选择两条路线
                c = randi([a(b(1))+1,a(b(1)+1)]);
                if b(2) ~= length(a)
                    d = randi([a(b(2))+1,a(b(2)+1)]);
                    x1{j}(c:a(b(2)+1)-1) = [x1{j}(d:a(b(2)+1)-1),x1{j}(a(b(1)+1):d-1),x1{j}(c:a(b(1)+1)-1)];
                else
                    d = randperm(numel(x1{j})-a(b(2)),1) + a(b(2));
                    x1{j}(c:end) = [x1{j}(d:end),x1{j}(a(b(1)+1):d-1),x1{j}(c:a(b(1)+1)-1)];
                end
            end
        else
            for j = 1: numel(x1)
                a = randperm(length(x1{j}),1);
                if x1{j}(a) <= data.M
                    b = setdiff(find(x1{j}<=data.M),a);
                    c = b(randi(length(b)));%寻找下一个仓库
                else
                    b = setdiff(find(x1{j}>data.M),a);
                    c = b(randi(length(b)));%寻找下一个客户
                end
                d = x1{j}(a); x1{j}(a) = x1{j}(c); x1{j}(c) = d; 
            end
        end
        x1_time = zeros(data.l,data.N);
        for t = 1: numel(x1)
            for l = 1 : numel(x1{t})
                if x1{t}(l) > data.M
                    if x1{t}(l-1) <= data.M
                        time = data.tw{t}(x1{t}(l)-data.M,2);
                        x1_time(t,x1{t}(l)-data.M) = time;
                    else   
                        x1_time(t,x1{t}(l)-data.M) = time +  data.tw{t}(x1{t}(l-1)-data.M,5) + data.time{t}(x1{t}(l-1)-data.M,x1{t}(l));
                    end
                end
%                 pp = [];
%                 if l < length(x1{t})
%                     if x1{t}(l) <= data.M && x1{t}(l+1)<=data.M 
%                         pp = [pp,l];
%                     end
%                 else
%                     if x1{t}(l) <= data.M
%                         pp = [pp,l];
%                     end
%                 end 
            end
%             x1{t}(pp) = [];
        end 
        X(count).route = x1; X(count).arrtime = x1_time; 
        X(count) = feasible(X(count),data);
        X(count).fit = fun(X(count).route,X(count).arrtime,data);
        count = count + 1;
    end
end
