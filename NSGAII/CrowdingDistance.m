
function x = CrowdingDistance(x,F)

m = 2; %目标函数数量
nbFront = size(F,2); %帕累托层数

%On parcourt chaque front un par un
for i = 1:nbFront
    Fi = F{i};
    nbSolFront = size(Fi,2);
    valObj = [x(Fi).fitness];
    dist = zeros(nbSolFront, m);
    
    %Calculate crowding distance pour chaque objectif
    for j = 1:m        
        [valTri, indTri] = sort(valObj(j,:));
        
        dist(indTri(1),j) = inf;
        for k = 2:nbSolFront-1
            dist(indTri(k),j) = abs(valTri(k+1)-valTri(k-1))/abs(valTri(1)-valTri(end));
        end
        dist(indTri(end),j) = inf;
    end
    
    for j = 1:nbSolFront
        x(Fi(j)).CrowdDistance = sum(dist(j,:));
    end

end