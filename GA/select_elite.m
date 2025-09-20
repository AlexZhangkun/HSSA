function [x,y] = select_elite(X,fitness)
a = sort(unique(fitness));
x = cell(1,5); 
y = zeros(1,5);
for i = 1 : 5
    [~,b] = find(fitness == a(i));
    x{i} = X{b(1)}; 
    y(i) = a(i);
end
end