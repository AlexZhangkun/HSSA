function x = greedy(J,Q,demand,customer,depot)
D = dis([depot;customer],[depot;customer]); %��������֮��ľ���
cust = 2:J+1;  %��ʼ��δ�����ŵĿͻ�
% k = 1;
x = [];
while ~isempty(cust)
    x = [x,1];                  %����·��
    [~,d] = min(D(1,cust));
    c = cust(d(1));
    cust_d = cust;              %��ʼ��δ������Ŀͻ�
    q = Q;          %����ʣ������
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
