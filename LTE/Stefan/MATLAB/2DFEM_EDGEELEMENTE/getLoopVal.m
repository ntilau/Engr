function [startx, endx, starty, endy] = getLoopVal(project, X, Y, ii)

    node1x = project.netz.node(project.netz.elem(ii).node(1)).x ;
    node2x = project.netz.node(project.netz.elem(ii).node(2)).x ;
    node3x = project.netz.node(project.netz.elem(ii).node(3)).x ;
    nodex  = [node1x node2x node3x] ;
    
    node1y = project.netz.node(project.netz.elem(ii).node(1)).y ;
    node2y = project.netz.node(project.netz.elem(ii).node(2)).y ;
    node3y = project.netz.node(project.netz.elem(ii).node(3)).y ;
    nodey  = [node1y node2y node3y] ;
    
    maxx = max(nodex);
    maxy = max(nodey) ;
    minx = min(nodex) ;
    miny = min(nodey) ;
    
    id1x = find(X<=maxx) ;
    id2x = find(X>=minx) ;
    idx = intersect(id1x, id2x) ;
    endx = max(idx) ;
    startx = min(idx) ;
    
    id1y = find(Y<=maxy) ;
    id2y = find(Y>=miny) ;
    idy = intersect(id1y, id2y) ;
    endy = max(idy) ;
    starty = min(idy) ;