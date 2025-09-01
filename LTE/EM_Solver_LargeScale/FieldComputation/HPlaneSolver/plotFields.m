%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show Solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function frame = plotFields(Model, field, phi)

x = Model.Mesh.position(:,1);
y = Model.Mesh.position(:,2);

if Model.pOrder == 2
    edgeMidpoint = getEdgeMidpoint(Model.Mesh, 1:Model.Mesh.nEdges);
    x = [x; edgeMidpoint(:,1)];
    y = [y; edgeMidpoint(:,2)];    
end
  
% 2D plot for E_z
tri = zeros(Model.Mesh.nFaces, 3);
for faceCnt = 1:Model.Mesh.nFaces;    
    edge = Model.Mesh.face(faceCnt,:);
    node = unique(Model.Mesh.edge(edge,:));            
    tri(faceCnt, :) = node;
end


fieldMax = max(abs(field));

h = figure;
nAngles = length(phi);

for k = 1:nAngles
    trisurf(tri, x, y, real(exp(1i * phi(k)) * field));
%         'FaceColor', 'interp');    
        
    view([0, 0, 1]);
    xlim([min(x), max(x)]);
    ylim([min(y), max(y)]);
    axis equal;
    caxis([-fieldMax, fieldMax]);
    frame(k) = getframe(h); 
end



