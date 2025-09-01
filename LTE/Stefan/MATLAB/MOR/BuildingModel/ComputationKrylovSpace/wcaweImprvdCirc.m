function [Q U] = wcaweImprvdCirc(Fact, mat, order, Q, U, orthoFlag,...
  pardisoFlag, rhs)
% This WCAWE implementation allows the efficient computation of
% the orthogonal basis by integrating precomputed vectors from the ROM.

if isempty(Q)
  dim = 0;  % length of vectors
  for iVec = 1:length(rhs)
    if ~isempty(rhs{iVec})
      dim = size(rhs{iVec},1);
      break;
    end
  end
  Q = zeros(dim, order+1);
end

if isempty(U) && order >= 0
  v = forwBackSubst(Fact, rhs{1}, pardisoFlag);
  U(1,1) = norm(v);
  Q(:,1) = v / U(1,1);
end

for n = (size(U,2)+1):(order+1)
  v = -mat{2} * Q(:,n-1);
  for m = 2:min(length(mat)-1, n-1)
    if ~isempty(mat{m+1})
      eNmM = zeros(n-m, 1);
      eNmM(n-m) = 1;
      v = v - mat{m+1} * (Q(:,1:(n-m))*(PUwInverse(U,2,m,n)\eNmM));
    end
  end
  for m = 1:min(length(rhs)-1, n-1)
    if ~isempty(rhs{m+1})
      eNmM = zeros(n-m, 1);
      eNmM(n-m) = 1;
      correction = PUwInverse(U,1,m,n)\eNmM;
      v = v + rhs{m+1} * correction(1);
    end
  end
  v = forwBackSubst(Fact, v, pardisoFlag);
  [v projCoeffs] = orthoAgainstSpace(v, Q, n-1, orthoFlag);
  U(1:n,n) = projCoeffs;
  Q(:,n) = v;
end


