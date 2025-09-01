function [Resdl, r0] = computeSymmMorResiduals(Model, Rom, A0, Q, R, rhs)

Param = setParameters('k0', Model.kExp);
romA0 = buildFemMatrix(Rom.SysMat, Param);

romSize = size(romA0, 2);
Resdl = struct;

% residual
newCols = (romSize + 1):(romSize + Model.nPorts);
oldCols = 1:romSize;

% compute inverse of reduced fem matrix in expansion point
invA0red = inv(romA0);

iNew = romSize + 1;
hNew = R(iNew:end, iNew:end);

r0 = A0 * Q(:,newCols) * hNew;
r1 = A0 * (Q(:,oldCols) * (invA0red * (Q(:,oldCols).' * r0)));

r0 = r0 - r1;

k0 = f2k(Model.f);
s = k0.^2 - Model.kExp^2;

for iRhs = 1:Model.nPorts
    normRhs = norm(rhs(:,iRhs));
    for iFreq = 1:Model.nFreqs
         
        scale = scaleRhs(Model.f(iFreq), Model.fExp, Model.fCutOff(iRhs));
        b = abs(scale * normRhs);
        
        x = Rom.sol{iFreq}(:,iRhs);
        lastComp = (romSize - Model.nPorts + 1):(romSize);
        r = - s(iFreq) * r0 * x(lastComp);        
        
        Resdl(iRhs).absolute(iFreq) = norm(r);
        Resdl(iRhs).relative(iFreq) = Resdl(iRhs).absolute(iFreq)/ b;
    end   
end


