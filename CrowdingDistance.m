function x = CrowdingDistance(x,F)

m = 2; %目标函数数量
nbFront = size(F,2); %帕累托层数

for i = 1:nbFront
    Fi = F{i};
    nbSolFront = size(Fi,2);
    valObj1 = [x(Fi).fitness];
    valObj = zeros(m,nbSolFront);
    valObj(1,:) = valObj1(1:2:end);
    valObj(2,:) = valObj1(2:2:end);
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