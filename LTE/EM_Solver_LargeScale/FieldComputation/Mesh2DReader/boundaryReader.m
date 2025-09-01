% read (name).bc2 file, which contains polyEdge-boundary-relations.
function Geo = boundaryReader(Model)

fprintf(1, '\n\t- Read bc2-boundary-file...');

Boundary = struct;
iBound = 0;
port2Boundary = [];
polyEdge2Boundary = [];

file = strcat(Model.path, Model.name, '.bc2');
fid = fopen(file);
if fid == -1
    error('couldn''t open file %s', file);
end

while ~feof(fid)        
    iBound = iBound + 1;       
    polyEdgeName = fscanf(fid, '%s', 1);    
    if ~isempty(polyEdgeName)                
        
        % polyEdgeName may be no valid variable name        
        polyEdgeName = makeValidVarName(polyEdgeName, 'PolyEdge');
        Boundary(iBound).name = polyEdgeName;
        
        bcType =  fscanf(fid, '%s', 1);        
        Boundary(iBound).type = bcType;
        
        polyEdgeId = getPolyObjectId(Model.Mesh.PolyEdge, polyEdgeName);
        Boundary(iBound).polyEdgeId = polyEdgeId;
        
        polyEdge2Boundary = [polyEdge2Boundary; polyEdgeId, iBound]; %#ok<AGROW>
        
        % bcType 'TRANSFINITE_BC' is associated with additional parameters
        if strcmp(bcType, 'TRANSFINITE_BC')            
            port2Boundary = [port2Boundary, iBound]; %#ok<AGROW>
                     
            Boundary(iBound).modeType = fscanf(fid, '%s', 1);
            
            % TE-mode
            mode = fscanf(fid, '%s', 1);    
            
            if ~strcmp(mode, 'TE')
                error(['Unknown file format in file ''%s''.',...
                    'String ''TE'' expected, received %s'] , file, mode);
            end
                               
            [tmp tmp2 tmp3 modeNumber] = blockReader(fid);
            Boundary(iBound).(mode) =  modeNumber;
            
            % TM-mode
            mode = fscanf(fid, '%s', 1);   
            
            if ~strcmp(mode, 'TM')
                error(['Unknown file format in file ''%s''.',...
                    'String ''TM'' expected, received %s'] , file, mode);
            end
            
            [tmp tmp2 tmp3 modeNumber] = blockReader(fid);
            if ~isempty(modeNumber)
                warning('TM-modes are not implemented yet'); %#ok<WNTAG>
            end
            Boundary(iBound).(mode) =  modeNumber;
        end
    end
end
fclose(fid);

% find polyEdges with no boundary specified explicitly
unspecifiedPolyEdge = ...
    setdiff(1:Model.Mesh.nPolyEdges, polyEdge2Boundary(:,1));

nBoundaries = length(Boundary);
for k = 1:length(unspecifiedPolyEdge)
    if k == 1
        warning(['There are unspecified PolyEdge-Items. ',...
            'These are set to PMC-bounds']); %#ok<WNTAG>
    end
    iBound = nBoundaries + k;
    Boundary(iBound).name = sprintf('pmcBound_%d', k);
    Boundary(iBound).type = 'PMC2D';
    Boundary(iBound).polyEdgeId = unspecifiedPolyEdge(k);        
    polyEdge2Boundary = [polyEdge2Boundary; ...
        unspecifiedPolyEdge(k), iBound]; %#ok<AGROW>
end
    
Geo.nBoundaries = length(Boundary);
Geo.Boundary = Boundary;
Geo.port2Boundary = port2Boundary;
Geo.polyEdge2Boundary = polyEdge2Boundary;


