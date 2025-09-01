function [Rom, Projector, Model] = addExpansionPoint(...
    newFreq, Model, Rom, Projector)

order = size(Projector.Q, 2) / Model.nPorts;
fprintf(1, '\n\n\t- Adding expansion frequency number %d', order + 1);
fprintf(1, '\n\t\t+ New expansion frequency : %1.3e Hz', newFreq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% factorize matrix in new expansion point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1, '\n\t\t+ Factorizing A(k0) ...');
tic
systemParam = struct('name', 'k0', 'val', f2k(newFreq));
M = buildFemMatrix(Model.SysMat, systemParam);

% 6 -> complex, symmetric
% -2 -> real, symmetric, indefinite
if isreal(M)
    mtype = -2; 
else
    mtype = 6;
end
% Fill-reduction analysis and symbolic factorization
[iparm,pt,err,M_val,M_ia,M_ja,ncol] = pardisoReorderLTE(mtype, M);

% Numerical factorization
pardisoFactorLTE(mtype, iparm, pt, M_val, M_ia, M_ja, ncol);

if ~isfield(Model.Time, 'factSysMat')
    Model.Time.factSysMat = [];
end
Model.Time.factSysMat = [Model.Time.factSysMat, toc];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% evaluate FE system for all excitations
fprintf(1, '\n\t\t+ Solving A(k0) * x = b ...');
tic
releaseMemory = true;
[B, Model.imagFactor] = getScaledRhs(Model, Model.rhs, newFreq, mtype);
X = pardisoSolveLTE(...
    mtype, iparm, pt, M_val, M_ia, M_ja, ncol, B, releaseMemory);
%     r = norm(M * X(:,1) - B(:,1)) / norm(B(:,1))
%     disp(strcat('Norm of resiual vector: ', num2str(r)));

if ~isfield(Model.Time, 'solveFullSystem')
    Model.Time.solveFullSystem = [];
end
Model.Time.solveFullSystem = [Model.Time.solveFullSystem, toc];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Orthogonalization
if Model.Flag.doubleOrtho
    fprintf(1, '\n\t\t+ Twofold Orthogonalization of new vectors...');
else
    fprintf(1, '\n\t\t+ Orthogonalization of new vectors...');
end
tic
[Projector.Q, Projector.R] = incrementalModifiedGramSchmidt(...
    Projector.Q, Projector.R, X, Model.Flag.doubleOrtho);

if ~isfield(Model.Time, 'orthogonalization')
    Model.Time.orthogonalization = [];
end
Model.Time.orthogonalization = [Model.Time.orthogonalization, toc];

fprintf(1, '\n\t\t+ Projecting onto new directions...');
tic
[nRows, nCols] = size(Projector.Q);
oldCols = 1:(nCols - Model.nPorts);
newCols = (nCols - Model.nPorts + 1):nCols;

% generate only new parts of reduced matrices
for k = 1:length(Model.SysMat)    
    % right upper block
    Rom.SysMat(k).val(oldCols , newCols) = Projector.Q(:,oldCols).' * ...
        Model.SysMat(k).val * Projector.Q(:,newCols);
    % left lower block
    Rom.SysMat(k).val(newCols, oldCols) = Projector.Q(:,newCols).' * ...
        Model.SysMat(k).val * Projector.Q(:,oldCols);
    % new diag block
    Rom.SysMat(k).val(newCols, newCols) = Projector.Q(:,newCols).' * ...
        Model.SysMat(k).val * Projector.Q(:,newCols);
end

Rom.rhs = Projector.Q.' * (1j * Model.imagFactor * Model.rhs);
Rom.lhs = Projector.Q.' * Model.lhs;
Rom.dim = nCols;

if ~isfield(Model.Time, 'projection')
    Model.Time.projection = [];
end
Model.Time.projection = [Model.Time.projection, toc];





