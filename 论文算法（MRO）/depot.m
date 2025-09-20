function [y1,y2] = depot(F,data)
y1 = 0; y2 = 0;
for i = 1: data.l
    v  = F.route{i}(F.route{i}<=data.M);
    y1 = y1 + sum(data.O(unique(v),i));
    y2 = y2 + data.F(i)*length(v);
end