function [muReal, muImag, cost]= readCost3d(fNameCost3d)

% write costs in a file
fid = fopen(fNameCost3d,'r');

numMuRealPnts = fscanf(fid, '%d', 1);
numMuImagPnts = fscanf(fid, '%d', 1);
muReal = zeros(numMuRealPnts, 1);
muImag = zeros(numMuImagPnts, 1);
cost = zeros(numMuRealPnts, numMuImagPnts);
for muRealCnt = 1:numMuRealPnts
  for muImagCnt = 1:numMuImagPnts
    muReal(muRealCnt) = fscanf(fid, '%f', 1);
    muImag(muImagCnt) = fscanf(fid, '%f', 1);
    cost(muRealCnt, muImagCnt) = fscanf(fid, '%f', 1);
%     fscanf(fid,'%16.12f  %16.12f %16.12f \n', muReal(muRealCnt),...
%       muImag(muImagCnt), cost(muRealCnt, muImagCnt));
  end
end

fclose(fid);
