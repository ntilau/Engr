function romDirName = buildRedModelVS(nameUnredModel, order, expansionPoint, freqModelOnlyFlag)


%% load unreduced model
tic
disp(' ')
disp('Loading unreduced model...');

data = load(strcat(nameUnredModel, 'model'), 'model');
model = data.model;
clear data;

params = readParams(strcat(nameUnredModel, 'params.txt'));
params = computeParamPnts(params);
numParams = length(params);

toc


%% Building model in specified expansion point
tic
disp(' ')
disp('Building model in specified expansion point...');

% construct matrix with the ordering of the coefficients
coeffSequence = [];
maxOrder = 2; 
for k = 0 : maxOrder
  coeffSequence = rec(numParams, k, coeffSequence, 0, 1);
end

modelInExpPnt = createGeneralModelInExpPointVS(model, expansionPoint);

if freqModelOnlyFlag
  modelInExpPnt = reduceToPureFreqModel(modelInExpPnt);
  numParams = 1;
%   modelInExpPnt = createFreqModelInExpPointVS(model, expansionPoint);
end

toc


%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

% factorization of system matrix in expansion point
[fact.L fact.U fact.P fact.Q] = lu(modelInExpPnt.sysMat{1});
Q = computeProjectionSpaceVS(modelInExpPnt, fact, numParams, order);
clear fact;
redModel = projectModelVS(model, Q);

toc


%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');

romDirName = strcat(nameUnredModel, 'rom_', num2str(order));
for paramCnt = 1 : length(params)
  romDirName = strcat(romDirName, '_', params{paramCnt}.name, '_', num2str(expansionPoint(paramCnt), '%14.14g'));
end
romDirName = strcat(romDirName, '_FreqOnly_', num2str(freqModelOnlyFlag), '\');


system(['mkdir ' romDirName]);

model = redModel;
save([romDirName 'model'], 'model');

copyfile([nameUnredModel 'params.txt'], [romDirName 'params.txt']);
copyfile([nameUnredModel 'rhsParamDependence.txt'], [romDirName 'rhsParamDependence.txt']);
copyfile([nameUnredModel 'sysMatParamDependence.txt'], [romDirName 'sysMatParamDependence.txt']);
copyfile([nameUnredModel 'outputFunctionalParamDependence.txt'], [romDirName 'outputFunctionalParamDependence.txt']);

model.dummy = 1;

toc
