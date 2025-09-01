function fNameSpara = evaluateCompleteFramework5(projectPath, modelFolder, portName, fEval, numModes, numPorts )


constants;

modelName = [ projectPath modelFolder ];

%% load model data
disp(' ')
disp('Loading raw model...');

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numExit, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);


% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);


stepSpace = [];
paramSpace = [];

%% load reduced system

% read names of the reduced system matrices, indicating their polynomial
% parameter dependence
fName = strcat(modelName, 'sysMatMultiNames');
sysMatRedNames = readSysMatRedNames(fName);
orderParamDependence = sum(sysMatRedNames(end,:));
linearFlag = false;
if orderParamDependence == 1
  % System matrix of ROM only shows linear parameter dependence
  linearFlag = true;
end
[r c] = size(sysMatRedNames);

% read reduced system matrices
for k = 1:r
  fName = strcat(modelName, strcat('sysMatMulti_', ...
    num2str(sysMatRedNames(k,1))));
  for m = 2:c
    fName = strcat(fName, '_', num2str(sysMatRedNames(k,m)));
  end
  sys{k} = readMatFull(fName);
end



S_red = sys{1};
T_red = sys{2};
A_red = sys{3};



%% Evaluate reduced 2D Problem

for k = 1:numPorts,
   [ RedEP{k}.eigVal2D, RedEP{k}.eigVec2D ] = evaluateReducedModel2D(projectPath, portName{k}, fEval, numModes);
   plotReducedModel2D(fEval, RedEP{k}.eigVal2D, numModes, k);
end


% load reduced 2D problem data 
for k = 1:numPorts,
    fName = [projectPath portName{k} '\projMat'];
    RedSys{k}.Q2D0 = readMatFull( [fName '_Q0'] );
    RedSys{k}.Q2D1 = readMatFull( [fName '_Q1']);

    fName = [ projectPath  portName{k}  '\redMat'];
    RedSys{k}.TU_0 = readMatFull([fName '_TU_0']);
    RedSys{k}.TU_1 = readMatFull([fName '_TU_1']);
    RedSys{k}.TU_2 = readMatFull([fName '_TU_2']);
end



% load rhs reduced matrices 
for k = 1:numPorts,
    fName = [projectPath portName{k} '\rhsMat'];
    T_FE0{k} = readMatFull( [fName 'T_FE0'] );
    T_FE1{k} = readMatFull( [fName 'T_FE1']);
end

%% Evaluate reduced 3D Problem


sprintf('Evaluate 3D Model')
tic

kEval = 2*pi*fEval/c0;

I = diag(ones(1,numPorts*numModes));
    

n=1;
for kPort = 1:numPorts,
    for kMode = 1:numModes,
    eVector{kPort, kMode} = RedEP{kPort}.eigVec2D(:, (n-1)*numModes + kMode  );
    eVectorOld{kPort, kMode} =   eVector{kPort, kMode} ;    
    end
end


for n = 1:length(fEval),
    fEval(n)
    for kPort = 1:numPorts,
        T_AVP_red{kPort} = RedSys{kPort}.TU_0 + kEval(n)*RedSys{kPort}.TU_1 + kEval(n)^2*RedSys{kPort}.TU_2;
        for kMode = 1:numModes,
            kExit = (kPort-1)*numModes + kMode;
            eVector{kPort, kMode} = RedEP{kPort}.eigVec2D(:, (n-1)*numModes + kMode );
            eValue{kPort, kMode}  = RedEP{kPort}.eigVal2D(:, (n-1)*numModes + kMode );

                eValue{kPort, kMode}= eValue{kPort, kMode}';

              
                
                
            if abs(imag(eValue{kPort, kMode})) < 1e-6,
                if real(eValue{kPort, kMode}) < 0,
                    eValue{kPort, kMode}= -eValue{kPort, kMode};
                end    
                if imag(eValue{kPort, kMode}) > 0,
                    eValue{kPort, kMode}= eValue{kPort, kMode}';
                end                 
            elseif abs(real(eValue{kPort, kMode})) < 1e-6,
                 if real(eValue{kPort, kMode}) < 0,
                    eValue{kPort, kMode}= -eValue{kPort, kMode};
                end    
                if imag(eValue{kPort, kMode}) > 0,
                    eValue{kPort, kMode}= eValue{kPort, kMode}';
                end 
            elseif real(eValue{kPort, kMode}) < 0,
                    eValue{kPort, kMode}= -eValue{kPort, kMode};               
            end   



            eVector{kPort, kMode} = eVector{kPort, kMode} / ...
                    sqrt(eVector{kPort, kMode}.' * T_AVP_red{kPort}* eVector{kPort, kMode});
                
                
            if ( eVectorOld{kPort, kMode}.' * T_AVP_red{kPort}* eVector{kPort, kMode}) < 0,
                eVector{kPort, kMode} = -eVector{kPort, kMode};
                disp('Sign!!!');
            end
            eVectorOld{kPort, kMode} = eVector{kPort, kMode};
%             normT = (eVector{kPort, kMode}.' * (T_AVP_red{kPort} * eVector{kPort, kMode}));
            normT=1;
            alpha{kExit} = i*c0* eValue{kPort, kMode}*kEval(n)* normT / u_0 ;
            rhsAVPP{kExit} = (eValue{kPort, kMode}*(T_FE0{kPort} + kEval(n)*T_FE1{kPort}) ...
                        *eVector{kPort, kMode}) /  sqrt(  alpha{kExit})   ;
                solVec3D{kExit} = (S_red + kEval(n)*A_red - kEval(n)^2*T_red) ...
                    \ (i*fEval(n)*2*pi*rhsAVPP{kExit} / u_0 );
        end
    end
    for kx = 1:(numPorts*numModes),
        for ky = 1:(numPorts*numModes),
%             zMat{n}(ky,kx) = -(solVec3D{kx} .' * rhsAVPP{ky}/  sqrt(  alpha{ky}*alpha{kx} ) );
            zMat{n}(ky,kx) = -(solVec3D{kx} .' * rhsAVPP{ky});
        end
    end
    sMat{n} = inv(-I + zMat{n})*(zMat{n} + I);
%     eValue
end


time2=toc;
sprintf('Model evaluation time: %f', time2)

%% Save Data

disp(' ');
disp('Saving results ...');
tic

fNameSpara = strcat(modelName, 'sMultiDisp_', num2str(freqParam.fMin,'%14.14g'), '_', ...
  num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));

fNameSpara = strcat(fNameSpara, '.txt');

saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numPorts, paramSpace, paramNames);
 
toc




