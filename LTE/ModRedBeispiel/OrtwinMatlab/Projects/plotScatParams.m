function sVal = plotScatParams(parameterNames, numParameterPnts, ...
                               parameterVals, sMatrices, sRow, sCol)


nonOne = length(find(numParameterPnts ~= 1));
if length(parameterNames) == 1 | nonOne == 1
  for k = 1:numParameterPnts(1)
    freqs(k) = parameterVals(1,k);
    sVal(k) = sMatrices{k}(sRow, sCol);
  end
  %plot(freqs*1e-9, abs_s);
  plot(freqs*1e-9, 20*log10(abs(sVal)));
  %semilogy(freqs*1e-9, abs_s);
elseif length(parameterNames) == 2
  pos = 1;
  for fCnt = 1:numParameterPnts(1)
    for pCnt = 1:numParameterPnts(2)
      freqs(fCnt) = parameterVals(1,pos);
      matVals(pCnt) = parameterVals(2,pos);
      sVal(pCnt, fCnt) = sMatrices{pos}(sRow, sCol);
      pos = pos + 1;
    end
  end
  surf(freqs*1e-9, matVals, abs(sVal));
elseif length(parameterNames) == 3
  pos = 1;
  nonOnePos = find(numParameterPnts(2:end) ~= 1) + 1;
  for fCnt = 1:numParameterPnts(1)
    for pCnt = 1:numParameterPnts(nonOnePos)
      freqs(fCnt) = parameterVals(1,pos);
      matVals(pCnt) = parameterVals(2,pos);
      sVal(pCnt, fCnt) = sMatrices{pos}(sRow, sCol);
      pos = pos + 1;
    end
  end
  surf(freqs*1e-9, matVals, abs(sVal));
else
  error('Not yet implemented');
end

