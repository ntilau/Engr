function [gradL2, gradL3] = calcGradients(project, detJ, count)

% global coordinates of finite element (ii)
x1 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(3)).n0).x ; %1
x2 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n0).x ; %2
x3 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n1).x ; %3
y1 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(3)).n0).y ; %1
y2 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n0).y ; %2
y3 = project.netz.node(project.netz.edge(project.netz.elem(count).edge(1)).n1).y ; %3

% calculate gradients gradL2 and gradL3
gradL2 = [ (y3-y1) / detJ ;
           (x1-x3) / detJ ] ;
gradL3 = [ (y1-y2) / detJ ;
           (x2-x1) / detJ ] ;