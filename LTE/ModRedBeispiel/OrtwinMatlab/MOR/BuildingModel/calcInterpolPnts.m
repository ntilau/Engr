function interpolPnts = calcInterpolPnts(numParams, order)

for orderCnt = order:-1:0
  multiIndex = [];
  multiIndex = rec(numParams - 1, orderCnt, multiIndex, 0, 1);
  multiIndex(:, numParams) = order - orderCnt;
  interpolPnts{orderCnt + 1} = multiIndex;
end

