% reads matrix parametrization from matrixParametrization.txt
function writeMatrixParametrization(Model, SysMat)

fname = strcat(Model.resultPath, 'matrixParametrization.txt');
fid = fopen(fname, 'w');
if fid == -1
    error('Could not open file %s', fname);
end

nMats = length(SysMat);

fprintf(fid, '{matrix \t%d\n', nMats);
for k = 1:nMats
    nParamLists = length(SysMat(k).paramList);
    % write matrix file name
    fprintf(fid, '\t{%s.mm \t%d\n', SysMat(k).name, nParamLists);
    % write parameters into the matrix parameter list
    for m = 1:nParamLists        
        fprintf(fid, '\t\t{paramList \t%d\n', m);
        nParams = length(SysMat(k).paramList(m).param);
        for n = 1:nParams
            fprintf(fid, '\t\t\t{%s}\n', SysMat(k).paramList(m).param{n});
        end
        fprintf(fid, '\t\t}\n');
    end
    fprintf(fid, '\t}\n');
end
fprintf(fid, '}\n');

fclose(fid);