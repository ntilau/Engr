
% global sys0 k2_mat  ident;

%Load Original Model Data
[parameterNamesMulti, numParameterPntsMulti, parameterValsMulti, sMatricesMulti] ...
  = loadSmatrix(fNameSparaOrig);
sValOrig = zeros(numParameterPntsMulti(1),1);
freqsMulti = zeros(numParameterPntsMulti(1),1);
for k = 1:numParameterPntsMulti(1)
  fr(k) = parameterValsMulti(1,k);
  sValOrig111(k) = sMatricesMulti{k}(1, 1);
  sValOrig112(k) = sMatricesMulti{k}(1, 2);
end


loadUnreducedModel(modelName, linFreqParamFlag)



tic

% Singlepoint Computation
% linFreqParamFlag = true;
% impedanceFlag = true;
% order = 39;


modelOrder = 37;
% expFreqSingle = linspace(freqParam.fMin, freqParam.fMax, 17);
expFreqSingle = linspace(4e9, 12e9, 401);



for oNum = 1:length(modelOrder),
    for fNum = 1:length(expFreqSingle),
        currentOrder = modelOrder(oNum)
        fExpansion = expFreqSingle(fNum)
        reduceSinglePointModel(modelName, currentOrder, linFreqParamFlag, fExpansion);
%         generateSinglePointModel(modelName, order, linFreqParamFlag, fExpansion);
        
        fNameSparaSingle = evaluateSingleModel(modelName, impedanceFlag, fExpansion);

        [parameterNamesSingle, numParameterPntsSingle, parameterValsSingle, sMatricesSingle] ...
            = loadSmatrix(fNameSparaSingle);
        sValSingle = zeros(numParameterPntsSingle(1),1);
        freqsSingle = zeros(numParameterPntsSingle(1),1);
        for k = 1:numParameterPntsSingle(1)
            freqsSingle(k) = parameterValsSingle(1,k);
            sValSingle111(k) = sMatricesSingle{k}(1, 1);
            sValSingle112(k) = sMatricesSingle{k}(1, 2);
        end

        e11 = sValOrig111 - sValSingle111;
        e12 = sValOrig112 + sValSingle112;

        eS=1;
        expFreqError1(oNum, fNum) = (sum(abs(e11).^eS + abs(e12).^eS).^(1/eS)) / length(e11) ;

        eS=2;
        expFreqError2(oNum, fNum) = (sum(abs(e11).^eS + abs(e12).^eS).^(1/eS)) / length(e11) ;
        
        expFreqErrorMax(oNum, fNum) = max( max(abs(e11)), max(abs(e12)) ) ;
    end
    toc
    save(['order' num2str(currentOrder)], 'expFreqError1', 'expFreqError2', 'expFreqErrorMax');
end

myFigure = figure(1);
set(gca, 'FontSize',18);
semilogy(expFreqSingle*1e-9, expFreqError1(1,:), '-', 'LineWidth', 3);
hold on;
semilogy(expFreqSingle*1e-9, expFreqError2(1,:),'--', 'LineWidth', 3);
semilogy(expFreqSingle*1e-9, expFreqErrorMax(1,:),'.', 'LineWidth', 3);
hold off;
ylabel('L_p({f_{1},f_{N}})');
xlabel('SPM expansion frequency (GHz)');
grid on;
legend('L_1','L_2','L_\infty');


figure(2);
set(gca, 'FontSize',18);
text('Interpreter','tex');
surf(expFreqSingle*1e-9, (modelOrder+1)*2, log10((expFreqError2)));
ylabel('ROM dimension q ');
xlabel('Expansion frequency f_{E}');
zlabel('(L_{2}(4GHz, 12GHz)');
axis([9 11 78 102  ])
az = 225;
el = 20;
view(az, el);
set(gca,'YTick',78:4:102);
% set(gca, 'LineStyle','none');
% colorbar('location','south','FontSize', 18, 'title','Fehler',...
%     'XTick',[-8 -6 -4 -3],'XTickLabel',{'1e-8', '1e-6','1e-4','1e-3'});
colormap('gray');
% set(gca,'XDir','rev','YDir','rev')

figure(3);
set(gca, 'FontSize',18);
surf(expFreqSingle*1e-9, (modelOrder+1)*2, log10((expFreqErrorMax)));
ylabel('Model order');
xlabel('Expansion frequency f_{E}');
zlabel('(L_{\infty}(4GHz, 12GHz)');
axis([9 11 78 102  ])
az = 225;
el = 20;
view(az, el);
set(gca,'YTick',78:4:102);
colormap('gray');

