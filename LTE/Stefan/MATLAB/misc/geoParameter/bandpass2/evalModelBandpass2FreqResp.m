% close all;
clear all;
set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath('C:\work\Matlab'));

% geoModelName = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_5_geo\';
geoModelName = 'C:\work\examples\bandpassfilter\bandpass2\results\bandpass2_1.1e+009_5_geo_rom5\';
modelNameOriginalBase = 'C:\work\examples\bandpassfilter\bandpass2\bandpass2_1.1e+009_5_l12_';
modelName = geoModelName;

impedanceFlag = true;
linearFlag = true;


%% load model

tic
disp(' ');
disp('Loading model...');

% % read names of the reduced system matrices, indicating their polynomial
% % parameter dependence
% fName = strcat(modelName, 'sysMatRedNames');
% sysMatRedNames = readSysMatRedNames(fName);
% orderParamDependence = sum(sysMatRedNames(end,:));
% % linearFlag = false;
% if orderParamDependence == 1
%   % System matrix of ROM only shows linear parameter dependence
%   linearFlag = true;
% end
% [r c] = size(sysMatRedNames);
% 
% % read reduced system matrices
% sys = cell(r, 1);
% for k = 1:r
%   fName = strcat(modelName, strcat('sysMatRed_', ...
%     num2str(sysMatRedNames(k,1))));
%   for m = 2:c
%     fName = strcat(fName, '_', num2str(sysMatRedNames(k,m)));
%   end
%   sys{k} = readMatFull(fName);
% end
% 
% % read "modelParam.txt"
% fNameModRedTxt = strcat(modelName, 'modelParam.txt');
% [fExp, paramNames, paramValInExp, numLeftVecs, abcFlag] = readModParaTxt(fNameModRedTxt);
% 
% leftVecs = zeros(numLeftVecs, size(sys{1}, 1));
% rhs = cell(numLeftVecs, 1);
% for k = 1:numLeftVecs
%   % read leftVecs
%   fNameLeftVecs = strcat(modelName, 'leftVecsRed', num2str(k-1));
%   leftVecs(k,:) = vectorReader(fNameLeftVecs).';
%   % read RHSs
%   fNameRHS = strcat(modelName, 'redRhs', num2str(k-1));
%   rhs{k} = vectorReader(fNameRHS);
% end
% 
% % read "model.pvar"
% fNameModPvar = strcat(modelName, 'model.pvar');
% [freqParam, materialParams] = readModParVar(fNameModPvar);
% 
% % compute parameter steps of frequency parameter
% if linearFlag
%   freqParam.steps = calcK_SquareRelSteps(fExp, freqParam.fMin, ...
%     freqParam.fMax, freqParam.numPnts);
% else
%   freqParam.steps = calcRelWaveNumberSteps(fExp, freqParam.fMin, ...
%     freqParam.fMax, freqParam.numPnts);
% end
% scaleRHS = calcScaleRHS(fExp, freqParam.fMin, freqParam.fMax, ...
%   freqParam.numPnts, freqParam.fCutOff);
% 
% if freqParam.numPnts == 1
%   deltaF = 0;
% else
%   deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
% end
% fRom = zeros(1, freqParam.numPnts);
% for kStepCnt = 1:freqParam.numPnts
%   fRom(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
% end

% save(strcat(modelName, 'rom_5'));
load(strcat(modelName, 'rom_5'));

toc


%% set geometry parameter

l12 = 0.206;
d1 = 0.030;
d2 = 0.0633;


%% solve model
disp(' ');
disp('Solving model ...');
tic

zMat = solveROM_Bandpass2FreqResp(l12, d1, d2, sysMatRedNames, freqParam, sys, scaleRHS, rhs, leftVecs);

% zMat is an impedance matrix
% compute scattering matrix from the impedance matrix
s11rom = zeros(1, length(zMat));
for sMatCnt = 1:length(zMat)
  sMat = inv(zMat{sMatCnt} - eye(numLeftVecs)) * (zMat{sMatCnt} + eye(numLeftVecs));
  s11rom(sMatCnt) = sMat(1, 1);
end

toc


%% Save results
% disp(' ');
% disp('Saving results ...');
% tic

% fNameSpara = strcat(modelName, 'S_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
%   num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
% for k = 1:length(paramNames)
%   fNameSpara = strcat(fNameSpara, '_', paramNames{k}, '_', num2str(materialParams(k).min,'%14.14g'), '_', ...
%     num2str(materialParams(k).max,'%14.14g'), '_', num2str(materialParams(k).numPnts,'%14.14g'));
% end
% fNameSpara = strcat(fNameSpara, '.txt');
% 
% saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);
% toc

%% plot results

% 2d plot
figure;
plot(fRom, 20*log10(abs(s11rom)));
grid;
hold;

% 3d plot
% for geo1Cnt = 1:length(geoParams(1).steps)
%   for geo2Cnt = 1:length(geoParams(2).steps)
%     s11(geo1Cnt, geo2Cnt) = sMat{(geo1Cnt - 1) * ...
%       length(geoParams(2).steps) + geo2Cnt}(1, 1);
%   end
% end
% 
% surf(geoParams(1).steps, geoParams(2).steps, abs(s11));


%% solve with full model
tic
disp(' ')
disp('Solving with full model...');

numLeftVecs = 2;
freqParam.fExp = 1.1e9;
freqParam.fMin = 1e9;
freqParam.fMax = 1.2e9;
freqParam.numPnts = 101;
c0 = 299792.458e3;
k0 = 2 * pi * freqParam.fExp / c0;
dimSmat = 2;

% build matrices
% call MeshDistorter
systemString = ['cd C:\work\examples\bandpassfilter\bandpass2\ & '...
  'MeshDistorter bandpass2 1.1e9 5 ' num2str(l12) ' ' ...
  num2str(d1) ' ' num2str(d2) ' -dx \w'];
system(systemString);
% name of new created directory
dirName = buildDirName(modelNameOriginalBase, l12, d1, d2);
fNameSysMat = strcat(dirName, 'system matrix');
sMatFreq = MatrixMarketReader(fNameSysMat);
fNameK2Mat = strcat(dirName, 'k^2 matrix');
sMatFreqK2 = MatrixMarketReader(fNameK2Mat);
% systemString2 = ['rmdir ' dirName ' /s /q'];
% system(systemString2);

rhsOrig = zeros(size(sMatFreq, 2), dimSmat);
lVec = zeros(size(sMatFreq, 2), dimSmat);
for dimCnt = 1:dimSmat
  fNameRHS = strcat(geoModelName, 'rhs', num2str(dimCnt-1));
  rhsOrig(:,dimCnt) = vectorReader(fNameRHS);
  fNameLvec = strcat(geoModelName, 'leftVec', num2str(dimCnt-1));
  lVec(:,dimCnt) = vectorReader(fNameLvec);
end
rhsOrig = j*rhsOrig;

freqParam.fCutOff = [7.4948113728104901e+008 7.4948113728104901e+008];
freqParam.steps = calcK_SquareRelSteps(freqParam.fExp, freqParam.fMin, ...
  freqParam.fMax, freqParam.numPnts);
scaleRHS = calcScaleRHS(freqParam.fExp, freqParam.fMin, freqParam.fMax, ...
  freqParam.numPnts, freqParam.fCutOff);
rhsF = cell(numLeftVecs, 1);
leftVecsF = cell(numLeftVecs, 1);
for rhsCnt = 1:numLeftVecs
  rhsF{rhsCnt} = rhsOrig(:,rhsCnt);
  leftVecsF{rhsCnt} = lVec(:,rhsCnt);
end

% solve
sF = cell(freqParam.numPnts);
for kStepCnt = 1:freqParam.numPnts
  fMat = sMatFreq - k0^2 * freqParam.steps(kStepCnt) * sMatFreqK2;
  % fMat = sys{1};
  redRhsScaled = cell(numLeftVecs, 1);
  for k = 1:numLeftVecs
    % rhs is only frequency dependent
    % redRhsScaled{k} = -0.5*scaleRHS{k}(kStepCnt)*rhsF{k};
    % different scaling of rhs because there's no reduction step
    redRhsScaled{k} = scaleRHS{k}(kStepCnt)*rhsF{k};
  end
  for rhsCnt = 1:length(rhsF)
    sol = fMat\redRhsScaled{rhsCnt};    % solve equation system
    for lVecCnt = 1:numLeftVecs
      sF{kStepCnt}(lVecCnt, rhsCnt) = leftVecsF{lVecCnt}.' * sol;
    end
  end
end
for sMatCnt = 1:length(sF)
  sF{sMatCnt} = inv(sF{sMatCnt} - eye(numLeftVecs))...
    * (sF{sMatCnt} + eye(numLeftVecs));
end

toc;

% 2d plot
if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax - freqParam.fMin) / (freqParam.numPnts - 1);
end
fOrig = zeros(kStepCnt, 1);
s11FOrig = zeros(kStepCnt, 1);
for kStepCnt = 1:freqParam.numPnts
  fOrig(kStepCnt) = freqParam.fMin + (kStepCnt - 1) * deltaF;
  s11FOrig(kStepCnt) = sF{kStepCnt}(1, 1);
end
% figure;
plot(fOrig, 20*log10(abs(s11FOrig)), 'r');
% grid;
% hold;

% error plot
figure;
semilogy(fOrig, abs(s11FOrig-s11rom.'));
grid;
