function A = dominate(x1,x2,fitness)
%≈–∂œ÷ß≈‰ Ù–‘
len = length(fitness);
a = zeros(1,len);
b = zeros(1,len);
for i = 1: len
    if fitness{i}(x1)< fitness{i}(x2)
        a(i) = 1;
    elseif fitness{i}(x1) == fitness{i}(x2)
        b(i) = 1;
    else
        a(i) = 0;
    end
end
if sum(a+b) == len && sum(a) ~= 0
    A = 1; %÷ß≈‰
else
    A = 0;
end
end