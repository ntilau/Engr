function  P = pGeneration(projectPath, modelFolder, portName)


modelName = [ projectPath modelFolder ];

% read system matrices
SysMat = MatrixMarketReader(strcat(modelName, 'system matrix'));
dim3D = length(SysMat(:,1));   % Wo bekommt man das sonst her ???????   

%----------------------------------------------------------------
% Load raw 3D model dimoension from system matrix
fid = fopen( strcat(modelName, 'system matrix'), 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end
% read header
fscanf( fid, '%s', 3 );
varType = fscanf( fid, '%s', 1 );
matType = fscanf( fid, '%s', 1 );

rowDim  = fscanf( fid, '%i', 1 );
colDim  = fscanf( fid, '%i', 1 );
fclose(fid);
dim3D = colDim;
%----------------------------------------------------------------
% Load raw 2D model dimoension from system matrix
correspondence = [projectPath portName '\' portName '.num'];
fid = fopen( correspondence, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

% read header
bracketO1 = fscanf(fid, '%s', 1);
EnumerationStr = fscanf(fid, '%s', 1);

sizeStr = fscanf(fid, '%s', 1);
sizeNr  = fscanf( fid, '%i', 1 );

fclose(fid);
dim2D = sizeNr;
%----------------------------------------------------------------
% Load 3D <-> 2D data

correspondence = [projectPath portName '\' portName '2D3D.num'];
[nat2act, act2nat ] = numReader( correspondence );

%----------------------------------------------------------------
% Generate matrix P
disp(' ');
myStr = ['Compute matrix P for port: ' portName];
disp(myStr);

tic
P = sparse(dim3D,dim2D);

indexPositions = find( nat2act > -1 );

for k = 1:length(indexPositions),
   P( nat2act(indexPositions(k)) + 1, indexPositions(k) ) = 1; % Achtung + 1
end


toc