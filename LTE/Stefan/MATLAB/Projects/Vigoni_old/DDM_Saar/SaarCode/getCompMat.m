function [compMat, tfMat] = getCompMat(portModes, Afem, nmode, PO, Np)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function call
%  compMat = getCompMat(portModes, Afem)
%
% input paramter
%    portModes: matrix containing mode coefficients on ports
%    Afem: complete fem system matrix
%
% output paramter
%    compMat: compressed matrix. Restriction to shape functions on port.
%    tfMat: transformation matrix.
%
% modified by: O. Farle, M. Loesch
% modified on: 12.11.2007
%
%   | MM  EE | |Xi|   |0|
%   |        | |  | = |0|
%   | FF  CC | |Xp|   |p|
%
%  Xp: port coefficients
%  Xi: all others
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of port nodes
MAXPO=size(PO,1);

% read out number of elements in PO
lenPO = PO(MAXPO, 1);

%     lenPO = [PO(MAXPO, 1), PO(MAXPO, 2)];
if Np > 1
    for portCnt = 2:Np
        lenPO = [lenPO, PO(MAXPO, portCnt)];
    end
end

% get dimensions
dimA = size(Afem, 1);

% initialize
tfMatM = sparse(dimA, Np * nmode);
tfMatI = speye(dimA);
tmpPO = [];

for portCnt = 1:Np
    tmpPO = [tmpPO, PO(1:lenPO(portCnt), portCnt).'];
    for modeCnt = 1:nmode
        tfMatM(PO(1:lenPO(portCnt), portCnt), (portCnt - 1) * nmode + modeCnt) = portModes((portCnt - 1) * nmode + modeCnt, 1:lenPO(portCnt));
    end
end

% kill entries
tfMatI(:, tmpPO) = [];

% construct transformation matrix
tfMat = [tfMatI, tfMatM];

% make restriction
compMat = tfMat.' * Afem * tfMat;
