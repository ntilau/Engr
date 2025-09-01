function [Asys, Afem, rhs] = buildGlobalSystem(AC, BC, CD, Cdiel, IC, ID, MESH, xy, nlab, iNODEc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   |AC 0   0                    0  BC| |B |   |IC|
%   |0  M1  0                    0  E1| |X1|   |0 |
%   |0  0   M2                   0  E2| |X2|   |0 |
%   |:  :   :                    :  : |*|: | = |: |
%   |0  0   0                    Mn En| |Xn|   |0 |
%   |CD F1  F2                   Fn Cg| |Y |   |ID|
%
% MESH   ...mesh
% xy     ...node positions
% nlab   ...global node labels
% iNODEc ...number of internal nodes (excl. boundaries)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get BLOCK
global BLOCK;

% get number of subdomains
nrd = size(BLOCK, 2);

Asys = [];
FF = [];
EE = [];
Asys = sparse(Asys);
FF = sparse(FF);
EE = sparse(EE);

Asys = AC;

for dCnt = 1:nrd 
% % 
% %     NNODE= MESH{dCnt}.NNODEi;        % Subdomain internal node count
% %     ele  = MESH{dCnt}.ele;           % Subdomain internal element map
% %     elab = MESH{dCnt}.elab;          % Element lables -> material
% %     ibase= MESH{dCnt}.BASE;          % Internal node base index into the "xy" vector
% %     NELE = size(ele,2);           % Subdomain element number

    Asys = [Asys, zeros(size(Asys, 1), size(BLOCK{dCnt}.M, 2)); ...
            zeros(size(BLOCK{dCnt}.M, 1), size(Asys, 2)), BLOCK{dCnt}.M];

    FF = [FF, BLOCK{dCnt}.F];
    EE = [EE; BLOCK{dCnt}.E];
    
end

Asys = [Asys, [BC; EE]; [CD, FF], Cdiel];

Afem = Asys( (size(AC, 1)+1):end, (size(AC, 1)+1):end );

rhs = [IC.'; zeros(size(EE, 1), 1); ID.'];
