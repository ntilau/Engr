%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of Jacobian
%
%   function call
%      function [a, b, c] = calcJacobian(project, element)
%
%   input variables
%      project  ...struct with information about the elements (nodes,
%                  edges, numbering)
%      element  ...number of current finite element
%
%   output variables
%      a, b, c  ...parameters for transformation local<->global
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function detJ = calcJacobian(project, count)

% global coordinates of finite element (ii)
x1 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(3)).n0).x ; %1
x2 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n0).x ; %2
x3 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n1).x ; %3
y1 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(3)).n0).y ; %1
y2 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n0).y ; %2
y3 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n1).y ; %3 

detJ = x2*y3 - x3*y2 - y1*x2 + y1*x3 + x1*y2 - x1*y3;