function params = computeParamPnts(params)

for pCnt = 1 : length(params)
  if params{pCnt}.numPnts == 1
    params{pCnt}.pnts = params{pCnt}.min;
  else
    params{pCnt}.pnts = params{pCnt}.min : (params{pCnt}.max - params{pCnt}.min) / ...
      (params{pCnt}.numPnts - 1) : params{pCnt}.max;
  end
end

