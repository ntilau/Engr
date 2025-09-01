function buildRedModelInterpolation(modelName, order, linFreqParamFlag)

%% load unreduced model
tic
disp(' ')
disp('Loading raw model...');

% read "modelParam.txt"
fNameModRedTxt = strcat(modelName, 'modelParam.txt');
[f0, paramNames, paramValInExp, numLeftVecs, abcFlag] = ...
  readModParaTxt(fNameModRedTxt);

useKrylovSpaces = vectorReader(strcat(modelName, 'useKrylovSpaces.txt'));

numParams = length(paramNames)+1;
c0 = 299792.458e3;
mu0 = 4e-7*pi;
k0 = 2*pi*f0/c0;

% construct matrix with the ordering of the coefficients
permutMat=[];   % first column describes frequency dependence
if linFreqParamFlag
  maxOrder = 1;   % maximum order of parameter dependence
else
  maxOrder = 3;   % maximum order of parameter dependence
end
for k=0:maxOrder
  permutMat = rec(numParams, k, permutMat, 0, 1);
end

% read system matrices
sys0 = MatrixMarketReader(strcat(modelName, 'system matrix'));
k2_mat = MatrixMarketReader(strcat(modelName, 'k^2 matrix'));
for k = 1:numLeftVecs
  ident{k} = MatrixMarketReader(strcat(modelName, 'ident', num2str(k-1)));
end
for k = 1:length(paramNames)  
  % names of the material matrices are equal to the parameter names
  paramMat{k} = MatrixMarketReader(strcat(modelName, paramNames{k}));
end
toc
 
%% Build parameter dependend unreduced model


% system matrix in expansion point
% ABC are already included in sys0 if present
[fact.L, fact.U, fact.P, fact.Q] = lu(sys0);


for k = 1:numLeftVecs
  rhs{k} = vectorReader(strcat(modelName, 'rhs', num2str(k-1))); 
end


testSystem

    
    
    % model.rhs{2} = rhs{2};
    [V1 H1] = wcaweVS(model1, order);  
    [V2 H2] = wcaweVS(model2, order);    
    [V3 H3] = wcaweVS(model3, order);    

    for iCount = 1:( (order+1) ),    
       VV(:, iCount*3-2 ) =  V1(:,iCount);
       VV(:, iCount*3-1 ) =  V2(:,iCount);
       VV(:, iCount*3-0 ) =  V3(:,iCount);
    end
    
% Gram Schmidt for test purpose
    
    for iCount = 1:( (order+1)*3 ),
        uVec = VV(:,iCount);
        for jCount = 1:( iCount-1 ),
            R(jCount,iCount) = Q(:,jCount)'*uVec;
            uVec = uVec - R(jCount,iCount)*Q(:,jCount);
        end
        R(iCount, iCount) = norm(uVec);
        Q(:,iCount) = uVec / R(iCount, iCount);
    end
    
    
    cppQ = MatrixMarketReader('C:\daten\2008_cpp\cppTest\wcaweMatrix.test');
    
    qDiff = max(cppQ.'-Q(:,1:length(cppQ(:,1))));
    semilogy(abs(qDiff));

%% Build reduced order model
tic
disp(' ')
disp('Building reduced order model...');

interpolPnts = calcInterpolPnts(numParams, order);

K = [];
normNewDirection = [];
% K = compGenKrySpaceNparamPoly(sysMat, fact, sol{1}, order, numParams);  % space for S11
for k = 1:length(useKrylovSpaces)
  %   [Q H] = Arnoldi(fact, sysMat{2}, sol{useKrylovSpaces(k)+1}, order);
  if numParams == 1
    oneParamModel = createOneParamModel(sysMat, permutMat, ...
      interpolPnts{order});
  
  
  
  
   

  
  
  for colCnt = 1:size(Q, 2)
      if isempty(K)
        K = Q(:, colCnt);
      else
        % modified Gram Schmidt
        for kColCnt = 1:size(K, 2)
          proj = K(:, kColCnt)' * Q(:, colCnt);
          Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
        end
        normNewDirection = [normNewDirection norm(Q(:, colCnt))];
        K = [K, (Q(:, colCnt) / norm(Q(:, colCnt)))];        
      end
    end
  else
    % several parameters
    for orderCnt = 1:length(interpolPnts)
      for pntCnt = 1:size(interpolPnts{orderCnt}, 1);
        oneParamModel = createOneParamModel(sysMat, permutMat, ...
          interpolPnts{orderCnt}(pntCnt,:));
        %       [Q H] = wcawe(fact, oneParamModel, sol{useKrylovSpaces(k)+1}, ...
        %         order);
        [Q H] = wcawe(fact, oneParamModel, sol{useKrylovSpaces(k)+1}, ...
          order);
        if isempty(K)
          K = Q;
        else
          for colCnt = 1:size(Q, 2)
            if colCnt >= orderCnt
              % modified Gram Schmidt
              for kColCnt = 1:size(K, 2)
                proj = K(:, kColCnt)' * Q(:, colCnt);
                Q(:, colCnt) = Q(:, colCnt) - proj * K(:, kColCnt);
              end
              normNewDirection = [normNewDirection norm(Q(:, colCnt))];
              K = [K, (Q(:, colCnt) / norm(Q(:, colCnt)))];
            end
          end
        end
      end
    end
  end
end

clear fact;

% % orthogonalization once again: modified Gram Schmidt
% [r c] = size(K);
% R = zeros(c,c);
% for k = 1:c
%   R(k,k) = norm(K(:,k));
%   K(:,k) = K(:,k)/R(k,k);
%   for l = (k+1):c
%     R(k,l) = K(:,k)'*K(:,l);
%     K(:,l) = K(:,l)-R(k,l)*K(:,k);
%   end
% end
Q = K;
% [Q, R] = qr(K);
clear K;

% compute projections onto space K
sysMatRed{1} = Q'*sys0*Q;
clear sys0;
for k = 1:length(sysMat)
  if ~isempty(sysMat{k})
    sysMatRed{k} = Q'*sysMat{k}*Q;
    clear sysMat{k};
  end
end

for k = 1:length(ident)
  identRed{k} = Q'*ident{k}*Q;
  clear ident{k};
end

for k = 1:numLeftVecs
  lVec = vectorReader(strcat(modelName, 'leftVec', num2str(k-1)));
  lVecRed{k} = lVec.'*Q;
  % computation of Krylov space is done in real arithmetic
  rhs{k} = -2*j*rhs{k};   
  redRhs{k} = Q'*rhs{k};
end
toc

%% Save reduced model
tic
disp(' ')
disp('Saving reduced order model...');

colCntPermutMat = size(permutMat, 2);
sysMatCleared = [];
for k = 1:length(sysMatRed)
  if ~isempty(sysMatRed{k})
    fName = strcat(modelName, 'sysMatRed_', ...
      num2str(permutMat(k, 1)));
    for m = 2:colCntPermutMat
      fName = strcat(fName, '_', num2str(permutMat(k, m)));
    end
    writeMatFull(sysMatRed{k}, fName);
    sysMatCleared = [sysMatCleared; permutMat(k,:)];
  end
end

writeSysMatRedNames(sysMatCleared, strcat(modelName, 'sysMatRedNames'));

for k = 1:length(identRed)
  fName = strcat(modelName, 'identRed', num2str(k-1));
  writeMatFull(identRed{k}, fName);
end

for k = 1:numLeftVecs
  writeVector(lVecRed{k}, strcat(modelName, 'leftVecsRed', num2str(k-1)));
  writeVector(redRhs{k}, strcat(modelName, 'redRhs', num2str(k-1)));
end
toc
