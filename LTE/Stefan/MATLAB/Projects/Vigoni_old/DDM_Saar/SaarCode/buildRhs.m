function [rhs] = buildRhs(dimCompMat, nmode, xy, PO, Np)


for portCnt = 1:Np
    % get port dimension
    MAXPO = PO(end, Np);
    yMin = xy(2, PO(1, Np));
    yMax = xy(2, PO(MAXPO, Np));
    portLen = yMax - yMin;
    
    y = xy(2, PO(1 : MAXPO, Np));
    distY = y(2 : end) - y(1 : (end - 1));
    
    for modeCnt = 1:nmode
        x = (sin(pi / portLen * modeCnt * y)).^2;
        distX = (x(2 : end) + x(1 : (end - 1))) / 2;
        integ = sum(distX .* distY);
        preFact((portCnt - 1) * nmode + modeCnt) = integ;
    end
end
        
factMat = diag(preFact);
rhs = [zeros(dimCompMat - Np * nmode, Np * nmode); factMat];
