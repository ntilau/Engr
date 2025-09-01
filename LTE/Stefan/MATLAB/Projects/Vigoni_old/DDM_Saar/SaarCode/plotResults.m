function F = plotResults(results, sId, frameParamId)

% initialize
myDim = 0;
kk = 1;
paramId = [];
% F = [];

% get parameter dimension
for ii = 1:length(results.param)
    myDim = myDim + (length(results.param{ii}.Vals) ~= 1);
    if (length(results.param{ii}.Vals) ~= 1)
        paramId(kk) = ii;
        kk = kk + 1;
    end
end

if myDim == 1
    % one parameter plot

    % initialize
    dimP1 = length(results.param{paramId}.Vals);
    sVal = zeros(dimP1, 1);

    % get results
    for p1Cnt = 1:dimP1
        sVal(p1Cnt) = results.sMat{p1Cnt}(sId(1), sId(2));
    end

    % plot
    figure;
    plot(results.param{paramId}.Vals, abs(sVal), '-*');
    grid on;
    title(sprintf('|S_%i_%i|', sId(1), sId(2)));
    xlabel(results.param{paramId}.Name);
    ylabel(sprintf('|S_%i_%i|', sId(1), sId(2)));

    figure;
    F = plot(sVal, '-*r');
    grid on;
    title('phase chart');
    xlabel(sprintf('Re(S_%i_%i)', sId(1), sId(2)));
    ylabel(sprintf('Im(S_%i_%i)', sId(1), sId(2)));

elseif myDim == 2
    % two parameter plot

    % initialize
    dimP1 = length(results.param{paramId(1)}.Vals);
    dimP2 = length(results.param{paramId(2)}.Vals);
    sVal = zeros(dimP2, dimP1);
    onlyOneParamPoint = setdiff(1 : 3, paramId);
    % get results
    switch onlyOneParamPoint
      case 1
        for p1Cnt = 1:dimP1
            for p2Cnt = 1:dimP2
    %             linId = (p2Cnt - 1) * dimP1 + p1Cnt;
    %             sVal(p1Cnt, p2Cnt) = results.sMat{linId}(sId(1), sId(2));
                sVal(p2Cnt, p1Cnt) = results.sMat{1, p1Cnt, p2Cnt}(sId(1), sId(2));
            end
        end
      case 2
        for p1Cnt = 1:dimP1
            for p2Cnt = 1:dimP2
                sVal(p2Cnt, p1Cnt) = results.sMat{p1Cnt, 1, p2Cnt}(sId(1), sId(2));
            end
        end
      case 3
        for p1Cnt = 1:dimP1
            for p2Cnt = 1:dimP2
                sVal(p2Cnt, p1Cnt) = results.sMat{p1Cnt, p2Cnt, 1}(sId(1), sId(2));
            end
        end
    end
    %plot
    figHandle = figure;
%     F = surf(real(results.param{paramId(1)}.Vals), real(results.param{paramId(2)}.Vals), 20*log10(abs(sVal)));
    F = pcolor(real(results.param{paramId(1)}.Vals), real(results.param{paramId(2)}.Vals), 20*log10(abs(sVal)));
%     contour(real(results.param{paramId(2)}.Vals), real(results.param{paramId(1)}.Vals), abs(sVal));
    xlabel(results.param{paramId(1)}.Name);
    ylabel(results.param{paramId(2)}.Name);
    zlabel(sprintf('|S_{%i %i}|', sId(1), sId(2)));

elseif myDim == 3
    % three parameter movie
    
    dimFrame = length(results.param{paramId(2)}.Vals);
    dimP2 = length(results.param{paramId(1)}.Vals);
    dimP3 = length(results.param{paramId(3)}.Vals);
    sVal = zeros(dimP3, dimP2);
	hh = figure;
  
    for frameCnt = 1 : dimFrame
        % do two parameter plots
        % get results
        for p2Cnt = 1:dimP2
            for p3Cnt = 1:dimP3
%                 linId = (frameCnt - 1) * dimP3 * dimP2 + (p2Cnt - 1) *
%                 dimP3 + p3Cnt;
%                 sVal(p2Cnt, p3Cnt) = results.sMat{linId}(sId(1), sId(2));
                sVal(p3Cnt, p2Cnt) = results.sMat{frameCnt, p3Cnt, p2Cnt}(sId(1), sId(2));
            end
        end

        %plot
        h = surf(real(results.param{paramId(1)}.Vals), real(results.param{paramId(3)}.Vals), abs(sVal));
        ylabel(results.param{paramId(3)}.Name);
        xlabel(results.param{paramId(1)}.Name);
        zlabel(sprintf('|S_{%i %i}|', sId(1), sId(2)));
        axisLimits = axis();
        axisLimits(end - 1) = 0;
        axisLimits(end) = 1;
        axis(axisLimits);
%         drawnow;
        view([0 90]);        
        F(frameCnt) = getframe(); % frame
    end
    movie(F);
    
% %     dimFrame = length(results.param{paramId(frameParamId)}.Vals);
% %     dimP2 = length(results.param{paramId(2)}.Vals);
% %     dimP3 = length(results.param{paramId(3)}.Vals);
% %     sVal = zeros(dimP2, dimP3);
% % 	figure;
% %     for frameCnt = 1 : dimFrame
% %         % do two parameter plots
% %         % get results
% %         for p2Cnt = 1:dimP2
% %             for p3Cnt = 1:dimP3
% % %                 linId = (frameCnt - 1) * dimP3 * dimP2 + (p2Cnt - 1) *
% % %                 dimP3 + p3Cnt;
% % %                 sVal(p2Cnt, p3Cnt) = results.sMat{linId}(sId(1), sId(2));
% %                 sVal(p2Cnt, p3Cnt) = results.sMat{p2Cnt, p3Cnt, frameCnt}(sId(1), sId(2));
% %             end
% %         end
% % 
% %         %plot
% %         surf(real(results.param{paramId(3)}.Vals), real(results.param{paramId(2)}.Vals), abs(sVal));
% %         xlabel(results.param{paramId(3)}.Name);
% %         ylabel(results.param{paramId(2)}.Name);
% %         zlabel(sprintf('|S_{%i %i}|', sId(1), sId(2)));
% %         axisLimits = axis();
% %         axisLimits(end - 1) = 0;
% %         axisLimits(end) = 1;
% %         axis(axisLimits);
% %         F(frameCnt) = getframe(); % frame
% %     end
% %     movie(F);
end

