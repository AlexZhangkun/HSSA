function ex = crossover(E,X2,ex,data)
%% OX£¨Ë³Ðò½»²æ£©
    x1_time = zeros(data.l,data.N);
    len = zeros(1,data.l);
    for j = 1: data.l
        len(j) = numel(E.route{j});
    end
    len = min(len);
    a = sort(randperm(len,2));
    x1 = cell(1,data.l);
    for j = 1 : data.l
        x1{j}(a(1):a(2)) = E.route{j}(a(1):a(2));
        x2 = X2.route{j};
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
                if x1{j}(i)<=data.M && x1{j}(i+1)<=data.M 
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
    ex.route = x1; ex.arrtime = x1_time;
    ex = feasible(ex,data);
    ex.fit = fun(ex.route,ex.arrtime,data);
end

