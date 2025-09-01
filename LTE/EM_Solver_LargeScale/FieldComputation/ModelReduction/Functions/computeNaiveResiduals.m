function Resdl = computeNaiveResiduals(Model, Rom, Q)

% read system matrices and vectors
dirMarker = logical(readFullVector(strcat(Model.path, 'dirMarker.fvec')));
SysMat = readSystemMatrices(Model.path, dirMarker);
rhs = readSystemVectors(Model.path, Model.nPorts, dirMarker);

Q = Q(:,1:Rom.dim);
Resdl = struct;
k0 = f2k(Model.f);
for iRhs = 1:Model.nPorts
    normRhs = norm(rhs(:,iRhs));
    for iFreq = 1:Model.nFreqs            
        Param = setParameters('k0', k0(iFreq));
        mA = buildFemMatrix(SysMat, Param);
        
        scale = scaleRhs(Model.f(iFreq), Model.fExp, Model.fCutOff(iRhs));
        b = scale * rhs(:,iRhs);
        
        x = Q * Rom.sol{iFreq}(:,iRhs);
        
        r = norm(mA * x - b);
        
        Resdl(iRhs).absolute(iFreq) = r;
        Resdl(iRhs).relative(iFreq) = r / abs(scale * normRhs);
    end   
end


