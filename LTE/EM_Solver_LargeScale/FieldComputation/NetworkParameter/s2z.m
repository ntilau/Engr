% converts s-matrix to impedance matrix
function zMat = s2z(sMat)

if iscell(sMat)    
    nrOfSamples = length(sMat);
    Id = eye(size(sMat{1}));
    zMat = cell(nrOfSamples, 1);
    for n = 1:nrOfSamples
        zMat{n} = (Id + sMat{n}) * inv(Id - sMat{n});
    end
else
    Id = eye(size(sMat));
    zMat = (Id + sMat) * inv(Id - sMat);    
end

