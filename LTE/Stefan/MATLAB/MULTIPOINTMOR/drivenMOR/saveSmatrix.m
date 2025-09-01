function saveSmatrix(sMat, freqParam, materialParams, ...
  filename, numLeftVecs, paramSpace, paramNames)

fid = fopen( filename, 'wt' );

fprintf(fid, 'Number of parameters: %i \n', length(materialParams)+1);
fprintf(fid, 'FREQUENCY %i \n', freqParam.numPnts);
for k = 1:length(materialParams)
  fprintf(fid, '%s %i \n', paramNames{k}, materialParams(k).numPnts);
end

[r c] = size(sMat{1});
fprintf(fid, 'Dimensions scattering matrix: %i %i \n', r, c);

if freqParam.numPnts == 1
  deltaF = 0;
else
  deltaF = (freqParam.fMax-freqParam.fMin)/(freqParam.numPnts-1);
end

[rSpace cSpace] = size(paramSpace);

for kCnt = 1:freqParam.numPnts
  if cSpace
    for pPointCnt = 1:cSpace
      pos = (kCnt-1) * cSpace + pPointCnt;
      newCol = [];
      newCol(1) = freqParam.fMin+(kCnt-1)*deltaF;
      for pCnt = 1:rSpace
        newCol= [newCol; real(paramSpace(pCnt, pPointCnt)); ...
          imag(paramSpace(pCnt, pPointCnt))];
      end
      data(:, pos) = newCol;
    end
  else
    newCol = [];
    newCol(1) = freqParam.fMin+(kCnt-1)*deltaF;
    data(:, kCnt) = newCol;
  end
end

[r c] = size(sMat{1});
for rCnt = 1:r
  for cCnt = 1:c
    sol_r_c = zeros(1, length(sMat));
    for k = 1:length(sMat)
      sol_r_c(k) = sMat{k}(rCnt, cCnt);
    end
    data = [data; real(sol_r_c); imag(sol_r_c)];
  end
end
    
cmdStr = 'fprintf(fid,''%e ';
for pCnt = 1:length(materialParams)
  cmdStr = [cmdStr ' (%e, %e)'];
end
for rCnt = 1:r
  for cCnt = 1:c
    cmdStr = [cmdStr  ' s_' num2str(rCnt) '_' num2Str(cCnt) ...
      ': (%18.17e, %18.17e) '];
  end
end
cmdStr = [cmdStr  ' \n'', data);'];

eval(cmdStr);
fclose( fid );
