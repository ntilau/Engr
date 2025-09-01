function DOF = calcDOF(proj)
count = 0 ;
for ii = 1:proj.edgeDim
    if (proj.netz.edge(ii).boundNr~=0)
        count = count + 1 ;
    end
end

edgeDimRel = proj.edgeDim - count ;

DOF(1) = edgeDimRel ;
DOF(2) = 2*edgeDimRel+2*proj.elemDim ;
DOF(3) = 3*edgeDimRel+6*proj.elemDim ;