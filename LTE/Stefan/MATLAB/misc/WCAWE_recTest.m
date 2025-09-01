close all;
clear all;

dim = 10;
numIter = 8;
A1 = rand(dim, dim);
A2 = rand(dim, dim);
b = rand(dim, 1);

% AWE
AWE(:, 1) = b;
AWE(:, 2) = A1 * AWE(:, 1);
for iCnt = 3:numIter
  AWE(:, iCnt) = A1 * AWE(:, iCnt - 1) + A2 * AWE(:, iCnt - 2);
end
  
[Q1 U1] = modifiedGramSchmidt(AWE);

% WCAWE recursion test
% V_(:, 1) = b;
% V(:, 1) = V_(:, 1);
% V_(:, 2) = A1 * V(:, 1);
% V(:, 2) = V_(:, 2) - 2 * V_(:, 1);
% for iCnt = 3:numIter
%   V_(:, iCnt) = A1 * V(:, iCnt - 1) + A2 * V(:, iCnt - 2);
%   if (iCnt - 3 > 0)
%     V_(:, iCnt) = V_(:, iCnt) - 2 * A2 * V(:, iCnt - 3);
%   end
%   V(:, iCnt) = V_(:, iCnt) - 2 * V_(:, iCnt - 1);
% end
V_(:, 1) = b;
V(:, 1) = V_(:, 1);
V_(:, 2) = A1 * V(:, 1);
V(:, 2) = V_(:, 2) - V_(:, 1);
for iCnt = 3:numIter
  V_(:, iCnt) = A1 * V(:, iCnt - 1) + A2 * V(:, iCnt - 2);
  for restCnt = 3:(iCnt - 1)
    V_(:, iCnt) = V_(:, iCnt) - A2 * V(:, iCnt - restCnt);
  end
  V(:, iCnt) = V_(:, iCnt) - V_(:, iCnt - 1);
  for restCnt2 = 2:(iCnt - 1)
    V(:, iCnt) = V(:, iCnt) - V_(:, iCnt - restCnt2);
  end
end

[Q2 U2] = modifiedGramSchmidt(V);

Q1
Q2

% AWE(:, 6)
% V_(:, 6) + 8 * AWE(:, 5) - 12 * AWE(:, 4)
% 
% U = zeros(dim, dim);
% for colCnt = 1:dim
%   U(colCnt, colCnt) = 1;
%   if (colCnt - 1) > 0
%     U(colCnt - 1, colCnt) = -2;
%   end
% end
% 
