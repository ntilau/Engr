function [Model, Rom, RomSolution, fExp] = AdaptiveMultipointMor(Model)

% load unreduced model
tic
[Model.SysMat, Model.dof] = readSystemMatrices(Model.path);
[Model.rhs, Model.lhs] = readSystemVectors(Model.path, Model.nPorts);
Model.Time.readMatrices = toc;

% Generate Reduced Model
disp('Start addaptive process: ');
% initialize projection components
Projector.Q = [];                
Projector.R = [];

% initialize system matrix struct for reduced model
for matCnt = 1:length(Model.SysMat)
    Rom.SysMat(matCnt).name = Model.SysMat(matCnt).name;
    Rom.SysMat(matCnt).paramList = Model.SysMat(matCnt).paramList;
    Rom.SysMat(matCnt).val = [];
    Rom.dim = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adaptive iteration process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltaS = intmax;
normType = Model.ErrorCriterion.type;
% array of expansion frequencies
fExp = [];
order = 0;
RomSolution = cell(Model.maxRomOrder, 1);
maxSectionError = ones(Model.maxRomOrder - 1, 1);
while deltaS > Model.ErrorCriterion.threshold ...
        && length(fExp) <= Model.maxRomOrder                              
    
    % find section with the largest errror criterion value
    if order >= 2        
        nSections = order - 1;        
        % calculate stopping criterion for all sections
        tic
        for iSection = 1:nSections
            % index of section start frequency in Model.f
            sPosStart = find(Model.f == fExp(iSection));
            % index of section end frequency in Model.f
            sPosEnd = find(Model.f == fExp(iSection + 1));
            
            sOld = RomSolution{order - 1}.sMat(sPosStart:sPosEnd);
            sNew = RomSolution{order}.sMat(sPosStart:sPosEnd);            
            Criterion = incrementalStoppingCriterion(sOld, sNew);
            
            sectionError(iSection) = Criterion.(normType); %#ok<AGROW>
        end
        if ~isfield(Model.Time, 'secCriterion')
            Model.Time.secCriterion = [];
        end
        Model.Time.secCriterion = [Model.Time.secCriterion, toc];
        
        % Find section with highest error
        [maxSectionError(order), iMaxSectionError] = max(sectionError); 
        
        iStartFreq = find(Model.f == fExp(iMaxSectionError));
        iEndFreq = find(Model.f == fExp(iMaxSectionError + 1));
        nSectionFreqs = (iEndFreq - iStartFreq) + 1;
    end
    
    % Add new expansion frequency
    if order == 0
        newExpFreq = Model.f(1);
    elseif order == 1
        newExpFreq = Model.f(end);
    else                               
        newExpFreq = Model.f(iStartFreq + floor(nSectionFreqs / 2));
    end
    fExp = sort([fExp, newExpFreq]);
    order = order + 1;
    % solve full system
    [Rom, Projector, Model] = addExpansionPoint(...
        newExpFreq, Model, Rom, Projector);
    
    % evaluation of reduced model
    tic
    [sMat, zMat] = evaluateRom(Model, Rom, Model.f);       
    if ~isfield(Model.Time, 'secEval')
        Model.Time.secEval = [];
    end
    Model.Time.secEval = [Model.Time.secEval, toc];
    
    
    RomSolution{order}.sMat = sMat; 
    RomSolution{order}.zMat = zMat;    
    RomSolution{order}.S = sortNetworkParamsByPorts(sMat);
    RomSolution{order}.Z = sortNetworkParamsByPorts(zMat);
    RomSolution{order}.dim = Rom.dim;
    
    % evaluate criterion for entire band
    if order >= 2
        RomSolution{order}.Criterion = incrementalStoppingCriterion(...
            RomSolution{order - 1}.sMat, RomSolution{order}.sMat);
        deltaS = RomSolution{order}.Criterion.(normType);
        fprintf(1, '\n\t\t+ Error criterion in %s norm: %1.4e', ...
            normType, deltaS);
    end
end

% order of converged rom
Model.iRomConverged = order;
Model.maxSectionError = maxSectionError(1:(Model.iRomConverged - 1));

% remove superfluous cells
RomSolution = RomSolution(1:Model.iRomConverged);


saveReducedModel(Model, Rom);

% save expansion frequencies
fExpFile = sprintf('%sexpansionFrequencies.fvec', Model.resultPath);
writeFullVector(fExp, fExpFile);

writeAdaptiveMultipointStatistics(Model, 1);



