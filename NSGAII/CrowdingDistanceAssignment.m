function [x,F] = CrowdingDistanceAssignment(x,F,d)
%% k个最近的点的调和平均距离来代替2个最近点的平均距离的拥挤距离排序
%d = k/(1/d1+1/d2+...+1/dk) 
%     Num = numel(F);
%     har_d = zeros(1,Num);%调和平均距离
%     for i = 1: Num
%         for j = 1: numel(F{i})
%             d1 = 1./d(F{i}(j),:);
%             d1(F{i}(j)) = 0;
%             x(F{i}(j)).crdis = (Num-1)/sum(d1);
%         end
%         [~,index] = sort([x.crdis]) ;%拥挤距离排序
%         F{i} = F{i}(index(numel(index)-numel(F{i}):numel(index)));
%     end
% end
    Num = numel(F);
%     har_d = zeros(1,Num);%调和平均距离
    for i = 1: Num
            d1 = 1./d(F(i),F);
            d1(i) = 0;
            x(F(i)).crdis = (Num-1)/sum(d1);
%         [~,index] = sort([x.crdis]) ;%拥挤距离排序
%         F{i} = F{i}(index(numel(index)-numel(F{i}):numel(index)));
    end
end
