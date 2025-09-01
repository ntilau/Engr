% Ermitteln der WaveSolverLaufzeiten

log_path = 'C:\ykonkel\Bosch\em_waveSolver_sXp\s16p\e\';

log_fname = 'disc_sweep_e_hf_cmplt.log';
log_fname = strcat(log_path, log_fname);

fid = fopen(log_fname, 'r');
evalCnt = 0;

while ~feof(fid)
    first_str = '';
    evalCnt = evalCnt + 1;
    portCnt = 0;
    while ~strcmp(first_str, 'done')

        line = fgetl(fid);
        if ~ischar(line)
            error('\''%s\'' is not of type char', line);
        end
        
        first_str = sscanf(line, '%s', 1);
        if strcmp(first_str, 'Solution')
            portCnt = portCnt + 1;
            continue;
        end
        
        if strcmp(first_str, 'User') && portCnt > 0
            line = line(strfind(line, ' ') + 1:end);            
            userTime{evalCnt}(portCnt) = sscanf(line, '%f', 1);
        end
    end
end

fclose(fid);

totalUserTime = 0;
for ii = 1:length(userTime)
    totalUserTime = totalUserTime + userTime{ii}(end);
end

totalUserTime
