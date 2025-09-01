function interpolPnts = calcInterpolPnts(numParams, order)

if numParams == 1
  interpolPnts{1} = 1;
else
  interpolPnts = cell(order + 1, 1);
  for orderCnt = order:-1:0
    multiIndex = [];
    multiIndex = rec(numParams - 1, orderCnt, multiIndex, 0, 1);
    multiIndex(:, numParams) = order - orderCnt;
    interpolPnts{orderCnt + 1} = multiIndex;
  end
end

