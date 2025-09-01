function writeProvableMorStatistics(Model, Time, fid)

if nargin < 3 || fid ~= 1
    % write to file
    fid = fopen(strcat(Model.resultPath, 'cpuTimeStats.txt'), 'a');
end

[status, nProcessors] = system('echo %NUMBER_OF_PROCESSORS%');

fprintf(fid, '\n\n+++++++++++++++++++++++++++++++++++++++++++++++++\n');
fprintf(fid, '+++++++++++++++++++++++++++++++++++++++++++++++++\n');
fprintf(fid, '\n-------------------------------------------------\n');
fprintf(fid, '----         Simulation statistics          -----\n');
fprintf(fid, 'Date:\t\t\t\t\t%s\n', datestr(now));
fprintf(fid, 'Number of Processors:\t%d\n', str2double(nProcessors)); 
fprintf(fid, 'Degrees of freedom:\t\t%d\n', Model.dof);
fprintf(fid, 'Number of Excitations:\t%d\n', Model.nPorts);
fprintf(fid, 'Number of Iterations:\t%d\n', Model.iRomConverged);
fprintf(fid, '-------------------------------------------------\n\n');

romGenerationTime = Time.factSysMat + sum(Time.arnoldi) +...
    sum(Time.projection);

errorEstTotal = Time.factorA1 + sum(Time.residual) + sum(Time.eigBound)+...
    sum(Time.errorEst) + sum(Time.errorNorm) + sum(Time.solveRomEp);

errorEstLast = Time.factorA1 + Time.residual(end) + Time.eigBound(end)+...
    Time.errorEst(end) + Time.errorNorm(end) + Time.solveRomEp(end);


fprintf(fid, 'Reduced Model Generation:\t\t\t%f s\n', romGenerationTime);
fprintf(fid, 'Error estimation total:\t\t\t\t%f s\n', errorEstTotal);
fprintf(fid, 'Error estimation last:\t\t\t\t%f s\n', errorEstLast);
fprintf(fid, 'Evaluation of Last Reduced Model:\t%f s\n', ...
    Time.solveRom(end));

fprintf(fid, '+++++++++++++++++++++++++++++++++++++++++++++++++\n');
fprintf(fid, '+++++++++++++++++++++++++++++++++++++++++++++++++\n\n');

if fid ~= 1
    fclose(fid);
end

timeField = fieldnames(Time);
for k = 1:length(timeField)
    fName = strcat(Model.resultPath, 'time_', timeField{k}, '.fvec');
    writeFullVector(Time.(timeField{k}), fName);
end