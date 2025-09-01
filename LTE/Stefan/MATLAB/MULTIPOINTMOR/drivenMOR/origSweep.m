close all;
clear all;
clc;

format long;

constants;


% Define pathes
[status,result] = system('echo %LTE_ROOT%');
mainFolder = [ result(1:end-1) '\MATLAB\' ];
drivenPath = [ mainFolder 'multiPointMOR\drivenMOR'];
wgPath = [mainFolder 'multiPointMOR\wgMOR'];
IOPath = [mainFolder 'IO'];

addpath(drivenPath, wgPath, IOPath);

% Run project definition script
projects


%% Generate port names
% read boundary condition file
bcName = [ projectPath projectName '.bc' ];
bcOriginalStructure = bcRead(bcName);
% read formulation file
frmName = [ projectPath projectName '.frm' ];
frmOriginalStructure = frmRead(frmName);

% compose port names
portCount=1;
for k = 1:length(bcOriginalStructure),
    if bcOriginalStructure(k).bcType == 1,
        portName{portCount} = [projectName bcOriginalStructure(k).name];
        portCount = portCount+1;
    end
end


%% Generate and load linear system data
% ------------------------------------------------------------------
% em_wavemodelreduction
disp(' ')
disp('Generate raw model ...');

system(['cd ' projectPath ' & EM_waveModelReduction ' projectName ' ' ...
                  computationFreqStr ' ' basisOrder  ' +saveRawModel '] );
% --------------------------------------------------------------------

modelFolder = [ projectName '_' computationFreqStr '_' basisOrder '\'] ;
modelName = [ projectPath modelFolder ];

% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numPortsParamFile, abcFlag] = ...
readModParaTxt(fNameModRedTxt);          

% read system matrices
SysMat = MatrixMarketReader(strcat(modelName, 'system matrix'));
T = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));



%% Generate 2D <-> 3D correspondence
disp(' ')
disp('compute P ...');


for k = 1:numPorts,
    P{k} = pGeneration(projectPath, modelFolder, portName{k});
end


%% Build Original Model

fS = linspace(freqParam.fMin, freqParam.fMax, freqParam.numPnts);
kS = 2*pi*fS/c0;

k0 = 2*pi*f0/c0;
Snabc = SysMat + k0^2*T;
if abcFlag
    abcMatk0 = MatrixMarketReader(strcat(modelName, 'ABC'));
else
    [ySp, xSp] = size(SysMat);
    abcMatk0 = sparse(ySp, xSp);
end
abcMat = ( abcMatk0 )/k0;
S = Snabc - abcMatk0;




%% Frequency sweep

I = diag(ones(1,numPorts*numModes));


% Initial step
n=1;
for kPort = 1:numPorts,
    T_AVP{kPort} = MatrixMarketReader( [projectPath portName{kPort} '\mat_1'] );
    [ rhsAVPold{kPort}, eValue{kPort,n}  ] = ...
            generateExcitation(projectPath, portName{kPort}, fS(n), numModes)     
end



% Sweep
for n = 1:length(fS),
    fS(n)

    % Port count
    for kPort = 1:numPorts,
        disp(['Solving 3D system for Port ' num2str(kPort) '...']);
        
        % solve eigenvalue problem for rhs
        [ rhsAVP{kPort}, eValue{kPort,n} ] = ...
                generateExcitation(projectPath, portName{kPort}, fS(n), numModes*2); 
        
        
        % switch and norm rhs
        for kMode = 1:numModes*2,
%             if ( rhsAVPold{kPort}(:,kMode).' * T_AVP{kPort} * rhsAVP{kPort}(:,kMode) ) < 0,
%                 rhsAVP{kPort}(:,kMode) = - rhsAVP{kPort}(:,kMode);
%                 disp('Sign!!!');                
%             end
            rhsAVP{kPort}(:,kMode) = rhsAVP{kPort}(:,kMode) / ...
                    sqrt( rhsAVP{kPort}(:,kMode).'*T_AVP{kPort}*rhsAVP{kPort}(:,kMode) );
        end
        
        % eigenmode tracing
        for kMode = 1:numModes,
            [ maxVal, maxPos ] = ...
                        max(  abs(   rhsAVP{kPort}.' * T_AVP{kPort} * rhsAVPold{kPort}(:,kMode)  ) );
            %----------------------------        
            maxVal2 = rhsAVP{kPort}(:,maxPos).' * T_AVP{kPort} * rhsAVPold{kPort}(:,kMode)
            if maxVal2>0,
                rhsAVPold{kPort}(:,kMode) = rhsAVP{kPort}(:,maxPos);        
            else
                rhsAVPold{kPort}(:,kMode) = -rhsAVP{kPort}(:,maxPos);        
            end
            %----------------------------            
            rhsAVP{kPort}(:,maxPos) = zeros(size(rhsAVPold{kPort}(:,kMode)));
            eValueSort(kMode) = eValue{kPort,n}(maxPos);
            maxVal
            maxPos
        end
        % 
        eValue{kPort,n} = eValueSort;
        rhsAVP{kPort} = rhsAVPold{kPort};
        
        for kMode = 1:numModes,
%            rhsAVPold{kPort}(:,kMode) = rhsAVP{kPort}(:,kMode);         
            
%             if real(eValue{kPort,n}(kMode)) < 0
%                 eValue{kPort,n}(kMode) = -eValue{kPort,n}(kMode);
%             end

            if imag(eValue{kPort, n}(kMode)) == 0,
                if real(eValue{kPort, n}(kMode)) < 0,
                    eValue{kPort, n}(kMode)= -eValue{kPort, n}(kMode);
                end    
%                 if imag(eValue{kPort, n}(kMode)) > 0,
%                     eValue{kPort, n}(kMode)= eValue{kPort, n}(kMode)';
%                 end                 
            elseif real(eValue{kPort, n}(kMode)) == 0,
%                  if real(eValue{kPort, n}(kMode)) < 0,
%                     eValue{kPort, n}(kMode)= -eValue{kPort, n}(kMode);
%                 end    
                if imag(eValue{kPort, n}(kMode)) > 0,
                    eValue{kPort, n}(kMode)= eValue{kPort, n}(kMode)';
                end 
            elseif real(eValue{kPort, n}(kMode)) < 0,
                    eValue{kPort, n}(kMode)= -eValue{kPort, n}(kMode);               
            end  
            
            
            
%  eValue{kPort,n}(kMode)= real(eValue{kPort,n}(kMode)) +  i*imag(eValue{kPort,n}(kMode));


%             alpha{kPort}(kMode) = i*c0* eValue{kPort,n}(kMode)*kS(n)* ...
%                     rhsAVP{kPort}(:,kMode).' * T_AVP{kPort} * rhsAVP{kPort}(:,kMode) / u_0 ; 

            alpha{kPort}(kMode) = i*c0* eValue{kPort,n}(kMode)*kS(n) / u_0 ; 

                
            kExit = (kPort-1)*numModes + kMode;
            alphaExit(kExit) = alpha{kPort}(kMode);
            rhsAVPP{kExit} = - P{kPort}* eValue{kPort,n}(kMode).' ... 
                       * T_AVP{kPort} * rhsAVP{kPort}(:,kMode) /  sqrt( alphaExit(kExit) ) ;
            
            
            
            sol3D{n,kExit} = (S + kS(n)*abcMat - kS(n)^2*T) ...
                            \ (-i*fS(n)*2*pi*rhsAVPP{kExit}/ u_0 );
        end
    end

    % compute solutions of original system
    for kx = 1:(numPorts*numModes),
        for ky = 1:(numPorts*numModes),
            zMat{n}(ky,kx) = (  rhsAVPP{ky}.' * sol3D{n,kx} );
        end
    end
    sMat{n} = inv(-I + zMat{n})*(zMat{n} + I);
%     sMat{n} = inv(I - zMat{n})*(-zMat{n} - I);
%     SMatrix = sMat{n}
    eValue{1:2}
end

% for n=1:length(fS)
%    s11(n) = sMat{n}(1,1)   ;
%     
% end  
% plot(fS, 20*log10(abs(s11)));



%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');



fNameSpara = strcat(modelName, 'sOrig_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));

fNameSpara = strcat(fNameSpara, '.txt');

paramSpace = [];
paramNames = [];
numLeftVecs=3;

saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);

%% Plot Evalues

for n=1:length(fS),
myValues(n,:) = eValue{2,n}(1:7).';
end
figure(2);
title('Original-Sweep für inhomogenen Port, Moden 1:7');
subplot(2,1,2);
hold on;
plot(fS*1e-9, -real(myValues));
xlabel('Frequency (GHz)','FontSize',12);
ylabel('Re(\gamma)','FontSize',12);
hold off;
grid on;

subplot(2,1,1);
hold on;
plot(fS*1e-9, -imag(myValues));
xlabel('Frequency (GHz)','FontSize',12);
ylabel('Im(\gamma)','FontSize',12);
hold off;
grid on;


%% Plot Original Model Data

fNameSpara = strcat(modelName, 'sOrig_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
% fNameSparaOrig = strcat(fNameSpara, '_3Mode.txt');
fNameSparaOrig = strcat(fNameSpara, '.txt');

[parameterNamesMulti, numParameterPntsMulti, parameterValsMulti, sMatricesMulti] ...
  = loadSmatrix(fNameSparaOrig);
sValOrig = zeros(numParameterPntsMulti(1),1);
freqsMulti = zeros(numParameterPntsMulti(1),1);
for k = 1:numParameterPntsMulti(1)
  fM(k) = parameterValsMulti(1,k);
  sO11(k) = sMatricesMulti{k}(1, 1);
  sO88(k) = sMatricesMulti{k}(8, 8);
  
  sO19(k) = sMatricesMulti{k}(1, 9);
  sO91(k) = sMatricesMulti{k}(9, 1);
  
  sO22(k) = sMatricesMulti{k}(2, 2);
  sO99(k) = sMatricesMulti{k}(9, 9);
  
  sO12(k) = sMatricesMulti{k}(1, 2);
  sO89(k) = sMatricesMulti{k}(8, 9);
  
  
end






figHandle = figure(1);
set(figHandle,'color','w');
subplot(5,2,1);
plot(fM*1e-9, 20*log10(abs(sO11)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO11)),  'green', 'LineWidth',2);
hold off;
ylabel(['|s_{11}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;
% 
subplot(5,2,3);
plot(fM*1e-9, 20*log10(abs(sO19)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO19)),  'green', 'LineWidth',2);
hold off;
ylabel(['|s_{19}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;

subplot(5,2,5);
plot(fM*1e-9, 20*log10(abs(sO22)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO22)),  'green', 'LineWidth',2);
hold off;
ylabel(['|s_{22}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;

subplot(5,2,7);
plot(fM*1e-9, 20*log10(abs(sO12)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO12)),  'green', 'LineWidth',2);
hold off;
ylabel(['|s_{12}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;


% subplot(5,2,9);
% semilogy(fM*1e-9, abs( sM11-sS11), 'red');
% hold on;
% semilogy(fM*1e-9, abs( sM12-sS12), 'blue');
% semilogy(fM*1e-9, abs( sM14+sM14), 'yellow');
% semilogy(fM*1e-9, abs( sM15-sM15), 'green');
% hold off;
% ylabel(['Fehler |s_{xy}-s_{xy}|']);
% xlabel('Frequenz in GHz');
% grid on;

% figure(33);
% plot(fM*1e-9, angle(sS12)/pi*180);
% ylabel(['|s_{15}|_{dB}']);
% xlabel('Frequenz in GHz');





subplot(5,2,2);
plot(fM*1e-9, 20*log10(abs(sO88)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO88)), 'green', 'LineWidth',2);
hold off;
ylabel(['|s_{88}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;

subplot(5,2,4);
plot(fM*1e-9, 20*log10(abs(sO91)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO91)), 'green', 'LineWidth',2);
hold off;
ylabel(['|s_{91}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;

subplot(5,2,6);
plot(fM*1e-9, 20*log10(abs(sO99)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO99)), 'green', 'LineWidth',2);
hold off;
ylabel(['|s_{99}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;

subplot(5,2,8);
plot(fM*1e-9, 20*log10(abs(sO89)), 'black', 'MarkerSize',2);
hold on;
plot(fM*1e-9, 20*log10(abs(sO89)), 'green', 'LineWidth',2);
hold off;
ylabel(['|s_{89}|_{dB}']);
xlabel('Frequenz in GHz');
grid on;


% subplot(5,2,10);
% semilogy(fM*1e-9, abs( sM41-sM41), 'red');
% hold on;
% semilogy(fM*1e-9, abs( sM22-sM22), 'red');
% semilogy(fM*1e-9, abs( sM24-sM24), 'red');
% semilogy(fM*1e-9, abs( sM25-sM25), 'red');
% hold off;
% ylabel(['Fehler |s_{xy}-s_{xy}|']);
% xlabel('Frequenz in GHz');
% grid on;
