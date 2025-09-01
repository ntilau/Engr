% reads matrix parametrization from matrixParametrization.txt
function SysMat = readMatrixParametrization(modelName)

fname = strcat(modelName, 'matrixParametrization.txt');
fid = fopen(fname, 'r');
if fid == -1
    error('Could not open file %s', fname);
end

% read {MATRIX NrOfMatrices
line = strtrim(fgetl(fid));
C = str_explode(line, ' {}');
Nmatrix = str2num(C{end});
for matCnt = 1:Nmatrix
    while true
        line = strtrim(fgetl(fid));
        C = str_explode(line, ' {}');
        if ~isempty(C)
            break;
        elseif feof(fid)
            error('Some problems with file format in %s.', fname);
        end
    end    
    
    % matrix names could contain white spaces
    matName = '';
    for k = 1:length(C)-1
        matName = [matName ' ' C{k}];
    end
    % remove file extension
    extPos = strfind(matName, '.');
    matName = strtrim(matName(1:(extPos(end) - 1)));
    SysMat(matCnt).name = matName;
    
    % read all parameter lists
    NparamList = str2num(C{end});
    for listCnt = 1:NparamList
        line = strtrim(fgetl(fid));
        C = str_explode(line, ' {}');
        if ~isempty(C)
            Nparam = str2num(C{end});
            for paramCnt = 1:Nparam
                line = strtrim(fgetl(fid));
                C = str_explode(line, '{}');
                if ~isempty(C)
                    SysMat(matCnt).paramList(listCnt).param{paramCnt} = ...
                        strtrim(C{1});
                end
            end
        end 
    end
end
            
% 
%         
%     
%     
%     Cmat = textscan(fid, '%1s %s %d', 1); 
%     
%     % read matrix name and matrix parametrization
%     matName = Cmat{2}{1}(1:(strfind(Cmat{2}{1}, '.mm')-1));
%     SysMat(matCnt).name = matName;
%     SysMat(matCnt).Nparams = Cmat{3};
%     for parCnt = 1:Cmat{3}
%         Cpar = textscan(fid, '%1s %s %f %1s', 1);
%         SysMat(matCnt).param(parCnt).name = Cpar{2}{1};
%         SysMat(matCnt).param(parCnt).exponent = Cpar{3};
%     end
%     % read }
%     textscan(fid, '%1s', 1);
% end

fclose(fid);