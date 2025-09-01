% Script reads step of Newton and plots them

close all;
clear all;

filename = 'C:\home\Ortwin\InvProblem\Matlab\InverseProblem\mu.txt';
fid = fopen(filename,'r');
muSteps = fscanf(fid,'%g  %g', [2 inf]);
fclose(fid);

muStepsCmplx = muSteps(1,:)+j*muSteps(2,:);
plot(muStepsCmplx);
