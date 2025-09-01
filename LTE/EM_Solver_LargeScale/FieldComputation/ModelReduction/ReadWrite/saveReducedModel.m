function saveReducedModel(Model, Rom)


%% Save reduced model
disp(' ')
disp('Saving reduced order model...');

SysMat = Rom.SysMat;

for k = 1:length(SysMat)
    switch SysMat(k).name
        case 'system matrix'
            kExponent = 0;
        case 'k^2 matrix'
            kExponent = 4;
        case 'ABC'
            kExponent = 2;
        case 'SI'
            kExponent = 1;
        otherwise
            kExponent = -1;
            warning('unknown matrix name');
    end
    
    sysMatRedNames(k) = kExponent;
    
    fName = sprintf('%ssysMatRed_%d.fmat',...
        Model.resultPath, kExponent);
    writeFullMatrix(SysMat(k).val, fName);
end

% write sysMatRedNames
fName = sprintf('%ssysMatRedNames.txt', Model.resultPath);
writeSysMatRedNames(sysMatRedNames, fName);

for k = 1:Model.nPorts
    writeFullVector(Rom.lhs(:,k), ...
        strcat(Model.resultPath, 'leftVecsRed_', num2str(k-1), '.fvec'));
    writeFullVector(Rom.rhs(:,k), ...
        strcat(Model.resultPath, 'redRhs_', num2str(k-1), '.fvec'));
end



