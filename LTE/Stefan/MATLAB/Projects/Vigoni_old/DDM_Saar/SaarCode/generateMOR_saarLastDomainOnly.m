%% main
clear;
close all;
% clc;

set(0,'DefaultFigureWindowStyle','docked');

% set constants
global c0 mu0 eps0 Z0
c0   = 0.2998e9;   %[m/s]
mu0  = pi*4e-7;    %[A/s]
eps0 = 1 / (mu0 * c0^2);
Z0  =   c0*mu0;     %[ohm]

ROOTPATH = 'C:\work\MATLAB\Vigoni\DDM_Saar\';

% empty waveguide
% mesh.fine   = [ROOTPATH 'GEO/empty_very_fine.fem'];
% dpostWR90 coarse mesh
% mesh.fine   = [ROOTPATJ 'GEO/dpostWR90_cmeshS.fem'];
% dpostWR90
% mesh.fine   = [ROOTPATH 'GEO/dpostWR90_finemesh_old.fem'];
% dpostWR90 with ports more far away and very fine mesh 
% mesh.fine   = [ROOTPATH 'GEO/dpostWR90_finemesh.fem'];
% iris with fine mesh
% mesh.fine   = [ROOTPATH 'GEO/iris_fine.fem'];
% waveguide with post
% mesh.fine   = [ROOTPATH 'GEO/postWG.fem'];
% waveguide with block
% mesh.fine   = [ROOTPATH 'GEO/blockWG.fem'];
% waveguide with layer
% mesh.fine   = [ROOTPATH 'GEO/layer.fem'];
% short waveguide with layer
mesh.fine   = [ROOTPATH 'GEO/layerShort2_fff.fem'];


% empty waveguide and waveguide with layer
%mesh.dd     = [ROOTPATH 'GEO/empty_dd.fem'];
% dpostWR90
% mesh.dd     = [ROOTPATH 'GEO/dpostWR90_cmeshS.fem'];
% dpostWR90 with ports more far away
% mesh.dd     = [ROOTPATH 'GEO/dpostWR90_cmeshDoms.fem'];
% iris
% mesh.dd     = [ROOTPATH 'GEO/iris_dd.fem'];
% waveguide with post
% mesh.dd     = [ROOTPATH 'GEO/postWGdd.fem'];
% short waveguide with layer
mesh.dd   = [ROOTPATH 'GEO/layerShortdd.fem'];

mesh.out    = [ROOTPATH 'GEO/empty.out'];
mesh.Np     = 2;
mesh.a      = [22.86 22.86];%;%[18.35,  18.35];%%[18.35,  18.35];
mesh.b      = [10.16 10.16];%[9.55,   9.56];
mesh.plab   = [11, 12];
mesh.PEClab = 1;
mesh.PMClab = 0;
mesh.nmode  = 1;
mesh.plane  = 'H';
mesh.ndie   = 2;%2;
mesh.Eps    = [1.0];
mesh.Mu     = [3.0];
mesh.mlab   = [1, 2];

interpolationPnts.frequency.start = 11;
interpolationPnts.frequency.stop  = 12;
interpolationPnts.frequency.N     = 1;

interpolationPnts.epsilon.materials = 1;
interpolationPnts.epsilon.start(1)  = 1;%4
interpolationPnts.epsilon.stop(1)   = 9;%6;
interpolationPnts.epsilon.N(1)      = 9;%11;
interpolationPnts.epsilon.mlabel(1) = 2;
interpolationPnts.epsilon.domain    = -1;

interpolationPnts.mu.materials      = 1;
interpolationPnts.mu.start(1)       = 1;
interpolationPnts.mu.stop(1)        = 9;
interpolationPnts.mu.N(1)           = 9;
interpolationPnts.mu.mlabel(1)      = 2;
interpolationPnts.mu.domain         = -1;

flagout = 1;

[unredModel, solVecs, results, sweep, nmode, xy, PO, Np, MESH] = ehdevDDforMOR_saarLastDomainOnly(mesh, ...
  interpolationPnts, flagout);

% save results unredModel solVecs results sweep nmode xy PO Np;
% load results;

% plot S parameters
% results.param{1}.Name = 'frequency';
% results.param{1}.Vals = sweep.frequency.freq;
% results.param{2}.Name = 'epsilon relative';
% results.param{2}.Vals = sweep.epsilon.epsRel;
% results.param{3}.Name = 'mu relative';
% results.param{3}.Vals = 1 ./ sweep.nu.nuRel;
results.param{1}.Name = 'epsilon relative';
results.param{1}.Vals = sweep.epsilon.epsRel;
results.param{2}.Name = 'mu relative';
results.param{2}.Vals = 1 ./ sweep.nu.nuRel;

sId = [1 1];
F = plotResults(results, sId, 1);

% load intermediateResults;
% build ROM
t1 = cputime;
ROM = buildROMlastDomOnly(unredModel, solVecs);
t2 = cputime;
totalTimeBuildROM = t2 - t1;
display(totalTimeBuildROM);


%% solve ROM
sweep.frequency.start = 11e9;
sweep.frequency.stop  = 12e9;
sweep.frequency.N     = 1;

sweep.epsilon.materials = 1;
sweep.epsilon.start(1)  = 1.5;%4
sweep.epsilon.stop(1)   = 9;%6;
sweep.epsilon.N(1)      = 101;%11;
sweep.epsilon.mlabel(1) = 2;
sweep.epsilon.domain    = -1;

sweep.mu.materials = 1;
sweep.mu.start(1)  = 1;%4
sweep.mu.stop(1)   = 9;%6;
sweep.mu.N(1)      = 101;%11;
sweep.mu.mlabel(1) = 2;
sweep.mu.domain    = -1;

nfreq = sweep.frequency.N;                                %numero di punti in frequenza da calcolare
sweep.frequency.freq = [sweep.frequency.start];    %estremi delle frequenze
if nfreq > 1
    sweep.frequency.freq = [sweep.frequency.start:(sweep.frequency.stop-sweep.frequency.start)/(nfreq-1):sweep.frequency.stop]; 
end  

sweep.epsilon.epsRel = [sweep.epsilon.start];
if sweep.epsilon.N > 1
    sweep.epsilon.epsRel = [sweep.epsilon.start : (sweep.epsilon.stop - sweep.epsilon.start)./(sweep.epsilon.N-1) : sweep.epsilon.stop];
end
sweep.epsilon.epsRel = sweep.epsilon.epsRel - 0.01 * j;

sweep.mu.muRel = sweep.mu.start;
if sweep.mu.N > 1
    sweep.mu.muRel = [sweep.mu.start : (sweep.mu.stop - sweep.mu.start)./(sweep.mu.N-1) : sweep.mu.stop];
end

t1 = cputime;
results = solveModelLastDomOnly(ROM, sweep, nmode, xy, PO, Np);
t2 = cputime;
totalTimeROM = t2 - t1;
display(totalTimeROM);

% % field visualization
% solUncompressed = unredModel.tfMat * (ROM.U * results.sol);
% figure;
% fieldSolution = j*solUncompressed(:, 1);
% scatter(xy(1, :), xy(2, :), 5, real(fieldSolution.'));
% % writecres('fieldMap.out', fieldSolution, length(fieldSolution), 1, 'R');
% 
% 
% cmap = colormap;
% mav = max (abs(fieldSolution));
% miv = min (abs(fieldSolution));
% 
% for i = 1:length(fieldSolution)
%     rcolor(i,:) = cmap(ceil(64*(abs(fieldSolution(i))-miv+1)/(mav-miv+1)),:);
% end
% 
% figure;
% 
% for domCnt = 1:length(MESH)
%   for eleCnt = 1:size(MESH{domCnt}.ele, 2)
%     cd(1,1,:) = rcolor(MESH{domCnt}.ele(2,eleCnt),:);
%     cd(1,2,:) = rcolor(MESH{domCnt}.ele(3,eleCnt),:);
%     cd(1,3,:) = rcolor(MESH{domCnt}.ele(4,eleCnt),:);
%     patch('XData',[xy(1,MESH{domCnt}.ele(2,eleCnt)), xy(1,MESH{domCnt}.ele(3,eleCnt)), xy(1,MESH{domCnt}.ele(4,eleCnt))]',...
%         'YData',[xy(2,MESH{domCnt}.ele(2,eleCnt)), xy(2,MESH{domCnt}.ele(3,eleCnt)), xy(2,MESH{domCnt}.ele(4,eleCnt))]',...
%         'CData',cd,'FaceColor','interp','EdgeColor','interp');
%   end
% end


% % 
% % % plot s11 parameters
% % nfreq = sweep.frequency.N;
% % freq = sweep.frequency.freq;
% % figure;
% % for freqCnt = 1:nfreq
% %     for epsCnt = 1:sweep.epsilon.N
% %         stmpROM(freqCnt, epsCnt) = results.sMat{freqCnt, epsCnt}(1,1);
% %     end
% %     plot(sweep.epsilon.epsRel, abs(stmpROM(freqCnt, :)));
% %     xlabel('epsilon relative');
% %     ylabel('|S11|');
% %     hold all;
% % end

% plot S parameters
% results.param{1}.Name = 'frequency';
% results.param{1}.Vals = sweep.frequency.freq;
% results.param{2}.Name = 'epsilon relative';
% results.param{2}.Vals = sweep.epsilon.epsRel;
% results.param{3}.Name = 'mu relative';
% results.param{3}.Vals = sweep.mu.muRel;
% results.param{1}.Name = 'epsilon relative';
% results.param{1}.Vals = sweep.epsilon.epsRel;
% results.param{2}.Name = 'mu relative';
% results.param{2}.Vals = sweep.mu.muRel;
results.param{1}.Name = 'mu relative';
results.param{1}.Vals = sweep.mu.muRel;
sId = [1 1];
F = plotResults(results, sId, 1);

% % figure;
% % surf(sweep.epsilon.epsRel, freq / 1e9, abs(stmpROM));
% % xlabel('epsilon relative');
% % ylabel('frequency (GHz)');
% % zlabel('|S11|');


% %% solve unredModel
% t1 = cputime;
% resultsUnred = solveModelLastDomOnly(unredModel, sweep, nmode, xy, PO, Np);
% t2 = cputime;
% totalTime = t2 - t1;
% display(totalTime);
% 
% % plot S parameters
% % results.param{1}.Name = 'frequency';
% % results.param{1}.Vals = sweep.frequency.freq;
% % resultsUnred.param{1}.Name = 'epsilon relative';
% % resultsUnred.param{1}.Vals = sweep.epsilon.epsRel;
% % resultsUnred.param{2}.Name = 'mu relative';
% % resultsUnred.param{2}.Vals = sweep.mu.muRel;
% resultsUnred.param{1}.Name = 'mu relative';
% resultsUnred.param{1}.Vals = sweep.mu.muRel;
% sId = [1 1];
% plotResults(resultsUnred, sId, 0);
% 
% 
% %% plot error
% 
% for ii = 1:size(results1_5.sMat, 2)
%   sValUnred1_5(ii) = resultsUnred1_5.sMat{1, ii}(1, 1);
%   sVal1_5(ii) = results1_5.sMat{1, ii}(1, 1);
%   sValUnred5_5(ii) = resultsUnred5_5.sMat{1, ii}(1, 1);
%   sVal5_5(ii) = results5_5.sMat{1, ii}(1, 1);
%   sValUnred8_5(ii) = resultsUnred8_5.sMat{1, ii}(1, 1);
%   sVal8_5(ii) = results8_5.sMat{1, ii}(1, 1);
% 
% end
% 
% figure;
% semilogy(results1_5.param{1}.Vals, abs(sVal1_5 - sValUnred1_5), 'LineWidth', 2);
% hold on;
% semilogy(results1_5.param{1}.Vals, abs(sVal5_5 - sValUnred5_5), '-.', 'LineWidth', 2);
% semilogy(results1_5.param{1}.Vals, abs(sVal8_5 - sValUnred8_5), '--', 'LineWidth', 2);
% grid on;
% xlabel('\mu_r');
% ylabel('|Error S_1_1|');
% legend('\epsilon_r=1.5', '\epsilon_r=5.5', '\epsilon_r=8.5', 'Location', 'NorthWest');
% 
% print -dmeta errorPlot






