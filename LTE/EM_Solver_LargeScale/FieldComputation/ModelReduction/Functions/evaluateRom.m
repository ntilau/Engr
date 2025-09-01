% evaluate ROM for the frequencies F
function [sMat, zMat, sol] = evaluateRom(Model, Rom, f)

nFreqs = length(f);
ks = f2k(f);

sMat = cell(Model.nPorts);
zMat = cell(Model.nPorts);
sol = cell(nFreqs, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Solve Reduced System
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iFreq = 1:nFreqs
    % solve reuced system
    scaleFactor = zeros(Model.nPorts, 1);
    
    for k = 1:Model.nPorts,
        scaleFactor(k) = scaleRhs(f(iFreq), Model.fExp, Model.fCutOff(k));     
    end        

    % build system matrix at working frequency
    systemParam = struct('name', 'k0', 'val', ks(iFreq));
    M = buildFemMatrix(Rom.SysMat, systemParam);
    
    if isreal(M)
        mtype = -2;
    else
        mtype = 6;
    end
    
    [B, imagFactor] = getScaledRhs(Model, Rom.rhs, f(iFreq), mtype);
    
    X = M \ B;
    if nargout > 2
        sol{iFreq} = X;
    end
    
    % impedance matrix Z
    zMat{iFreq} = imagFactor * Rom.lhs.' * X;
    
    if imagFactor == 1
        zMat{iFreq} = - zMat{iFreq};
    end
    sMat{iFreq} = z2s(zMat{iFreq});
end

