%首先随机选择仓库开放，然后根据车辆容量，距离安排客户
function pop = greedy_cluster(I,J,Q,P,demand,customer,depot)
D = dis([depot;customer],[depot;customer]); %各个顶点之间的距离
cust = 1:J;  %初始化未被安排的客户
k = 1;
while ~isempty(cust)
    x{k} = [];                  %储存路线
    c = cust(randperm(length(cust),1));
    cust_d = cust;              %初始化未被聚类的客户
    dem(k) = 0;      %总需求
    q = Q;          %车辆剩余容量
    while ~isempty(cust_d)
        if demand(c)<=q 
            x{k} = [x{k},c];
            cust_d(cust_d == c) = [];
            q = q - demand(c);
            dem(k) = dem(k) + demand(c);
            if ~isempty(cust_d)
                [~,d] = min(D(c,cust_d));
                c = cust_d(d(1));
            else
                break
            end
        else
            cust_d(cust_d == c) = [];
            if ~isempty(cust_d)
                [~,d]=min(D(c,cust_d));
                c = cust_d(d(1));
            else
                break
            end
        end
    end
    if length(x{k}) == 1
        gra(k,:) = customer(x{k},:)/size(x{k},2);
    else
        gra(k,:) = (sum(customer(x{k},:)))/size(x{k},2); %计算聚类重心
    end  
    cust = setdiff(cust,x{k});
    k = k + 1;
end
g2d = dis(gra,depot);%计算聚类重心到仓库的距离
% c2d = sum(D(1:5,:)');
% [~,w] = sort(P./(c2d.*O)); %仓库开放等级排序
dep = 1:I;
clu = 1:length(x);
while ~isempty(clu) 
    d = dep(randperm(length(dep),1)); %随机选择一个仓库
    [~,index] = min(g2d(d,clu));
    sc = clu(index(1));
    p = P(d);
    cl = clu;
    a_c = []; %记录已经被安排的聚类
    while ~isempty(cl)
        if dem(sc) <= p 
            x{sc} = [d,x{sc}+I];
            cl(cl == sc) = [];
            p = p - dem(sc);
            a_c = [a_c,sc];
            if ~isempty(cl)
                [~,index] = min(g2d(d,cl));
                sc = cl(index(1));
            else
                break
            end                
        else
            cl(cl == sc) = [];
            if ~isempty(cl)
                [~,index] = min(g2d(d,cl));
                sc = cl(index(1));
            else
                break
            end
        end
    end
    clu = setdiff(clu,a_c); 
    dep(dep == d)=[];
end
pop = [];
for i = 1:length(x)
%     if ismember(x{i}(1),pop) %编码加0隔断
%         x{i}(1) = 0;
%     end
    pop = [pop,x{i}];
end
end
    


            
            