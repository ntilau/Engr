function loadUnreducedModel(modelName, linFreqParamFlag)

global k2_mat sys0 ident;

disp(' ')
disp('Load unreduced model...');

c0 = 299792.458e3;
u_0 = 4e-7*pi;
e_0 = 1/u_0/c0^2;
n_0 =sqrt(u_0/e_0);

%% load unreduced model
tic

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

useKrylovSpaces = vectorReader(strcat(modelName, 'useKrylovSpaces.txt'));

numParams = length(paramNames)+1;

% construct matrix with the ordering of the coefficients
permutMat=[];   % first column describes frequency dependence
if linFreqParamFlag
  maxOrder = 1;   % maximum order of parameter dependence
else
  maxOrder = 3;   % maximum order of parameter dependence
end
for k=0:maxOrder
  permutMat = rec(numParams, k, permutMat, 0, 1);
end

% read system matrices
sys0 = MatrixMarketReader(strcat(modelName, 'system matrix'));
k2_mat = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));
for k = 1:numLeftVecs
  ident{k} = MatrixMarketReader(strcat(modelName, 'ident', num2str(k-1)));
end
for k = 1:length(paramNames)  
  % names of the material matrices are equal to the parameter names
  paramMat{k} = MatrixMarketReader(strcat(modelName, paramNames{k}));
end
toc


