function [y1,y2] = depot(F,data)
y1 = 0; y2 = 0;
v  = F.route(F.route<=data.M);
y1 = y1 + sum(data.O(unique(v)));
y2 = y2 + data.F*length(v);