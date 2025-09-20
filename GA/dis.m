%计算仓库到客户的距离
function W = dis(customer,depot)
M = size(depot,1);
N = size(customer,1);
for i = 1 : M
    A = repmat(depot(i,:),N,1);
    B = customer;
    C = (A - B).^2;
    W(i,:) = sqrt(sum(C'));
end
end