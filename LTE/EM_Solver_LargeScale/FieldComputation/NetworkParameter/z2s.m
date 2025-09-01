% converts s-matrix to impedance matrix
function sMat = z2s(zMat)

if iscell(zMat)    
    nrOfSamples = length(zMat);
    sMat = cell(nrOfSamples, 1);
    Id = eye(size(zMat{1}));
    for n = 1:nrOfSamples
        sMat{n} = inv(zMat{n} + Id) * (zMat{n} - Id);
    end
else
    Id = eye(size(zMat));
    sMat = inv(zMat + Id) * (zMat - Id);
end
return;
