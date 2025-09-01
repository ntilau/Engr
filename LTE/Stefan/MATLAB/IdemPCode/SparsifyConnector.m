function SparseDUM = SparsifyConnector(DUM,PortsSpec,CouplingType,RootFigHandle);
%
%	SparseDUM = SparsifyConnector(DUM,PortsSpec,CouplingType,RootFigHandle)
%
% This function generates a new data structure with some of the
% responses removed. The selection of the responses to be removed
% depends on topological criteria and not on energy criteria
% as for SparsifyDUM. In particular, it is assumed that the
% structure DUM refers to a connector-like structure having
% the ports grouped in two separate sets, collocated at the
% near and far end, respectively. Each pin of the connector
% is characterized by a port at the near end and by a port at
% the far end. The physical description of the pin locations
% is coded in input argument PortsSpec. This is a structure with two fields
%
%   PortsSpec.NE
%   PortsSpec.FE
%
% Each of these two fields is a Nr x Nc matrix of integers. The
% number of pins is Nr x Nc,  while the number of ports in DUM
% must equal 2 x Nr x Nc. The entries of these two matrices
% correspond to the port numbering in DUM. The same element (i,j)
% in PortsSpec.NE and PortsSpec.FE matrices denotes the port
% number of the two ends of each pin. See also the example below.
%
% This sparsification of input structure DUM is performed
% according to the last argument CouplingType. This can assume
% the values 'firstorder' or 'secondorder'. In the first case,
% all responses between ports referring to pins that are not
% adjacent to each other in matrices PortsSpec.NE and PortsSpec.FE
% are neglected. In the second case, also the port responses
% corresponding to second neighbors are retained. Note that
% this procedure assumes that the description in PortsSpec
% reflects the actual pin matrix of the physical structure
% being investigated.
%
% ------------------------------
% Author: Stefano Grivet-Talocia
% Date: February 26, 2003
% Last revision: February 18, 2005
%------------------------------
