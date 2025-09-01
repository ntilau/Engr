function [RomSolution, Model] = cstReportPlots(Model, RomSolution)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HACK 1
for k = 1:length(RomSolution)
    RomSolution{k}.dim = k * Model.nPorts;
    RomSolution{k}.S = sortNetworkParamsByPorts(RomSolution{k}.sMat);
    RomSolution{k}.Z = sortNetworkParamsByPorts(RomSolution{k}.zMat);
    
    % save network matrices
    if Model.Flag.writeResults
        sMatName = generateNetworkparamFilename('Srom', Model, k);
        zMatName = generateNetworkparamFilename('Zrom', Model, k);
        
        writeNetworkMatrixLteFormat(...
            RomSolution{k}.sMat, Model.f, sMatName);
        writeNetworkMatrixLteFormat(...
            RomSolution{k}.zMat, Model.f, zMatName);
    end
end

% HACK 2
if isfield(Model, 'fReference')
    nFreqs = Model.nFreqsReference;
else
    nFreqs = Model.nFreqs;
    Model.fFactor = 1;
end

% phase correction of EM_WaveSolver parameters
for iFreq = 1:nFreqs
    sDiscreteNormalized = Model.sMat{iFreq} ./ abs(Model.sMat{iFreq});
    
    iFreqRom = Model.fFactor * (iFreq - 1) + 1;
    
    if abs(Model.f(iFreqRom) - Model.fReference(iFreq)) > 1e-15
        error('Comparison of unequal sampling point');
    end
    
    sRomNormalized = RomSolution{end}.sMat{iFreqRom} ./ ...
        abs(RomSolution{end}.sMat{iFreqRom});

    idx = abs(sDiscreteNormalized - sRomNormalized) > 1;
    Model.sMat{iFreq}(idx) = - Model.sMat{iFreq}(idx);
end
Model.S = sortNetworkParamsByPorts(Model.sMat);
  
fontSize = 18;

hScatErrorNorm = plotScatErrorNorm(Model, RomSolution, Model.sMat, fontSize);
savePlot(hScatErrorNorm, ...
    strcat(Model.resultPath, Model.name, ...
    '_scatErrorNorm'), {'epsc', 'fig', 'jpeg'});

hImpErrorNorm = plotImpErrorNorm(Model, RomSolution, Model.zMat, fontSize);
savePlot(hImpErrorNorm, ...
    strcat(Model.resultPath, Model.name, ...
    '_impErrorNorm'), {'epsc', 'fig', 'jpeg'});

hIncrmtlCrit = plotIncrementalCriterion(Model, RomSolution, fontSize);
savePlot(hIncrmtlCrit(1), strcat(Model.resultPath, Model.name, ...
    '_incrementalScatCriterion'), {'epsc', 'fig', 'jpeg'});
savePlot(hIncrmtlCrit(2), strcat(Model.resultPath, Model.name, ...
    '_incrementalImpCriterion'), {'epsc', 'fig', 'jpeg'});


return;

for k = 1:length(RomSolution)
    for m = 1:1
        for n = 1
            figure('Name', sprintf('S(%d,%d) of ROM of order %d', m, n, k));
            romS = RomSolution{k}.S;
            subplot(3,1,1);
            plot(Model.f, real(romS{m,n}));
            hold on;
            plot(Model.f, real(Model.S{m,n}), 'r');
            subplot(3,1,2);
            plot(Model.f, imag(romS{m,n}));
            hold on;
            plot(Model.f, imag(Model.S{m,n}), 'r');
            subplot(3,1,3);
            scatError = abs(romS{m,n} - Model.S{m,n});
            semilogy(Model.f, scatError);
        end
    end
end    


for k = 1:length(RomSolution)
    for m = 1:1
        for n = 1
            figure('Name', sprintf('Z(%d,%d) of ROM of order %d', m, n, k));
            romZ = RomSolution{k}.Z;
            
            % imag part
            subplot(3,1,1);
            plot(Model.f, imag(romZ{m,n}));
            hold on;
            plot(Model.f, imag(Model.Z{m,n}), 'r');
            
            % real part
            subplot(3,1,2);
            plot(Model.f, real(romZ{m,n}));
            hold on;
            plot(Model.f, real(Model.Z{m,n}), 'r');
            
            % error
            subplot(3,1,3);
            impError = abs(romZ{m,n} - Model.Z{m,n});
            semilogy(Model.f, impError);
        end
    end
end    
