function [x,x_child,F,data] = NS(x, data, Num, c_num)
%% ·ÇÖ§Åä½âÅÅĞò
data.Zr = GenerateReferencePoints(2, data.N+data.M);
data.nZr = size(data.Zr,2);
[x, data] = normalizepopulation(x, data);
[x,F] = nondominatesort(x);
    if Num == numel(x)
        F11 = [];       
        for i = 1 : numel(F)-1
            F11 = [F11,F{i}];
            if numel(F11) + numel(F{i+1}) >Num/(c_num+1)
                F11 = [F11,F{i+1}(1:Num/(c_num+1) - numel(F11))];
                break
            end
        end       
        x_child = x(setdiff(1:Num,F11));
        x = x(F11);
        return;
    end
        [x, d, rho] = AssociateToReferencePoint(x, data); 
    newpop = [];
    for l=1:numel(F)
        if numel(newpop) + numel(F{l}) > Num
            LastFront = F{l};
            break;
        end     
        newpop = [newpop; x(F{l})];   
    end
    
    while true   
        [~, j] = min(rho);
        AssocitedFromLastFront = [];
        for i = LastFront
            if x(i).AssociatedRef == j
                AssocitedFromLastFront = [AssocitedFromLastFront i]; 
            end
        end
        if isempty(AssocitedFromLastFront)
            rho(j) = inf;
            continue;
        end
        if rho(j) == 0
            ddj = d(AssocitedFromLastFront, j);
            [~, new_member_ind] = min(ddj);
        else
            new_member_ind = randi(numel(AssocitedFromLastFront));
        end
        MemberToAdd = AssocitedFromLastFront(new_member_ind);
        LastFront(LastFront == MemberToAdd) = [];
        newpop = [newpop; x(MemberToAdd)]; 

        if numel(newpop) >= Num
            break;
        end  
    end

    if numel(newpop) > Num
        newpop(numel(newpop)-Num) = [];
    end
    [x, F] = nondominatesort(newpop);
    F11 = [];       
    for i = 1 : numel(F)-1
        F11 = [F11,F{i}];
        if numel(F11) + numel(F{i+1}) >Num/(c_num+1)
            F11 = [F11,F{i+1}(1:Num/(c_num+1) - numel(F11))];
            break
        end
    end  
end

