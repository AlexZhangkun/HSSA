%�������ѡ��ֿ⿪�ţ�Ȼ����ݳ������������밲�ſͻ�
function pop = greedy_cluster(I,J,Q,P,demand,customer,depot)
D = dis([depot;customer],[depot;customer]); %��������֮��ľ���
cust = 1:J;  %��ʼ��δ�����ŵĿͻ�
k = 1;
while ~isempty(cust)
    x{k} = [];                  %����·��
    c = cust(randperm(length(cust),1));
    cust_d = cust;              %��ʼ��δ������Ŀͻ�
    dem(k) = 0;      %������
    q = Q;          %����ʣ������
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
        gra(k,:) = (sum(customer(x{k},:)))/size(x{k},2); %�����������
    end  
    cust = setdiff(cust,x{k});
    k = k + 1;
end
g2d = dis(gra,depot);%����������ĵ��ֿ�ľ���
% c2d = sum(D(1:5,:)');
% [~,w] = sort(P./(c2d.*O)); %�ֿ⿪�ŵȼ�����
dep = 1:I;
clu = 1:length(x);
while ~isempty(clu) 
    d = dep(randperm(length(dep),1)); %���ѡ��һ���ֿ�
    [~,index] = min(g2d(d,clu));
    sc = clu(index(1));
    p = P(d);
    cl = clu;
    a_c = []; %��¼�Ѿ������ŵľ���
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
%     if ismember(x{i}(1),pop) %�����0����
%         x{i}(1) = 0;
%     end
    pop = [pop,x{i}];
end
end
    


            
            