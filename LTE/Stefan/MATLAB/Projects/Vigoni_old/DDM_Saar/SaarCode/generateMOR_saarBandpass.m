%% main
clear;
close all;
% clc;
addpath(genpath('C:\home\Ortwin\MATLAB\Projects\Vigoni\'));
set(0,'DefaultFigureWindowStyle','docked');

% set constants
global c0 mu0 eps0 Z0
c0   = 0.2998e9;   %[m/s]
mu0  = pi*4e-7;    %[A/s]
eps0 = 1 / (mu0 * c0^2);
Z0  =   c0*mu0;     %[ohm]

ROOTPATH = 'C:\home\Ortwin\DDM_Saar\';

useFulFunctionsPath = 'C:\work\Matlab\usefulFunctions';
addpath(genpath(useFulFunctionsPath));

% empty waveguide
% mesh.fine   = [ROOTPATH 'GEO/empty_very_fine.fem'];
% mesh.fine   = [ROOTPATH 'GEO/emptyWG_finermesh.fem'];
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
% mesh.fine   = [ROOTPATH 'GEO/layerShort2_fff.fem'];
% empty waveguide with two dielectric posts
% mesh.fine   = [ROOTPATH 'GEO/TwoPosts_finemesh.fem'];
% mesh.fine   = [ROOTPATH 'GEO/TwoPosts_finestmesh.fem'];
% empty waveguide with four dielectric posts
% mesh.fine   = [ROOTPATH 'GEO/FourPosts_finemesh.fem'];
% mesh.fine   = [ROOTPATH 'GEO/FourPosts_finermesh.fem'];
% mesh.fine   = [ROOTPATH 'GEO/FourPosts_ff_mesh.fem'];
% bandpass
mesh.fine   = [ROOTPATH 'GEO/bandpass_finemesh.fem'];
mesh.fine   = [ROOTPATH 'GEO/hole_finemesh.fem'];
mesh.fine   = [ROOTPATH 'GEO/pecPost_finemesh.fem'];
mesh.fine   = [ROOTPATH 'GEO/pecPostInv_finemesh.fem'];
% mesh.fine   = [ROOTPATH 'GEO/wg_coarsemesh.fem'];

% empty waveguide and waveguide with layer
% mesh.dd     = [ROOTPATH 'GEO/empty_dd.fem'];
% mesh.dd     = [ROOTPATH 'GEO/emptyWG_coarsemesh.fem'];
% dpostWR90
% mesh.dd     = [ROOTPATH 'GEO/dpostWR90_cmeshS.fem'];
% dpostWR90 with ports more far away
% mesh.dd     = [ROOTPATH 'GEO/dpostWR90_cmeshDoms.fem'];
% iris
% mesh.dd     = [ROOTPATH 'GEO/iris_dd.fem'];
% waveguide with post
% mesh.dd     = [ROOTPATH 'GEO/postWGdd.fem'];
% short waveguide with layer
% mesh.dd   = [ROOTPATH 'GEO/layerShortdd.fem'];
% % empty waveguide with two dielectric posts
% mesh.dd   = [ROOTPATH 'GEO/TwoPosts_coarsemesh.fem'];
% empty waveguide with four dielectric posts
% mesh.dd   = [ROOTPATH 'GEO/FourPosts_coarsemesh.fem'];
% empty waveguide with two dielectric slabs
% mesh.dd   = [ROOTPATH 'GEO/TwoSlab_dd.fem'];
% bandpass
mesh.dd   = [ROOTPATH 'GEO/bandpass_coarsemesh.fem'];
mesh.dd   = [ROOTPATH 'GEO/hole_coarsemesh.fem'];
mesh.dd   = [ROOTPATH 'GEO/pecPost_coarsemesh.fem'];
mesh.dd   = [ROOTPATH 'GEO/pecPostInv_coarsemesh.fem'];
% mesh.dd   = [ROOTPATH 'GEO/wg_coarsemesh.fem'];

mesh.out    = [ROOTPATH 'GEO/empty.out'];
mesh.Np     = 2;
mesh.a      = [0.2, 0.2];%[18.35,  18.35];%[22.86 22.86];%[18.35,  18.35];%%[18.35,  18.35];
mesh.b      = [0.1, 0.1];%[9.55,   9.56];
mesh.plab   = [11, 12];
mesh.PEClab = 1;
mesh.PMClab = 0;
mesh.nmode  = 1;
mesh.plane  = 'H';
mesh.ndie   = 1;%2;
mesh.Eps    = [1.0];
mesh.Mu     = [1.0];
% mesh.mlab   = 1:9;
mesh.mlab   = 1;

interpolationPnts.frequency.start = 1e9;  %1e7;% in GHz
interpolationPnts.frequency.stop  = 1.2e9; %1.2e7;% in GHz
interpolationPnts.frequency.N     = 10;

% interpolationPnts.epsilon{1}.materials = 1;
% interpolationPnts.epsilon{1}.start(1)  = 1;%4
% interpolationPnts.epsilon{1}.stop(1)   = 26;%6;
% interpolationPnts.epsilon{1}.N(1)      = 5;%11;
% interpolationPnts.epsilon{1}.mlabel(1) = 2;
% interpolationPnts.epsilon{1}.domain    = -1;
% 
% interpolationPnts.epsilon{2}.materials = 1;
% interpolationPnts.epsilon{2}.start(1)  = 1;%4
% interpolationPnts.epsilon{2}.stop(1)   = 26;%6;
% interpolationPnts.epsilon{2}.N(1)      = 5;%11;
% interpolationPnts.epsilon{2}.mlabel(1) = 3;
% interpolationPnts.epsilon{2}.domain    = -1;

flagout = 1;

[unredModel, solVecs, results, sweep, nmode, xy, PO, Np, MESH] = ehdevDDforMOR_saarBandpass(mesh, interpolationPnts, flagout);


% plot S parameters
results.param{1}.Name = 'frequency';
results.param{1}.Vals = sweep.frequency.freq;
% results.param{2}.Name = 'epsilon relative 1';
% results.param{2}.Vals = sweep.epsilon{1}.epsRel;
% results.param{3}.Name = 'epsilon relative 2';
% results.param{3}.Vals = sweep.epsilon{2}.epsRel;


% results.param{1}.Name = 'epsilon relative 1';
% results.param{1}.Vals = sweep.epsilon{1}.epsRel;
% results.param{2}.Name = 'epsilon relative 2';
% results.param{2}.Vals = sweep.epsilon{2}.epsRel;

sId = [1 1];
F = plotResults(results, sId, 1);


%% build ROM
t1 = cputime;
tic;
ROM = buildROM_MultipleEpsilon(unredModel, solVecs);
toc;
t2 = cputime;
totalTimeBuildROM = t2 - t1;
display(totalTimeBuildROM);

% load(strcat(ROOTPATH, 'results\data'));


%% solve ROM
sweep.frequency.start = 7e9;
sweep.frequency.stop  = 13e9;
sweep.frequency.N     = 1;

sweep.epsilon{1}.materials = 1;
sweep.epsilon{1}.start(1)  = 4;%4
sweep.epsilon{1}.stop(1)   = 26;%6;
sweep.epsilon{1}.N(1)      = 101;%11;
sweep.epsilon{1}.mlabel(1) = 2;
sweep.epsilon{1}.domain    = -1;

sweep.epsilon{2}.materials = 1;
sweep.epsilon{2}.start(1)  = 4;%4
sweep.epsilon{2}.stop(1)   = 26;%6;
sweep.epsilon{2}.N(1)      = 1;%11;
sweep.epsilon{2}.mlabel(1) = 3;
sweep.epsilon{2}.domain    = -1;

nfreq = sweep.frequency.N;                                %numero di punti in frequenza da calcolare
sweep.frequency.freq = [sweep.frequency.start];    %estremi delle frequenze
if nfreq > 1
    sweep.frequency.freq = [sweep.frequency.start:(sweep.frequency.stop-sweep.frequency.start)/(nfreq-1):sweep.frequency.stop]; 
end  

for epsCnt = 1 : length(sweep.epsilon)
  sweep.epsilon{epsCnt}.epsRel = sweep.epsilon{epsCnt}.start;
  if sweep.epsilon{epsCnt}.N > 1
    sweep.epsilon{epsCnt}.epsRel = [sweep.epsilon{epsCnt}.start : (sweep.epsilon{epsCnt}.stop - ...
      sweep.epsilon{epsCnt}.start)./(sweep.epsilon{epsCnt}.N-1) : sweep.epsilon{epsCnt}.stop];
    % add some losses
    sweep.epsilon{epsCnt}.epsRel = sweep.epsilon{epsCnt}.epsRel - j * 0.01;
  end
end

% sweep.epsilon.epsRel = [sweep.epsilon.start];
% if sweep.epsilon.N > 1
%     sweep.epsilon.epsRel = [sweep.epsilon.start : (sweep.epsilon.stop - sweep.epsilon.start)./(sweep.epsilon.N-1) : sweep.epsilon.stop];
% end
% sweep.epsilon.epsRel = sweep.epsilon.epsRel - 0.01 * j;

tic;
% t1 = cputime;
results = solveModelMultipleEpsilon(ROM, sweep, nmode, xy, PO, Np, mesh.Mu);
% t2 = cputime;
% totalTimeEvaluateROM = t2 - t1;
% display(totalTimeEvaluateROM);
toc;

% field visualization
% solUncompressed = unredModel.tfMat * (ROM.U * results.sol);
% fieldSolution = j*solUncompressed(:, 1);
% % figure;
% % scatter(xy(1, :), xy(2, :), 5, real(fieldSolution.'));
% % % endPhase = 1 ;
% % % for phaseCnt = 1:endPhase
% % %   fieldSolution = fieldSolution * exp(j * 2 * pi / endPhase) ;
% % %   scatter(xy(1, :), xy(2, :), 5, real(fieldSolution.'));
% % %   caxis([-10 10]);
% % %   FF(phaseCnt) = getframe ;
% % % end
% % % movie(FF, 3) ;
% % % writecres('fieldMap.out', fieldSolution, length(fieldSolution), 1, 'R');
% 
% solVec = real(fieldSolution) ;
% [f1AxesHandle, f2AxesHandle] = plotSolution(xy, solVec, MESH);

% cmap = colormap;
% % mav = max (abs(fieldSolution));
% % miv = min (abs(fieldSolution));
% mav = max(real(fieldSolution));
% miv = min(real(fieldSolution));
% 
% for i = 1:length(fieldSolution)
% %     rcolor(i,:) = cmap(ceil(64*(abs(fieldSolution(i))-miv+1)/(mav-miv+1)),:);
%     rcolor(i,:) = cmap(ceil(64*(real(fieldSolution(i))-miv+1)/(mav-miv+1)),:);
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
%     %caxis(caxis) freeze ;
% %     caxis([miv mav]);
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
results.param{1}.Name = 'frequency';
results.param{1}.Vals = sweep.frequency.freq;
results.param{2}.Name = 'epsilon relative 1';
results.param{2}.Vals = sweep.epsilon{1}.epsRel;
results.param{3}.Name = 'epsilon relative 2';
results.param{3}.Vals = sweep.epsilon{2}.epsRel;

% results.param{1}.Name = 'epsilon relative 1';
% results.param{1}.Vals = sweep.epsilon{1}.epsRel;
% results.param{2}.Name = 'epsilon relative 2';
% results.param{2}.Vals = sweep.epsilon{2}.epsRel;

% results.param{1}.Name = 'frequency';
% results.param{1}.Vals = sweep.frequency.freq;
% results.param{2}.Name = 'epsilon relative';
% results.param{2}.Vals = sweep.epsilon{1}.epsRel;

% results.param{1}.Name = 'frequency';
% results.param{1}.Vals = sweep.frequency.freq;

% results.param{1}.Name = 'epsilon relative 1';
% results.param{1}.Vals = sweep.epsilon{1}.epsRel;

sId = [1 1];
% F = plotResults2(results, sId, 1); % plot results for eps1=eps2.
F = plotResults(results, sId, 1);

% % figure;
% % surf(sweep.epsilon.epsRel, freq / 1e9, abs(stmpROM));
% % xlabel('epsilon relative');
% % ylabel('frequency (GHz)');
% % zlabel('|S11|');


%% solve unredModel

tic;
resultsUnred = solveModelMultipleEpsilon(unredModel, sweep, nmode, xy, PO, Np, mesh.Mu);
toc;

% plot S parameters
resultsUnred.param{1}.Name = 'frequency';
resultsUnred.param{1}.Vals = sweep.frequency.freq;
resultsUnred.param{2}.Name = 'epsilon relative 1';
resultsUnred.param{2}.Vals = sweep.epsilon{1}.epsRel;
resultsUnred.param{3}.Name = 'epsilon relative 2';
resultsUnred.param{3}.Vals = sweep.epsilon{2}.epsRel;

% results.param{1}.Name = 'epsilon relative 1';
% results.param{1}.Vals = sweep.epsilon{1}.epsRel;
% results.param{2}.Name = 'epsilon relative 2';
% results.param{2}.Vals = sweep.epsilon{2}.epsRel;

sId = [1 1];
plotResults(results, sId, 0);


%% compare ROM with unreduced model

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

dimP1 = length(results.param{paramId}.Vals);
sValUnred = zeros(dimP1, 1);
% get results
for p1Cnt = 1:dimP1
  sValUnred(p1Cnt) = resultsUnred.sMat{p1Cnt}(sId(1), sId(2));
end
% plot
figure;
plot(results.param{paramId}.Vals, abs(sValUnred), '-*');
grid on;
title(sprintf('|S_%i_%i|', sId(1), sId(2)));
xlabel(results.param{paramId}.Name);
ylabel(sprintf('|S_%i_%i|', sId(1), sId(2)));

figure;
semilogy(results.param{paramId}.Vals, abs(sVal - sValUnred));


%% save results of error plot
% freq_4_4 = results.param{paramId}.Vals;
% sValRom_4_4 = sVal;
% sValUnred_4_4 = sValUnred;
% save(strcat(ROOTPATH, 'results\fourPosts_4_4'), 'freq_4_4', 'sValRom_4_4', 'sValUnred_4_4');


%% error plot
linewidth = 2.0;
fontsize = 16;
load(strcat(ROOTPATH, 'results\fourPosts_4_4')); 
load(strcat(ROOTPATH, 'results\fourPosts_4_23')); 
load(strcat(ROOTPATH, 'results\fourPosts_23_4')); 
load(strcat(ROOTPATH, 'results\fourPosts_23_23')); 
figHandle = figure;
semilogy(freq_4_4 * 1e-9, abs(sValRom_4_4 - sValUnred_4_4), 'k', 'LineWidth', linewidth);
hold;
semilogy(freq_4_23 * 1e-9, abs(sValRom_4_23 - sValUnred_4_23), 'k:', 'LineWidth', linewidth);
semilogy(freq_23_4 * 1e-9, abs(sValRom_23_4 - sValUnred_23_4), 'k-.', 'LineWidth', linewidth);
semilogy(freq_23_23 * 1e-9, abs(sValRom_23_23 - sValUnred_23_23), 'k--', 'LineWidth', linewidth);
xlabel('Frequency (GHz)', 'FontSize', fontsize);
ylabel('|Error S_{11}|', 'FontSize', fontsize);
legend('\epsilon_{r1} = 4-0.01j, \epsilon_{r2} = 4-0.01j', ...
  '\epsilon_{r1} = 4-0.01j, \epsilon_{r2} = 23-0.01j', ...
  '\epsilon_{r1} = 23-0.01j, \epsilon_{r2} = 4-0.01j', ...
  '\epsilon_{r1} = 23-0.01j, \epsilon_{r2} = 23-0.01j', 'Location', 'SouthEast');
set(gca,'FontSize', fontsize);



