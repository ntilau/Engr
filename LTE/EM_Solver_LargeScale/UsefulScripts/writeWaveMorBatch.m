% Skript zum Generieren einer Batch-Datei, die einen diskreten Sweep mit
% dem EM_WaveSolver durchfuehrt

clear;
close all;
clc;

modelPath = 'C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\TestModels\EM_WaveSolver\lte_fileset\';
project = 'TestResonator';

% variiere fexp um versch. Konstellationen zu testen. Sonst variiere
% maxIter
shouldVaryFExp = false;
maxIter = 3;

% Frequenzbereich
fmin = 7e9;
fmax = 30e9;

nPts = 101;
f = linspace(fmin, fmax, nPts);

thresholdVal = 1e-7;

blockSize = 1;

% optionen
opt{1} = '+impedance -mp -block';
opt{2} = '+impedance -mp +block 0 +ooc';
opt{3} = '+impedance -mp +block 0 -ooc';
opt{4} = '+impedance +mp';
opt{5} = '-impedance -mp -block';
opt{6} = '-impedance -mp +block 0 +ooc';
opt{7} = '-impedance -mp +block 0 -ooc';
opt{8} = '-impedance +mp';

for k = 1:length(blockSize)
    iOpt = length(opt) + 1;
    opt{iOpt} = sprintf('-impedance -mp +block %d', blockSize(k)); %#ok<AGROW>
end

optStart = 70;
nOptions = length(opt);

if ~shouldVaryFExp
    fexp(1:nOptions) = f((nPts - 1) / 2 + 1);
else
    iMid = (nPts - 1) / 2 + 1;
    fexp = f((iMid - ceil(nOptions / 2) + 1):(iMid + floor(nOptions / 2)));
end    

file = sprintf('runWaveMor_BlockTest_thd_%1.1e.bat', thresholdVal);
fid = fopen(strcat(modelPath, file), 'w');
for k = 1:nOptions
    if ~shouldVaryFExp        
        % use 'maxOrder'-parameter as option-id
        maxIter = optStart + k;
    end        
    fprintf(fid, ['\nEM_WaveModelReduction %s %e %e %e %d %d %s ',...
        '-out t_v1 +thresholdValue %e\n'], project, fexp(k), fmin, fmax,...
        nPts, maxIter, opt{k}, thresholdVal);        
end
fclose(fid);

fprintf(1, '\nFile ''%s'' has been written to ''%s''\n', file, modelPath);


