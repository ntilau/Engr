% Skript zum Generieren einer Batch-Datei, die einen diskreten Sweep mit
% dem EM_WaveSolver durchfuehrt

clear all;
close all;

modelPath = 'C:\Users\ykonkel.LTE-W18\Simulation\Projects\LTE\TestModels\EM_WaveSolver\lte_fileset\';
project = 'TestResonator';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% definiere Frequenzbereich
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fmin = 7e9;
fmax = 30e9;

pts_per_decade = 10;
pts = 101;

% f = logspace(log10(fmin), log10(fmax), (log10(fmax) - log10(fmin)) * pts_per_decade);
f = linspace(fmin, fmax, pts);

% f = getRefModelFreqSteps('W:\Bosch\hfss_sXp\s16p\standard_hi_res', 'disc_sweep_cmplt.s16p');

file = sprintf('%scall_WaveSolver_%1.2e_%1.2e_%dpts.bat', modelPath, fmin, fmax, length(f));
fid = fopen(file, 'w');


for i = 1:length(f)
    msgStr = fprintf(fid, '\nECHO Solving Point %d of %d Points\n', ...
        i, length(f));
    cmd_str = fprintf(fid, 'EM_WaveSolver %s %f -out p>>%s\n',...    
        project, f(i), 'ausgabe_WaveSolver.txt');    
%     rename_str = sprintf('rename %s.dat %s_f%d.dat\n', project, project, f(i));
%     fwrite(fid, rename_str);
end
fclose(fid);

edit(file);


