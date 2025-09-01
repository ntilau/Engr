function QAD_refinemesh(inmesh,outmesh);

[point,ele,spig,nlab,elab,slab,NNODE,NELE,NSPIG]=ReadMesh(inmesh);

if (ele(1,1)~=3)
    disp 'Only 1st order tris!';
    return;
end

ire = 1;
irs = 1;
inn = NNODE+1;
rpoint = point;
rnlab  = nlab;
un  = sparse(NNODE,NNODE,NNODE);
NNNODE = floor(NNODE*2.5);
ue  = sparse(NNNODE,NNNODE,NNNODE);

di=0;
for ie = 1:NELE
    if (di==100)
        sprintf('Handling element %i', ie)
        di = 0;
    end
    di = di+1;
    %Places additional nodes, where needed
    if (un(ele(2,ie),ele(3,ie))==0)
        rpoint(1,inn) = (point(1,ele(2,ie))+point(1,ele(3,ie)))/2; 
        rpoint(2,inn) = (point(2,ele(2,ie))+point(2,ele(3,ie)))/2; 
        rnlab(inn) = slab(abs(spig(2,ie)));
        un(ele(2,ie),ele(3,ie))=inn;
        un(ele(3,ie),ele(2,ie))=inn;
        % We also need two edges...
        ue(ele(2,ie),inn) = irs;
        ue(inn,ele(2,ie)) = -irs;
        rslab(irs) = slab(abs(spig(2,ie))); 
        irs = irs+1;
        ue(inn,ele(3,ie)) = irs;
        ue(ele(3,ie),inn) = -irs;
        rslab(irs) = slab(abs(spig(2,ie))); 
        irs = irs+1;
        inn = inn+1; 
    else        
    end
    %Places additional nodes, where needed
    if (un(ele(3,ie),ele(4,ie))==0)
        rpoint(1,inn) = (point(1,ele(3,ie))+point(1,ele(4,ie)))/2; 
        rpoint(2,inn) = (point(2,ele(3,ie))+point(2,ele(4,ie)))/2; 
        rnlab(inn) = slab(abs(spig(3,ie)));
        un(ele(3,ie),ele(4,ie))=inn;
        un(ele(4,ie),ele(3,ie))=inn;
        % We also need two edges...
        ue(ele(3,ie),inn) = irs;
        ue(inn,ele(3,ie)) = -irs;
        rslab(irs) = slab(abs(spig(3,ie))); 
        irs = irs+1;
        ue(inn,ele(4,ie)) = irs;
        ue(ele(4,ie),inn) = -irs;
        rslab(irs) = slab(abs(spig(3,ie))); 
        irs = irs+1;
        inn = inn+1;
    end
    %Places additional nodes, where needed
    if (un(ele(4,ie),ele(2,ie))==0)
        rpoint(1,inn) = (point(1,ele(4,ie))+point(1,ele(2,ie)))/2; 
        rpoint(2,inn) = (point(2,ele(4,ie))+point(2,ele(2,ie)))/2; 
        rnlab(inn) = slab(abs(spig(4,ie)));
        un(ele(4,ie),ele(2,ie))=inn;
        un(ele(2,ie),ele(4,ie))=inn;
       % We also need two edges...
        ue(ele(4,ie),inn) = irs;
        ue(inn,ele(4,ie)) = -irs;
        rslab(irs) = slab(abs(spig(4,ie))); 
        irs = irs+1;
        ue(inn,ele(2,ie)) = irs;
        ue(ele(2,ie),inn) = -irs;
        rslab(irs) = slab(abs(spig(4,ie))); 
        irs = irs+1;
        inn = inn+1;
    end
    % Quadriply element
    rele(1,ire) = ele(1,ie);
    rele(2,ire) = ele(2,ie);
    rele(3,ire) = un(ele(2,ie),ele(3,ie));
    rele(4,ire) = un(ele(4,ie),ele(2,ie));
    relab(ire)  = elab(ie);
    
    rele(1,ire+1) = ele(1,ie);
    rele(2,ire+1) = un(ele(2,ie),ele(3,ie));
    rele(3,ire+1) = ele(3,ie);
    rele(4,ire+1) = un(ele(3,ie),ele(4,ie));
    relab(ire+1)  = elab(ie);
    
    rele(1,ire+2) = ele(1,ie);
    rele(2,ire+2) = un(ele(4,ie),ele(2,ie));
    rele(3,ire+2) = un(ele(3,ie),ele(4,ie));
    rele(4,ire+2) = ele(4,ie);
    relab(ire+2)  = elab(ie);
    
    rele(1,ire+3) = ele(1,ie);
    rele(2,ire+3) = un(ele(2,ie),ele(3,ie));
    rele(3,ire+3) = un(ele(3,ie),ele(4,ie));
    rele(4,ire+3) = un(ele(4,ie),ele(2,ie));
    relab(ire+3)  = elab(ie);
    
    
    %Nonyply edges
    rspig(1,ire) = spig(1,ie);
    rspig(2,ire) = ue(rele(2,ire),rele(3,ire));
    rspig(3,ire) = irs;
    rspig(4,ire) = ue(rele(4,ire),rele(2,ire));
    rslab(irs) = 0;
    
    rspig(1,ire+1) = spig(1,ie);
    rspig(2,ire+1) = ue(rele(2,ire+1),rele(3,ire+1));
    rspig(3,ire+1) = ue(rele(3,ire+1),rele(4,ire+1));
    rspig(4,ire+1) = irs+1;
    rslab(irs+1) = 0;
    
    rspig(1,ire+2) = spig(1,ie);
    rspig(2,ire+2) = irs+2;
    rspig(3,ire+2) = ue(rele(3,ire+2),rele(4,ire+2));
    rspig(4,ire+2) = ue(rele(4,ire+2),rele(2,ire+2));
    rslab(irs+2) = 0;
    
    rspig(1,ire+3) = spig(1,ie);
    rspig(2,ire+3) = -(irs+1);
    rspig(3,ire+3) = -(irs+2);
    rspig(4,ire+3) = -irs;

    irs = irs+3;
    ire = ire+4;
end

% Write down
fid=fopen(outmesh,'w');
%header
fprintf(fid,'%s\n','Mesh Geometry File');
%dimensions
fprintf(fid,'Elements = %6i\n',size(rele,2));
fprintf(fid,'Nodes = %6i\n',size(rpoint,2));
fprintf(fid,'Edges = %6i\n',length(rslab));
%tables
fprintf(fid,'Elements\n');
for i=1:size(rele,2)
    fprintf(fid,'%6i',i);
    fprintf(fid,'%6i',rele(1,i));
    fprintf(fid,'%6i',rele(2,i));
    fprintf(fid,'%6i',rele(3,i));
    fprintf(fid,'%6i',rele(4,i));
    fprintf(fid,'%6i\n',double(relab(i)));
end
fprintf(fid,'Nodes\n');
for i=1:size(rpoint,2)
    fprintf(fid,'%6i ',i);
    fprintf(fid,'%13.6f ',rpoint(1,i));
    fprintf(fid,'%13.6f',rpoint(2,i));
    fprintf(fid,'%6i\n',double(rnlab(i)));
end
fprintf(fid,'Edges\n');
for i=1:size(rele,2)
    fprintf(fid,'%6i',i);
    fprintf(fid,'%6i',rspig(1,i));
    fprintf(fid,'%6i',rspig(2,i));
    fprintf(fid,'%6i',rspig(3,i));
    fprintf(fid,'%6i\n',rspig(4,i));
end
fprintf(fid,'Edge Labels\n');
for i=1:length(rslab)
    fprintf(fid,'%6i',i);
    fprintf(fid,'%6i\n',double(rslab(i)));
end

fclose(fid);
%----------------------END-OF-PROCEDURE-------------------------------------%


