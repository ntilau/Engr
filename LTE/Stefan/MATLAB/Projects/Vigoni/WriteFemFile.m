function WriteFemFile(Mesh,nomefile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Writes a Quick-FEM Mesh file
%
%   (C) 1997-2008 PELOSI - COCCIOLI - SELLERI
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (isempty(findstr(nomefile,'.fem')))
    nomefile=[nomefile,'.fem'];
end

fid=fopen(nomefile,'w');
if(fid  ==  -1)
     disp('Cannot open file for writing');
     return
end

fprintf(fid,'Mesh Geometry File:\n');
%dimensions
fprintf(fid,'Elements = %6i\n',length(Mesh.elab));
fprintf(fid,'Nodes = %6i\n',length(Mesh.nlab));
fprintf(fid,'Edges = %6i\n',length(Mesh.slab));
%Elements
fprintf(fid,'Elements\n');
for i=1:length(Mesh.elab)
     fprintf(fid,'%6i',i);
     fprintf(fid,'%6i',Mesh.ele(1,i));
     for j=1:Mesh.ele(1,i)
        fprintf(fid,'%6i',Mesh.ele(j+1,i));
     end
     fprintf(fid,'%6i\n',Mesh.elab(i));
end
%Nodes
fprintf(fid,'Nodes\n');
for i=1:length(Mesh.nlab);
     fprintf(fid,'%6i ',i);
     fprintf(fid,'%13.6f ',Mesh.xy(1,i));
     fprintf(fid,'%13.6f',Mesh.xy(2,i));
     fprintf(fid,'%6i\n',Mesh.nlab(i));
end
%Edges
if(~isempty(Mesh.slab))
    fprintf(fid,'Edges\n'); 
    for i=1:length(Mesh.elab)
         fprintf(fid,'%6i',i);
         fprintf(fid,'%6i',Mesh.spig(1,i));
         for j=1:Mesh.spig(1,i)
            fprintf(fid,'%6i',Mesh.spig(j+1,i));
         end
         fprintf(fid,'\n');
    end
    % Edge labels
    fprintf(fid,'Edge Labels\n');
    for i=1:length(Mesh.slab)
         fprintf(fid,'%6i',i);
        fprintf(fid,'%6i\n',Mesh.slab(i));
    end
end
fclose(fid);
%----------------------END-OF-PROCEDURE-------------------------------------%
