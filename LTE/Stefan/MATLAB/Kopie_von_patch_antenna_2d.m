close all;
clear all;

fNameSpara = 'Y:\Ortwin\patch_antenna\patch_antenna_6e+009_e1_4_e2_3_8\s_11_f_3e+009_9e+009_101_e1_5_5_1_e2_1_1_1.txt';
figHandle = figure;
[mus, freqs, s] = readSparamMORs11(fNameSpara);
abs_s = abs(s);
plot(freqs*1e-9, abs_s);
%surf(freqs*1e-9, mus, abs_s);
%semilogy(freqs*1e-9, abs_s);
hold;
grid;

fNameSpara = 'Y:\Ortwin\patch_antenna\patch_antenna_6e+009_e1_4_e2_2_8\s_11_f_3e+009_9e+009_101_e1_5_5_1_e2_1_1_1.txt';
[mus, freqs, s] = readSparamMORs11(fNameSpara);
abs_s = abs(s);
plot(freqs*1e-9, abs_s, 'k');
%surf(freqs*1e-9, mus, abs_s);
%semilogy(freqs*1e-9, abs_s);

fNameSpara = 'Y:\Ortwin\patch_antenna\patch_antenna_6.15e+009_(2.58,0)_5_eps2\s_11_f_3e+009_9e+009_101_e1_5_5_1_e2_1_1_1.txt';
[mus, freqs, s] = readSparamMORs11(fNameSpara);
abs_s = abs(s);
plot(freqs*1e-9, abs_s, 'g');

fNameWsolver = 'Y:\Ortwin\patch_antenna_wSolver\sParam_e1_1_e2_1.txt';
fNameWsolver = 'Y:\Ortwin\patch_antenna_wSolver\sParam_e1_5_e2_1.txt';
[fr sMatrices] = readSparamWaveSolver(fNameWsolver);
s11vector = reshape(sMatrices(1,1,:), [length(fr) 1]);
%semilogy(fr*1e-9, abs(s11vector),'dr');
plot(fr*1e-9, abs(s11vector),'dr');

