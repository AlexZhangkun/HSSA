function [x, data] = normalizepopulation(x, data)
    data.zmin = UpdateIdealPoint(x, data.zmin);
    
    fp = [x.fit] - repmat(data.zmin, 1, numel(x));
    
    data = PerformScalarizing(fp, data);
    
    a = FindHyperplaneIntercepts(data.zmax);
    
    for i = 1:numel(x)
        x(i).NormalizedCost = fp(:,i)./a;  %pop(i).NormalizedCost = fp(:,i)./(a - zmin)
    end
    
end

function a = FindHyperplaneIntercepts(zmax)

    w = ones(1, size(zmax,2))/zmax;
    
    a = (1./w)';

end