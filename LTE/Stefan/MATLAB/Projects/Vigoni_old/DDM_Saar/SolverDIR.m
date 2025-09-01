function [Bdir] = SolverDIR(AC,BC,CD,BLOCK,C,IC,ID,NNODE)
%**************************************************************************
%   [Bdir] = SolverDIR(AC,BC,CD,BLOCK,C,IC,ID)
%**************************************************************************
%
%   Direct Solver for DEBUG operation.
%
%**************************************************************************

% Definition of the Shur-complement matrix.--------------------------------
ND = size(BLOCK,2);         %Subdomain number

Mat = spalloc(NNODE,NNODE,3*NNODE);


return