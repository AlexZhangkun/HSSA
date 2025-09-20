clear;clc;   
% load 21-5 %424.9 
% load 22-5  %585.1 
% load 27-5   %3062 
% load 29-5  %512.1 
% load 32-5-1 %565.2
% load 32-5-2 %504.3 
% load 36-5 %460.4
% load ch50-5 %565.6
% load 75-10 %844.4
% load 100-10 %833.4

load 20-5-1a2 %54793
% load 20-5-2a2 %48908
% load 20-5-1b2 %39104
% load 20-5-2b2 %37542
% load 50-5-1a2 %90111 87109.64 90111
% load 50-5-1b2 %63242 61595.22 63982
% load 50-5-2a2 %88298 86055.01 89138   
% load 50-5-2b2 %67308 65787.75 67455
% load 50-5-2bis %84055 84721
% load 50-5-2bbis %51822 52085
% load 50-5-3 %86203 87288
% load 50-5-3b %61830 61963
% load 100-5-1  %274814    
% load 100-5-1b   %213568
% load 100-5-2 %193671
% load 100-5-2b  %157095 160149
% load 100-5-3 %200079 %208611
% load 100-5-3b %152441
% load 100-10-1 %287661
% load 100-10-1b %230989
% load 100-10-2 %243590
% load 100-10-2b %203988
% load 100-10-3 %250882
% load 100-10-3b %203114

value = zeros(1,10);
kmax = 3;
Num = 40;  %种群数量
iter_max = 2000; %最大迭代次数
D = dis([depot;customer],[depot;customer]);
for j = 1 : 1
    fitness = zeros(1,Num);
    x = cell(1,Num);
    for i = 1 : Num
        x{i} = greedy_cluster(M,N,Q,P,demand,customer,depot);
        fitness(i) = fun(x{i},D,C,F,O,M);
    end
%     [fitgbest,index] = min(fitness);%全局最优解
%     E = x{index}; %精英个体
    [E,fit] = select_elite(x,fitness);
    fitgbest = fit(1); gbest = E{1};
    best = zeros(1,iter_max);
    %% 主循环
    tic
    iter = 1; count= 1; e = zeros(1,6); c = zeros(1,3); f = zeros(1,5);
    while iter <= iter_max && count < 1/4*iter_max 
        [x,fitness,E,fit] = sc_select(x,E,fitness,fit,Num,M,Q,P,D,C,F,O,demand,customer,depot);
        [x,fitness,e] = mutation(x,M,D,C,F,O,P,Q,demand,customer,depot,fitness,e);
        [E,fit] = select_elite([x,E],[fitness,fit]);
        if fit(1) < fitgbest
            gbest = E{1}; fitgbest = fit(1);
        end
        best(iter) = fitgbest; 
        if iter>2 %计算最优解未改进的代数
            if best(iter) == best(iter-1)
                count = count + 1;
            else
                count = 1;
            end
        end
        iter = iter + 1;
    end
    value(j) = fitgbest;
end
fit(1)
toc