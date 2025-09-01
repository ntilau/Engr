% write calculation time or MOR simulations to file
function writeLogFile(modelName, method, generationTime, evaluationTime, evaluationFrequencies, order)

logfileName = sprintf('mor_%spoint_logfile.txt', method);
fname = strcat(modelName, logfileName);
fid = fopen(fname, 'a+');

fprintf(fid, '\n---------------------------------------\n');
fprintf(fid, 'Date: %s\n', datestr(now));
fprintf(fid, 'Model Generation Time: %f\n', generationTime);
fprintf(fid, 'Model Evaluation Time: %f\n', evaluationTime);    
fprintf(fid, 'FreqMin: %d\tFreqMax: %d\n', evaluationFrequencies(1), evaluationFrequencies(end));
if strcmp(method, 'multi')
    fprintf(fid, 'Number of Evaluation Points: %d\nNumber of Expansion Points: %d', length(evaluationFrequencies), order);
elseif strcmp(method, 'single')
    fprintf(fid, 'Number of Evaluation Points: %d\nOrder: %d', length(evaluationFrequencies), order);
end
fprintf(fid, '\n---------------------------------------\n');

fclose(fid);