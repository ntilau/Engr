function matDir = deleteDirichlet( mat, d ) % Function definition line

% homogeneous Dirichlet conditions: 
dHit = 0;
[r c] = size(mat);
if r~=c
    error('Matrix has wrong dimension');
elseif r~=length(d)
    error('Dirichlet vector has wrong length');
end

% deleting rows
for k = 1:r
    if( ~d(k) )    % row is not empty
        matDummy(k-dHit, :) = mat(k,:);
    else
        dHit = dHit+1;
    end
end

dHit = 0;
% deleting columns
for k = 1:r
    if( ~d(k) )   % column is not empty
        matDir(:,k-dHit) = matDummy(:,k);
    else
        dHit = dHit+1;
    end
end








