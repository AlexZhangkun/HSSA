function x = greedy(J,Q,demand,customer,depot)
D = dis([depot;customer],[depot;customer]); %各个顶点之间的距离
cust = 2:J+1;  %初始化未被安排的客户
% k = 1;
x = [];
while ~isempty(cust)
    x = [x,1];                  %储存路线
    [~,d] = min(D(1,cust));
    c = cust(d(1));
    cust_d = cust;              %初始化未被聚类的客户
    q = Q;          %车辆剩余容量
    while ~isempty(cust_d)
        if demand(c-1)<=q 
            x = [x,c];
            cust_d(cust_d == c)=[];
            q = q - demand(c-1);
            if ~isempty(cust_d)
                [~,d] = min(D(c,cust_d));
                c = cust_d(d(1));
            else
                break
            end
        else
            cust_d(cust_d == c)=[];
            if ~isempty(cust_d)
                [~,d]=min(D(c,cust_d));
                c = cust_d(d(1));
            else
                break
            end
        end
    end
    x1 = x;
    x1(x1 == 1) = [];
    for i = 1: length(x1)
        cust(cust == x1(i))=[];
    end
end
