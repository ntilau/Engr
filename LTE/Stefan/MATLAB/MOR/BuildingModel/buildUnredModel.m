function UnredModel = buildUnredModel(RawModel, linFreqParamFlag, transparentFlag)


if transparentFlag && linFreqParamFlag
    error('Transparent BCs (TranspFlag = true) do not lead to linear parameter dependence!');
end

% construct matrix with the ordering of the coefficients
permutMat=[];   % first column describes frequency dependence
if linFreqParamFlag
    maxOrder = 1;   % maximum order of parameter dependence
else
    maxOrder = 3;   % maximum order of parameter dependence
end
for k=0:maxOrder
    permutMat = rec(RawModel.numParams, k, permutMat, 0, 1);
end

UnredModel.sysMat{1} = RawModel.sys0;

if linFreqParamFlag
    UnredModel.sysMat{2} = -RawModel.k0^2 * RawModel.k2_mat;
    % linear material parameter dependences
    for k = 1:length(RawModel.paramNames)
        row = zeros(1,RawModel.numParams);  % row describing parameter dependence
        row(k+1) = 1;               % linear parameter dependence
        rowPos = findRowInMat(row,permutMat);
        if strfind(RawModel.paramNames{k}, 'EPSILON_RELATIVE')
            error('EPSILON_RELATIVE does not lead to linear parameter dependence!');
        elseif strfind(RawModel.paramNames{k}, 'MU_RELATIVE')
            UnredModel.sysMat{rowPos} = RawModel.paramMat{k};
        else
            error('Unknown material parameter!');
        end
    end
    if RawModel.abcFlag
        error('ABCs do not lead to linear parameter dependence!');
    end
else
    % linear material parameter dependences
    for k = 1:length(RawModel.paramNames)
        row = zeros(1, RawModel.numParams);  % row describing parameter dependence
        row(k+1) = 1;               % linear parameter dependence
        rowPos = findRowInMat(row,permutMat);
        if strfind(RawModel.paramNames{k}, 'EPSILON_RELATIVE')
            UnredModel.sysMat{rowPos} = -RawModel.k0^2 * RawModel.paramMat{k};
        elseif strfind(RawModel.paramNames{k}, 'MU_RELATIVE')
            UnredModel.sysMat{rowPos} = RawModel.paramMat{k};
        else
            error('Unknown material parameter!');
        end
    end

    UnredModel.sysMat{2} = -2 * RawModel.k0^2 * RawModel.k2_mat;   % linear k dependence

    if RawModel.abcFlag
        UnredModel.sysMat{2} = UnredModel.sysMat{2} + RawModel.abcMat;
    end
    
    c0 = 299792.458e3;
    mu0 = 4e-7*pi;
    eta0 = mu0*c0;

    if transparentFlag
        factor =  1j * RawModel.k0 * eta0;
        for identCnt = 1:length(RawModel.ident)
            UnredModel.sysMat{1} = UnredModel.sysMat{1} + factor*RawModel.ident{identCnt};
            UnredModel.sysMat{2} = UnredModel.sysMat{2} + factor*RawModel.ident{identCnt};
        end
    end

    % second order dependence:
    UnredModel.sysMat{RawModel.numParams + 2} = -RawModel.k0^2 * RawModel.k2_mat;  % k^2 dependence is -k^2*T
    for k = 1:length(RawModel.paramNames)
        row = zeros(1,RawModel.numParams); % row describing parameter dependence
        row(1) = 1;                 % linear frequency dependence
        row(k+1) = 1;               % linear parameter dependence
        rowPos = findRowInMat(row,permutMat);
        if strfind(RawModel.paramNames{k}, 'EPSILON_RELATIVE')
            UnredModel.sysMat{rowPos} = -2 * RawModel.k0^2 * RawModel.paramMat{k};
        end
    end

    % third order dependence:
    for k = 1:length(RawModel.paramNames)
        row = zeros(1,RawModel.numParams); % row describing parameter dependence
        row(1) = 2;                 % square frequency dependence
        row(k+1) = 1;               % linear parameter dependence
        rowPos = findRowInMat(row,permutMat);
        if strfind(RawModel.paramNames{k}, 'EPSILON_RELATIVE')
            UnredModel.sysMat{rowPos} = -RawModel.k0^2 * RawModel.paramMat{k};
        end
    end
end

UnredModel.permutMat       = permutMat;
UnredModel.paramNames      = RawModel.paramNames;
UnredModel.paramValInExp   = RawModel.paramValInExp;
UnredModel.numLeftVecs     = RawModel.numLeftVecs;
UnredModel.useKrylovSpaces = RawModel.useKrylovSpaces;
UnredModel.numParams       = RawModel.numParams;
UnredModel.ident           = RawModel.ident;
UnredModel.rhs             = RawModel.rhs;
UnredModel.lVec            = RawModel.lVec;
UnredModel.k0              = RawModel.k0;

