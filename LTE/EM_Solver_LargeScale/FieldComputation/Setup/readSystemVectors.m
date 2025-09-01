% read vectors rhs and lVec
function [rhs, lhs] = readSystemVectors(path, nRhs, dirMarker)

for k = 1:nRhs        
    if k == 1
        rhsTmp = readFullVector(...
            strcat(path, 'rhs_', num2str(k-1), '.fvec'));
        
        lhsTmp = readFullVector(...
            strcat(path, 'leftVec_', num2str(k-1), '.fvec'));
        
        rhs = zeros(length(rhsTmp), nRhs);
        lhs = zeros(length(lhsTmp), nRhs);
        
        rhs(:,k) = rhsTmp;
        lhs(:,k) = lhsTmp;
        clear rhsTmp lhsTmp;
    else
        rhs(:,k) = readFullVector(...
            strcat(path, 'rhs_', num2str(k-1), '.fvec'));
        lhs(:,k) = readFullVector(...
            strcat(path, 'leftVec_', num2str(k-1), '.fvec'));        
    end
end

if nargin >= 3
    rhs = rhs(~dirMarker, :);
    lhs = lhs(~dirMarker, :);
end
