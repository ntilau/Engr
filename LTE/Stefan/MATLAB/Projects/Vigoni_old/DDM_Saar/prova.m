function [MESH,xy,nlab,BASE_c] = prova(femname,femddname)

LPEC = 1;
Lp = [11,12];
[xy,ele,spig,nlab,elab,slab,NNODE,NELE,NSPIG] = ReadMesh(femname);
[xydd,eledd,spigdd,nlabdd,elabdd,slabdd,NNODEdd,NELEdd,NSPIGdd] = ReadMesh(femddname);
[domains] = meshDD(xy,ele,xydd,eledd);
[MESH,xy,nlab,BASE_c] = reordering(xy,xydd,nlab,ele,elab,eledd,domains,LPEC,Lp);
NDD = size(eledd,2);

color = ['r','m','y','g','b','c'];
% Plotting della mesh
figure;
hold on;
for id = 1:NDD
    elem = eledd(2:4,id);
    X = xydd(1,elem);
    Y = xydd(2,elem);
    patch(X,Y,color(mod(id,5)+1),'FaceAlpha',0.5);
    for ie = 1:size(MESH{id}.ele,2)
        elem = MESH{id}.ele(2:4,ie);
        X = xy(1,elem);
        Y = xy(2,elem);
        patch(X,Y,color(mod(id,5)+1));
    end
    axis equal;
end
hold off;