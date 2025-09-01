% convert impedance matrix ZRAW of a model with ports instead of lumped
% RLCs to the Z-matrix of an equivalent RLC-model. 
% IPORT         ... index vector of actual ports
% IRLC          ... index vector of rlc-related ports
% ZRLC          ... diagonal matrix frequency-dependent RLC-values

function Z = convertPort2LumpRlc(ZRaw, iPort, iRlc, ZRlc)

Z = ZRaw(iPort,iPort) + ZRaw(iPort,iRlc) * ...
    ((ZRlc - ZRaw(iRlc,iRlc)) \ ZRaw(iRlc,iPort));