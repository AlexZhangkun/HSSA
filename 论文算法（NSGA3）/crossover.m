function X = crossover(x,ex,data)
%% OX（顺序交叉）
    p = numel(x);%种群数量
    x1_time = zeros(data.l,data.N);
    X = repmat(ex,p/2,1);
    for k = 1 : p/2
        q1 = randi([1,p/2]);
        q2 = randi([p/2,p]);
        if rand<=0.5
            E = x(q1).route;X2 = x(q2).route;
        else
            E = x(q2).route;X2 = x(q1).route;
        end
        len = zeros(1,data.l);
        for j = 1: data.l
            len(j) = numel(E{j});
        end
        len = min(len);
        a = sort(randperm(len,2));
        x1 = cell(1,data.l);
        for j = 1 : data.l
            x1{j}(a(1):a(2)) = E{j}(a(1):a(2));
            x2 = X2{j};
            for i = a(1):a(2)
                b = find(x2 == x1{j}(i));
                if ~isempty(b) && b(1) ~= 1
                    x2(b(1)) = []; 
                end
            end
            if length(x2)<a(1)-1
                x1{j}(1:length(x2)) = x2;
                x1{j}(x1{j}==0) = [];
            else
                x1{j}(1:a(1)-1) = x2(1:a(1)-1);
                x1{j} =[x1{j}, x2(a(1):end)];
            end
            pp = [];
            for i = 1: length(x1{j})
                if i < length(x1{j})
                    if x1{j}(i)<=data.M && x1{j}(i+1)<=data.M %x(i) == x(i+1)
                        pp = [pp,i];
                    end
                else
                    if x1{j}(i) <= data.M
                        pp = [pp,i];
                    end
                end
            end 
            x1{j}(pp) = [];
            for l = 1 : numel(x1{j})
                if x1{j}(l) > data.M
                    if x1{j}(l-1) <= data.M
                        time = data.tw{j}(x1{j}(l)-data.M,2);
                        x1_time(j,x1{j}(l)-data.M) = time;
                    else   
                        x1_time(j,x1{j}(l)-data.M) = time +  data.tw{j}(x1{j}(l-1)-data.M,5) + data.time{j}(x1{j}(l-1)-data.M,x1{j}(l));
                    end
                end
            end
        end
        X(k).route = x1; X(k).arrtime = x1_time;
        X(k) = feasible(X(k),data);
        X(k).fit = fun(X(k).route,X(k).arrtime,data);
    end
end

