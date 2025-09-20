function [X,fitness,e] = mutation(X,I,D,C,F,O,P,Q,demand,customer,depot,fitness,e)
%mu 变异次数 可以将交换和逆转结合起来当作变异使用
% a1 = 0; a2 = 0.15; a3 = 0.3;  a4 = 0.6;
% a1 = 0; a2 = 1/4; a3 = 2/4;  a4 = 3/4;
% a1 = 0.4; a2 = 0.8; a3 = 0.8; a4 = 0.9; 
a1 = 1/3; a2 = 2/3; a3 = 2/3;  a4 = 1;
for j = 1 : randi([2,3])
    for i = 1: length(X)
        x = X{i};
        if rand <= a1 %交换
            x = swap(x,I);
            x = check_feasibility(x,I,P,Q,demand,customer,depot);
            fit = fun(x,D,C,F,O,I);
            if fit < fitness(i)
                X{i} = x; fitness(i) = fit; 
            end   
            x = depot_mutation(x,I);
        elseif a1<rand && rand <= a2%逆转 2-opt
            x = inverse(x);
        elseif a2 <rand && rand  <= a3  %插入
            x = insert(x);
        elseif  a3 < rand && rand <= a4% 2or3 swap
            x = swap2or3(x);
        else %路径内多个元素交换
            x = interchange(x,I);
        end
        x = check_feasibility(x,I,P,Q,demand,customer,depot);
        fit = fun(x,D,C,F,O,I);
        if fit < fitness(i)
            X{i} = x; fitness(i) = fit; 
        end            
    end
end

% for j = 1 : randi([2,3])
%     for i = 1: length(X)
%         x = X{i};
%         pp = [];
%         for l = 1: length(x)
%             if l < length(x)
%                 if x(l)<=I && x(l+1)<=I
%                    pp = [pp,l];
%                 end
%             else
%                 if x(l) <= I
%                     pp = [pp,l];
%                 end
%             end
%         end
%         x(pp) = [];
%             r = rand;
%             if rand <= a1 %交换
%                 x = swap(x,I);
%                 f(1) = f(1) + 1;
%                 x = check_feasibility(x,I,P,Q,demand,customer,depot);
%                 fit = fun(x,D,C,F,O,I);
%                 if fit < fitness(i)
%                     X{i} = x; fitness(i) = fit; e(1) = e(1) + 1;
%                 end
%                 x = depot_mutation(x,I);
%                 x = check_feasibility(x,I,P,Q,demand,customer,depot);
%                 fit = fun(x,D,C,F,O,I);
%                 if fit < fitness(i)
%                     X{i} = x; fitness(i) = fit; e(3) = e(3) + 1;
%                 end
%             elseif a1<rand && rand <= a2%逆转 2-opt
%                 f(2) = f(2) + 1;
%                 x = inverse(x);
%                 x = check_feasibility(x,I,P,Q,demand,customer,depot);
%                 fit = fun(x,D,C,F,O,I);
%                 if fit < fitness(i)
%                     X{i} = x; fitness(i) = fit; e(2) = e(2) + 1;
%                 end
%             elseif a2 <rand && rand  <= a3  %插入
%                 f(3) = f(3) + 1;
%                 x = insert(x);
%                 x = check_feasibility(x,I,P,Q,demand,customer,depot);
%                 fit = fun(x,D,C,F,O,I);
%                 if fit < fitness(i)
%                     X{i} = x; fitness(i) = fit; e(3) = e(3) + 1;
%                 end
%             elseif  a3 < rand && rand <= a4% 2or3 swap
%                 f(4) = f(4) + 1;
%                 x = swap2or3(x);
%                 x = check_feasibility(x,I,P,Q,demand,customer,depot);
%                 fit = fun(x,D,C,F,O,I);
%                 if fit < fitness(i)
%                     X{i} = x; fitness(i) = fit; e(4) = e(4) + 1;
%                 end
%             else %路径内多个元素交换
%                 f(5) = f(5) + 1;
%                 x = interchange(x,I);
%                 x = check_feasibility(x,I,P,Q,demand,customer,depot);
%                 fit = fun(x,D,C,F,O,I);
%                 if fit < fitness(i)
%                     X{i} = x; fitness(i) = fit; e(5) = e(5) + 1;
%                 end
%             end
%             x = check_feasibility(x,I,P,Q,demand,customer,depot);
%             fit = fun(x,D,C,F,O,I);
%             if fit < fitness(i)
%                 X{i} = x; fitness(i) = fit; e = e + 1;
%             end
%             
%     end
% end
     

     


