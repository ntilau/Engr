% GETDOMAINDIMENSION is a struct-object with fields
% - isd -> inner scalar dimension
% - ivd -> inner vectorial dimension
% - p1sd -> port1 scalar dimension
% - p1vd -> port1 vectorial dimension
% - p2sd -> port2 scalar dimension
% - p2vd -> port2 vectorial dimension
%
% These fields characterise the system matrix structure, 
% e.g. is isd^2 the number of entries which
% result from scalar basis functions of inner nodes
%
% sum over all fields results in the whole system matrix size

function domDim = getDomainDimension


switch scalarOrder
    case 1
        isd = project.innerNodeDim;
        p1sd = project.port1NodeDim;
        p2sd = project.port2NodeDim;        
    case 2
        isd = project.innerNodeDim + project.innerEdgeDim;
        p1sd = project.port1NodeDim + project.port1EdgeDim;
        p2sd = project.port2NodeDim + project.port2EdgeDim;        
        
    case 3
        isd = project.innerNodeDim + 2*project.innerEdgeDim + project.areaDim
        p1sd = project.port1NodeDim + 2*project.port1EdgeDim;
        p2sd = project.port2NodeDim + 2*project.port2EdgeDim;        
end

switch vectorialOrder
    case 1
        ivd = 2*project.innerEdgeDim;
        p1vd = 2*project.port1EdgeDim;
        p2vd = 2*project.port2EdgeDim;
    case 2
        ivd = 3*project.innerEdgeDim + 3*project.areaDim;
        p1vd = 3*project.port1EdgeDim;
        p2vd = 3*project.port2EdgeDim;
    case 3
        ivd = 4*project.innerEdgeDim + 8*project.areaDim;
        p1vd = 4*project.port1EdgeDim;
        p2vd = 4*project.port2EdgeDim;
end
        
        
        
domDim.isd = isd;
domDim.p1sd = p1sd;
domDim.p2sd = p2sd;
domDim.ivd = ivd;
domDim.p1vd = p1vd;
domDim.p2vd = p2vd;