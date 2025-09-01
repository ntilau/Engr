function [parNames, numParPnts, parVals, sMats] = readscatmats(filename)

disp(' ');
disp('Loading scattering parameters ...');
fid = fopen( filename, 'r' );
fscanf(fid, '%s', 3);   % read empty string
numParams = fscanf(fid, '%d', 1);

parNames = cell(numParams,1);
numParPnts = zeros(numParams,1);
for k = 1:numParams
    parNames{k} = fscanf(fid, '%s', 1);
    numParPnts(k) = fscanf(fid, '%d', 1);
end

numPntsTotal = 1;
for k = 1:numParams
    numPntsTotal = numParPnts(k) * numPntsTotal;
end

% read dimension of s-matrices
fscanf(fid, '%s %s %s', 3);  % read 'Dimensions scattering matrix:'
rowDim = fscanf(fid, '%i', 1);
colDim = fscanf(fid, '%i', 1);

% build textscan string
data = [];
tString = 'data = textscan(fid, ''%f'; % read frequency value (real)
for parCnt = 2:numParams
    tString = strcat(tString, ' %f %f'); % read other parameter values (complex)
end
for rCnt = 1:rowDim
    for cCnt = 1:colDim
        tString = strcat(tString, ' s_', num2str(rCnt), '_', num2str(cCnt), ...
            ': %f %f');
    end
end
tString = strcat(tString, ''', ''Whitespace'', '' \b\t\n(,)'');');
eval(tString);
fclose(fid);

parVals = zeros(numParams, length(data{1}));
parVals(1,:) = data{1};
currentPos = 2;
for parCnt = 2:numParams
    parVals(parCnt,:) = data{currentPos} + j*data{currentPos+1};
    currentPos = currentPos + 2;
end

sMats = cell(rowDim,colDim);
for rCnt = 1:rowDim
    for cCnt = 1:colDim
        sMats{rCnt,cCnt} = data{currentPos} + j*data{currentPos+1};
        currentPos = currentPos + 2;
    end
end


