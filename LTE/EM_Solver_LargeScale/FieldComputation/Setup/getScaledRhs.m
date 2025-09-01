function [B, imagFactor] = getScaledRhs(Model, rhs, f, mtype)

scaleFact = zeros(Model.nPorts, 1);
for iPort = 1:Model.nPorts
    if mtype == -2
        imagFactor = -1i;
        scaleFact(iPort) = scaleRhs(...
            f, Model.fExp, Model.fCutOff(iPort));        
    elseif mtype == 6
        if Model.Flag.impedanceFormulation
            imagFactor = 1;
            scaleFact(iPort) = 1i * scaleRhs(...
                f, Model.fExp, Model.fCutOff(iPort));
        else
            imagFactor = 1;
            scaleFact(iPort) = scaleRhs(...
                f, Model.fExp, Model.fCutOff(iPort));
        end
    
    else
        error('Unknown matrix type: mtype = %d', mtype);
    end
end
    
B = rhs * diag(scaleFact);