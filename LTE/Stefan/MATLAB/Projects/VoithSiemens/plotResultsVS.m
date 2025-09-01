function plotData = plotResultsVS(results, params, paramSpace, outputId)


isPlotParam = zeros(1, length(params));
% determine whether it is a one or two dimensional plot
plotDimension = 0;
for paramCnt = 1 : length(params);
  if params{paramCnt}.numPnts > 1
    plotDimension = plotDimension + 1;
    isPlotParam(paramCnt) = 1;
  end
end

if plotDimension == 1
  % if results{resultCnt} is a matrix, plot entry (1, 1)
  xData = zeros(length(results), 1);
  yData = zeros(length(results), 1);
  for resultCnt = 1 : length(results)
    xData(resultCnt) = paramSpace(find(isPlotParam) + (resultCnt - 1) * length(params));
    yData(resultCnt) = results{resultCnt}(outputId(1), outputId(2));
  end
  figure;
  if nnz(imag(yData))
    plot(xData, abs(yData));
  else
    plot(xData, yData);
  end
%   grid;
  xlabel(params{find(isPlotParam)}.name);
  plotData.xData = xData;
  plotData.yData = yData;
elseif plotDimension == 2
  error('Not yet implemented!');
else
  error('Not yet implemented!');
end
