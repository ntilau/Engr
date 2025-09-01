function rhsMatrixGeneration(P, Q, projectPath, portName, numPorts)


constants;


%% Generate rhs reduces matrices
disp(' ');
disp('Generate rhs matrices ...');
tic


for k = 1:numPorts,
    fName = [projectPath portName{k} '\projMat'];
    RedSys{k}.Q2D0 = readMatFull( [fName '_Q0'] );
    RedSys{k}.Q2D1 = readMatFull( [fName '_Q1']);
    T_AVP{k} = MatrixMarketReader( [projectPath portName{k} '\mat_1'] );    
     
    T_FE0{k} = Q.'*P{k}* T_AVP{k}*(RedSys{k}.Q2D0 );
    T_FE1{k} = Q.'*P{k}* T_AVP{k}*( RedSys{k}.Q2D1);  
end


disp(' ');
disp('Generate rhs matrices computation time ...');
toc

%% Save rhs reduced matrices
tic
disp(' ')
disp('Saving reduced order model...');

for k = 1:numPorts,
    fName = [projectPath portName{k} '\rhsMat'];
    writeMatFull( T_FE0{k}, [fName 'T_FE0'] );
    writeMatFull( T_FE1{k}, [fName 'T_FE1'] );
end


toc