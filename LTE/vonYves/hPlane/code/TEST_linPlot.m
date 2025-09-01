



r = zeros(length(solutionFEM),1);
for i = 1:length(tri.node)    
    r(tri.node(i).sysMatId) = 1/3 * tri.node(i).y * sin(pi*tri.node(i).z);
end

figure;

r(100) = 0;
trisurf(face, y, z, r(sysMatId));
