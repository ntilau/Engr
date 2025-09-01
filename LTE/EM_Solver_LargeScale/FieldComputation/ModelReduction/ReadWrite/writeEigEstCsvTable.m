% function writes a file of comma separated values (csv), listing 
% reference eigenvalues, ritz estimations and corresponding bounds
function writeEigEstCsvTable(Model, referencePole, Rom)

nRefPoles = length(referencePole);
nRitz = Rom.dim;

estimatedPole = Model.c0 / 2 / pi * sqrt(Rom.Ritz.value + Model.kExp^2);
deltaFBound = Rom.Eig.deltaFBound;

% create matrix of differences of reference and estimated values
mDeltaF = inf * ones(nRefPoles, nRitz);
for k = 1:nRefPoles
    for m = 1:nRitz
        mDeltaF(k,m) = abs(referencePole(k) - estimatedPole(m));
    end
end

% search for minima in difference matrix
for k = 1:min(nRitz, nRefPoles)
    [colMin, iArrayRowMin] = min(mDeltaF);
    [totalMin, iColMin] = min(colMin);
    iRowMin = iArrayRowMin(iColMin);
    mDeltaF(iRowMin, :) = inf;
    mDeltaF(:, iColMin) = inf;
    
    iRitz = iColMin;
    iRef = iRowMin;
    
    deltaF(k) = totalMin;
    referenceIndex(k) = iRef;
    ritzIndex(k) = iRitz;
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write csv file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fName = strcat(Model.path, 'ritzValueConvergence.csv');
nCols = length(referencePole);

% print reference eigenfrequencies
if Rom.order == 0
    fid = fopen(fName, 'w');
else
    fid = fopen(fName, 'a');
end
if fid == -1
    error('could not open file %s', fName);
end

if mod(Rom.order, 5) == 0           
    strFreqList = '\n\nReference Frequency;';
    for m = 1:(nCols)
        strFreqList = [strFreqList, '%1.15e;'];
    end
    fprintf(fid, strcat(strFreqList, '\n'), referencePole);
end

approx = zeros(5,nCols);
for k = 1:length(deltaF)    
    if k == 1   
        fprintf(fid, '\nROM dimension: %d;\n', Rom.dim);
    end
    col = referenceIndex(k);    
    approx(1,col) = estimatedPole(ritzIndex(k));
    approx(2,col) = deltaF(k) / referencePole(col);
    approx(3,col) = deltaFBound(ritzIndex(k)) / referencePole(col);
    approx(4,col) = deltaFBound(ritzIndex(k)) / Model.f(1);
    approx(5,col) = (deltaFBound(ritzIndex(k)) / Model.f(1)) ...
        / (deltaF(k) / referencePole(col));
end

strResonantF = 'Ritz value;';
strErrorF = 'Delta f / f;';
strRelFreqBound = 'f Bound / f;';
strFCriterion = 'f Criterion;';
strOverEst = 'Overestimation;';

for iCol = 1:nCols
    if approx(1,iCol) == 0
        strResonantF = [strResonantF, ';'];
        strErrorF = [strErrorF, ';'];
        strRelFreqBound = [strRelFreqBound, ';'];
        strFCriterion = [strFCriterion, ';'];
        strOverEst = [strOverEst, ';'];
    else
        strResonantF = [strResonantF, '%1.15e;'];
        strErrorF = [strErrorF, '%1.15e;'];
        strRelFreqBound = [strRelFreqBound, '%1.15e;'];
        strFCriterion = [strFCriterion, '%1.15e;'];
        strOverEst = [strOverEst, '%1.15e;'];  
    end
end
    
iApprox = find(approx(1,:));
fprintf(fid, strcat(strResonantF, '\n'), approx(1,iApprox));
fprintf(fid, strcat(strErrorF, '\n'), approx(2,iApprox)); 
fprintf(fid, strcat(strRelFreqBound, '\n'), approx(3,iApprox));
fprintf(fid, strcat(strFCriterion, '\n'), approx(4,iApprox));
fprintf(fid, strcat(strOverEst, '\n'), approx(5,iApprox)); 

fclose(fid);