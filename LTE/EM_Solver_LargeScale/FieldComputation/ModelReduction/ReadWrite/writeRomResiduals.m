function writeRomResiduals(Model, Rom)

nFreqs = length(Model.f);
for iRhs = 1:Model.nPorts   
    fName = sprintf('%srelativeResidual_rhs_%d_pts%d_p%d.txt', ...
        Model.resultPath, iRhs, nFreqs, Rom.order);    
    writeFullVector(Rom.R(iRhs).relative, fName);
    if isfield(Rom, 'NaiveR')
        fName = sprintf(...
            '%s\\relativeResidualNaive_rhs_%d_pts%d_p%d.txt', ...
            Model.resultPath, iRhs, nFreqs, Rom.order);
        writeFullVector(Rom.NaiveR(iRhs).relative, fName);
    end
end

