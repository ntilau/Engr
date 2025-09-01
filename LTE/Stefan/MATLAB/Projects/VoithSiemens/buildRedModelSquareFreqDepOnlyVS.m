function romDirName = buildRedModelSquareFreqDepOnlyVS(nameUnredModel, order, expansionPoint)


%% load unreduced model
tic
disp(' ')
disp('Loading unreduced model...');

data = load(strcat(nameUnredModel, 'model'), 'model');
model = data.model;
clear data;
params = readParams(strcat(nameUnredModel, 'params.txt'));

toc


%% Building model in specified expansion point
tic
disp(' ')
disp('Building model in specified expansion point...');

modelInExpPnt.sysMat{1} = model.sysMat{1};
posSquareFreqCoeff = findRowInMat([2 0 0], model.coeffSequence);
modelInExpPnt.sysMat{1} = modelInExpPnt.sysMat{1} + expansionPoint(1) ^ 2 * model.sysMat{posSquareFreqCoeff};
posLinDmprDep = findRowInMat([0 1 0], model.coeffSequence);
modelInExpPnt.sysMat{1} = modelInExpPnt.sysMat{1} + expansionPoint(2) * model.sysMat{posLinDmprDep};
modelInExpPnt.sysMat{2} = model.sysMat{posSquareFreqCoeff};
modelInExpPnt.rhs{1} = model.rhs{1};
modelInExpPnt.rhs{1} = modelInExpPnt.rhs{1} + expansionPoint(1) ^ 2 * model.rhs{posSquareFreqCoeff};
modelInExpPnt.rhs{2} = model.rhs{posSquareFreqCoeff};

modelInExpPnt.coeffSequence = [0 1]';

numParams = 1;

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

romDirName = strcat(nameUnredModel, 'pureQuadraticFrequency_rom_', num2str(order));
for paramCnt = 1 : length(params)
  romDirName = strcat(romDirName, '_', params{paramCnt}.name, '_', num2str(expansionPoint(paramCnt), '%14.14g'));
end
romDirName = strcat(romDirName, '\');
system(['mkdir ' romDirName]);

model = redModel;
save([romDirName 'model'], 'model');

copyfile([nameUnredModel 'params.txt'], [romDirName 'params.txt']);
copyfile([nameUnredModel 'rhsParamDependence.txt'], [romDirName 'rhsParamDependence.txt']);
copyfile([nameUnredModel 'sysMatParamDependence.txt'], [romDirName 'sysMatParamDependence.txt']);
copyfile([nameUnredModel 'outputFunctionalParamDependence.txt'], [romDirName 'outputFunctionalParamDependence.txt']);

model.dummy = 1;

toc
