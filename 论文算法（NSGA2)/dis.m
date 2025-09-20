function y = dis(d,c)
    row = size(d,1);
    y = zeros(row,size(c,1));
    for i = 1 : row
        a = repmat(d(i,:),row,1);
        b = a - c;
        y(i,:) = sqrt(sum((b.^2)'));
    end
end
    