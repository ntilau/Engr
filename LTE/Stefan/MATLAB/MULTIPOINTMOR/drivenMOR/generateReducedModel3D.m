function Qp = generateReducedModel3D(projectPath, modelFolder, portName, fExp, P, numModes, numPorts )

constants;
modelName = [ projectPath modelFolder ];


%% load unreduced model
disp(' ')
disp('Loading raw model...');


% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numExit, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);


% read "model.pvar"
fNameModPvar = strcat(modelName, 'model.pvar');
[freqParam, materialParams] = readModParVar(fNameModPvar);


% read system matrices
SysMat = MatrixMarketReader(strcat(modelName, 'system matrix'));
T = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));

%% Generate Reduced Model
disp(' ');
disp('Generate reduced 3D Model ...');
tic


% Expansion Frequencies
kExp = 2*pi*fExp/c0;

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



I = diag(ones(1,numPorts*numModes));

n=1;
for kPort = 1:numPorts,
    T_AVP{kPort} = MatrixMarketReader( [projectPath portName{kPort} '\mat_1'] );
    [ rhsAVPold{kPort}, evVectorAVP{kPort}  ] = generateExcitation(projectPath, portName{kPort}, fExp(n), numModes);     
end

for n = 1:length(fExp),
    fExp(n)

    for kPort = 1:numPorts,
        disp(['Solving 3D system for Port ' num2str(kPort) '...']);
        [ rhsAVP{kPort}, evVectorAVP{kPort} ] = generateExcitation(projectPath, portName{kPort}, fExp(n), numModes); 
        for kMode = 1:numModes,
            if ( rhsAVPold{kPort}(:,kMode).' * T_AVP{kPort} * rhsAVP{kPort}(:,kMode) ) < 0,
                rhsAVP{kPort}(:,kMode) = - rhsAVP{kPort}(:,kMode);
            end
            rhsAVP{kPort}(:,kMode) = rhsAVP{kPort}(:,kMode) / ...
                    sqrt( rhsAVP{kPort}(:,kMode).'*T_AVP{kPort}*rhsAVP{kPort}(:,kMode) );
        end
        for kMode = 1:numModes,
            [maxVal{kPort}(n,kMode), maxPos{kPort}(n,kMode)] = max(rhsAVPold{kPort}.'*T_AVP{kPort}*rhsAVP{kPort}(:,kMode));
            rhsAVPold{kPort}(:,maxPos{kPort}(n,kMode)) = zeros(size(rhsAVPold{kPort}(:,kMode)));
        end

        rhsAVP{kPort} = rhsAVP{kPort}(:,[maxPos{kPort}(n,:)]);
        evVectorAVP{kPort} = evVectorAVP{kPort}([maxPos{kPort}(n,:)]);
        
        for kMode = 1:numModes,
            rhsAVPold{kPort}(:,kMode) = rhsAVP{kPort}(:,kMode);         
            if real(evVectorAVP{kPort}(kMode)) < 0
                evVectorAVP{kPort}(kMode) = -evVectorAVP{kPort}(kMode);
            end
            
            rhsAVPT{kPort}(:,kMode) = - evVectorAVP{kPort}(kMode).' * ...
                    T_AVP{kPort} * rhsAVP{kPort}(:,kMode)  ;
            alpha{kPort}(kMode) = i*c0* evVectorAVP{kPort}(kMode)*kExp(n)* ...
                    rhsAVP{kPort}(:,kMode).' * T_AVP{kPort} * rhsAVP{kPort}(:,kMode) / u_0 ; 


            kExit = (kPort-1)*numModes + kMode;
            alphaExit(kExit) = alpha{kPort}(kMode);
            rhsAVPP{kExit} = P{kPort}*rhsAVPT{kPort}(:,kMode);
            sol3D{n,kExit} = (S + kExp(n)*abcMat - kExp(n)^2*T) \ (-i*fExp(n)*2*pi*rhsAVPP{kExit} / u_0 );
        end
    end
end

% for n=1:length(fExp)
%    s11(n) = sMat{n}(1,1);
% end  
% plot(fExp, 20*log10(abs(s11)));



 
'Reduction'
Qp = [ ];
for n = 1:length(fExp),
    for k = 1:(numPorts*numModes),
        Qp = [ Qp  sol3D{n,k} ];
    end
end

[Qp,R] = qr(Qp,0);


% Subspace Projection
sysMatRed{1} = Qp.'*S*Qp;
sysMatRed{2} = Qp.'*T*Qp;
sysMatRed{3} = Qp.'*abcMat*Qp;


disp(' ');
disp('3D Model generation timnetime ...');
toc

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
