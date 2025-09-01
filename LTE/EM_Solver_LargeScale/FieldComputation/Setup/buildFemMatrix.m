% Generates FEM-matrix for one point in parameter space
% STRUCT SysMat
%       System matrices, names, parameter lists
% STRUCT-ARRAY param
%       param.name...   name of parameter variables according
%                       to MatrixParametrization.txt
%       param.val...    value of parameter

function M = buildFemMatrix(SysMat, param)

setParamVariables(param);
sysDim = size(SysMat(1).val, 1);

M = sparse(sysDim, sysDim);
for matCnt = 1:length(SysMat)
    for ListCnt = 1:length(SysMat(matCnt).paramList)
        paramPoint = 1;
        for paramCnt = 1:length(SysMat(matCnt).paramList(ListCnt))
            paramPoint = paramPoint * eval(...
                SysMat(matCnt).paramList(ListCnt).param{paramCnt});
        end
        M = M + paramPoint * SysMat(matCnt).val;
    end
end
