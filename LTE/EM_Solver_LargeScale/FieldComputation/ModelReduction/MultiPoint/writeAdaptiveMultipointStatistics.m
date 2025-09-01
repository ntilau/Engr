function writeAdaptiveMultipointStatistics(Model, fid)


if fid ~= 1
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

romGenerationTime = sum(Model.Time.factSysMat) + ...
    sum(Model.Time.solveFullSystem) + sum(Model.Time.orthogonalization)+...
    sum(Model.Time.projection);

adaptEvalTime = sum(Model.Time.secEval) + sum(Model.Time.secCriterion);

fprintf(fid, 'Reduced Model Generation:\t\t%f s\n', romGenerationTime);
fprintf(fid, 'Evaluation of sections:\t\t\t%f s\n', ...
    sum(Model.Time.secEval));
fprintf(fid, 'Computation of section errors:\t%f s\n', ...
    sum(Model.Time.secCriterion));
fprintf(fid, 'Evaluation of Reduced Model:\t%f s\n', ...
    Model.Time.secEval(end));
fprintf(fid, 'ROM adaption process:\t\t\t%f s\n\n', ...
    romGenerationTime + adaptEvalTime + Model.Time.secEval(end));

fprintf(fid, '+++++++++++++++++++++++++++++++++++++++++++++++++\n');
fprintf(fid, '+++++++++++++++++++++++++++++++++++++++++++++++++\n\n');

if fid ~= 1
    fclose(fid);
end

% write all times in detail
fName = strcat(Model.resultPath, 'timeSectionEval.fvec');
writeFullVector(Model.Time.secEval, fName);

fName = strcat(Model.resultPath, 'timeSectionCrit.fvec');
writeFullVector(Model.Time.secCriterion, fName);

fName = strcat(Model.resultPath, 'timeFactorization.fvec');
writeFullVector(Model.Time.factSysMat, fName);

fName = strcat(Model.resultPath, 'timeSolveSystem.fvec');
writeFullVector(Model.Time.solveFullSystem, fName);

fName = strcat(Model.resultPath, 'timeOrthogonalization.fvec');
writeFullVector(Model.Time.orthogonalization, fName);

fName = strcat(Model.resultPath, 'timeProjection.fvec');
writeFullVector(Model.Time.projection, fName);





