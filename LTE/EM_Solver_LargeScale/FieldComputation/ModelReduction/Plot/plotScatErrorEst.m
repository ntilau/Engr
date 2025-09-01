function h = plotScatErrorEst(Model, Rom, Error, fontSize)

nRoms = length(Rom);
h = [];
strLegend = {};
axisCnt = 0;

for iRom = 1:nRoms
    if ~isfield(Rom{iRom}, 'ErrorEst') || isempty(Rom{iRom}.ErrorEst)
        % no ritzvalues in band of interest have converged
        continue;
    else                
        if isfield(Rom{iRom}.ErrorEst, 'iFreq')
            % estimation has been computed -> Select valid estimates
            iFreq = Rom{iRom}.ErrorEst.iFreq;  
            eEstMat = Rom{iRom}.ErrorEst.sParam(iFreq);
        else
            % ROM has been read from files
            eEstMat = Rom{iRom}.ErrorEst.sParam;
        end
        
        eEst = sortNetworkParamsByPorts(eEstMat);
                         
        % count number of plots
        axisCnt = axisCnt + 1;
        
        lineType = getLineSpecification(axisCnt); 
        strLegend{axisCnt} = sprintf('dim = %d', Rom{iRom}.dim); %#ok<AGROW>
        for k = 1:Model.nPorts    
            % set figure attributes
            if length(h) < k
                figName = sprintf(...
                    'Estimated and Actual Error of Scattering Parameter');
                h(k) = figure('Position', [200, 200, 900, 600], ...
                    'Name', figName); %#ok<AGROW>              
            else
                figure(h(k));
            end                       
            
            if ~isempty(Error)
                % plot actual error
                semilogy(Error(iRom).f, Error(iRom).S{k,k}, ...
                    lineType, 'LineWidth', 3);
                hold on;
            end
            
            % plot estimated error
            axisHandle(k, axisCnt) = semilogy(Rom{iRom}.ErrorEst.f, ...
                eEst{k,k}, lineType, 'LineWidth', 2, 'LineStyle', '--');
            hold on;                          
            
            % set axis properties
            ylabel_str = sprintf(...
                '$|\\tilde{S}_{%d%d}-S_{%d%d}|$ (Z Formulation)',...
                k, k, k, k);
            ylabel(ylabel_str, 'Interpreter', 'Latex');
            xlabel('Frequency (Hz)', 'Interpreter', 'Latex');                     
            
            % plot legend
            legend(axisHandle(k,:), strLegend, 'Interpreter', 'Latex',...
                'Location', 'SouthEast');      
            
            axis tight;            
            set(gca, 'PlotBoxAspectRatio', [3,2,1]);
            set(gca, 'FontSize', fontSize);
        end
    end
end

