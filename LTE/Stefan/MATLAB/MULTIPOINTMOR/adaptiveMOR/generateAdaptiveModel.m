function generateAdaptiveModel(modelName, numExpFreq)

% Addaptive process for multi-point ROM generation.
% modelName ... Raw model name
% numExpFreq ... number of expansion frequencies in addaptive process

global S abcMat T Qp rhs lVec numLeftVecs f0 freqParam;

constants;


%% load unreduced model
disp(' ')
disp('Loading raw model...');
tic

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

% read system matrices
SysMat = MatrixMarketReader(strcat(modelName, 'system matrix'));
T = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));

for k = 1:length(paramNames)  
  % names of the material matrices are equal to the parameter names
  paramMat{k} = MatrixMarketReader(strcat(modelName, paramNames{k}));
end

for k = 1:numLeftVecs
  rhs{k} = vectorReader(strcat(modelName, 'rhs', num2str(k-1))); 
end

for k = 1:numLeftVecs
  lVec{k} = vectorReader(strcat(modelName, 'leftVec', num2str(k-1)));
end


% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);


fEval = linspace(freqParam.fMin, freqParam.fMax, freqParam.numPnts);

%Load Original Model Data
fNameSpara = strcat(modelName, 'sOrig_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
fNameSparaOrig = strcat(fNameSpara, '.txt');
[parameterNamesMulti, numParameterPntsMulti, parameterValsMulti, sMatricesMulti] ...
  = loadSmatrix(fNameSparaOrig);
sValOrig = zeros(numParameterPntsMulti(1),1);
freqsMulti = zeros(numParameterPntsMulti(1),1);
for k = 1:numParameterPntsMulti(1)
  fr(k) = parameterValsMulti(1,k);
  sValOrig111(k) = sMatricesMulti{k}(1, 1);
  sValOrig112(k) = sMatricesMulti{k}(1, 2);
end

k0 = 2*pi*f0/c0;
Snabc = SysMat;
if abcFlag
    abcMatk0 = MatrixMarketReader(strcat(modelName, 'ABC'));
else
    [ySp, xSp] = size(SysMat);
    abcMatk0 = sparse(ySp, xSp);
end
abcMat = abcMatk0;
S = Snabc;

toc
%% Generate Reduced Model

disp('Start addaptive process: ');
tic

% Initial ROM
Qp = [];                % Empty projection matrix
sysMatRed{1}=[];        % Empty ROM system matrices
sysMatRed{2}=[];
sysMatRed{3}=[];

[sysMatRed, redRhs, lVecRed] = addExpansionPoint(fEval(1), sysMatRed);      % Add expansion frequency
[sysMatRed, redRhs, lVecRed] = addExpansionPoint(fEval(end), sysMatRed);    % at f_min and f_max
fExpand = [fEval(1) fEval(end)];

[s11Old, s12Old] = evaluateSection(sysMatRed, redRhs, ...                   % Find section with lower error
        lVecRed, fExpand(1), fExpand(end), fEval(2)-fEval(1));               
fExpand = [fExpand fEval(floor(length(fEval)/2))];
fExpand = sort(fExpand);

[sysMatRed, redRhs, lVecRed] = addExpansionPoint(fExpand(2), sysMatRed);    % Add third expansion frequency
[s11New, s12New] = evaluateSection(sysMatRed, redRhs, lVecRed, ...
        fExpand(1), fExpand(end), fEval(2)-fEval(1));


for fExpNumb=1:(numExpFreq-3),
    disp(['Add expansion point number: ' num2str(fExpNumb+3) ]);    
    for sC = 1:(length(fExpand)-1),                                         % Evaluate section errors
        sPos1 = find(fEval==fExpand(sC));
        sPos2 = find(fEval==fExpand(sC+1));        
        e11 = s11New(sPos1:sPos2) - s11Old(sPos1:sPos2);
        e12 = s12New(sPos1:sPos2) - s12Old(sPos1:sPos2);       
        eS=1;    
        sectionFailure1(sC) = ( sum( abs(e11).^eS + abs(e12).^eS ).^(1/eS) ) / length(e11)  ;
        eS=2;    
        sectionFailure2(sC) = ( sum( abs(e11).^eS + abs(e12).^eS ).^(1/eS) ) / length(e11);  
        sectionFailureMax(sC) = max( max(abs(e11)), max(abs(e12)) );
    end
     
    [maxFailure1(fExpNumb), maxPos1] = max(sectionFailure1);                % Find section with highest error
    [maxFailure2(fExpNumb), maxPos2] = max(sectionFailure2);                
    [maxFailureMax(fExpNumb), maxPosMax] = max(sectionFailureMax);
    
    sPos1 = find(fEval==fExpand(maxPos2));                                  % Find section positions
    sPos2 = find(fEval==fExpand(maxPos2+1));
    
    s11Old = s11New;                                                        % Remind previous step data
    s12Old = s12New; 

    newExpFreq = fEval( sPos1 + floor( length(fEval(sPos1:sPos2))/2 ) );    % Add new expansion frequency
    fExpand = [fExpand newExpFreq];                                         % and evaluate ROM
    fExpand = sort(fExpand);   
    [sysMatRed, redRhs, lVecRed] = addExpansionPoint(newExpFreq, ...
                sysMatRed);
    [s11New, s12New] = evaluateSection(sysMatRed, redRhs, lVecRed, ...
                fExpand(1), fExpand(end), fEval(2)-fEval(1));   
    
    
    % Evaluate sweep error, FOR ERROR PLOT ONLY!!!
    e11O = sValOrig111 - s11New;                                            
    e12O = sValOrig112 + s12New;
    eS=1;
    expFreqError1(fExpNumb) = (sum(abs(e11O).^eS + abs(e12O).^eS).^(1/eS)) / length(e11O) ;
    eS=2;
    expFreqError2(fExpNumb) = (sum(abs(e11O).^eS + abs(e12O).^eS).^(1/eS)) / length(e11O) ;
    expFreqErrorMax(fExpNumb) = max( max(abs(e11O)), max(abs(e12O)) ) ;

end



toc


%%

figure(23);
text('Interpreter','latex');
set(gca, 'FontSize',18);
semilogy((1:numExpFreq-3)*2+6, maxFailure1, 'green', 'LineWidth', 2);
hold on;
semilogy((1:numExpFreq-3)*2+6, maxFailure2, 'blue', 'LineWidth', 2);
semilogy((1:numExpFreq-3)*2+6, maxFailureMax, 'black', 'LineWidth', 2);
hold off;
ylabel('Section error E_p');
xlabel('Model dimension');
grid on;
legend('1','2','inf');


figure(24);
text('Interpreter','latex');
set(gca, 'FontSize',18);
semilogy((1:numExpFreq-3)*2+6, expFreqError1, 'green', 'LineWidth', 2);
hold on;
semilogy((1:numExpFreq-3)*2+6, expFreqError2, 'blue', 'LineWidth', 2);
semilogy((1:numExpFreq-3)*2+6, expFreqErrorMax, 'black', 'LineWidth', 2);
hold off;
ylabel('Sweep error L_p');
xlabel('Model dimension');
grid on;
legend('1','2','inf');



     
fExpand




%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');


permutMat = [0;1;2];
colCntPermutMat = size(permutMat, 2);
sysMatCleared = [];


for k = 1:length(sysMatRed)
  if ~isempty(sysMatRed{k})
    fName = strcat(modelName, 'sysMatMulti_', ...
      num2str(permutMat(k, 1)));
    for m = 2:colCntPermutMat
      fName = strcat(fName, '_', num2str(permutMat(k, m)));
    end
    writeMatFull(sysMatRed{k}, fName);
    sysMatCleared = [sysMatCleared; permutMat(k,:)];
  end
end

writeSysMatRedNames(sysMatCleared, strcat(modelName, 'sysMatMultiNames'));

% for k = 1:length(identRed)
%   fName = strcat(modelName, 'identRed', num2str(k-1));
%   writeMatFull(identRed{k}, fName);
% end

for k = 1:numLeftVecs
  writeVector(lVecRed{k}, strcat(modelName, 'leftVecsMulti', num2str(k-1)));
  writeVector(redRhs{k}, strcat(modelName, 'MultiRhs', num2str(k-1)));
end
toc