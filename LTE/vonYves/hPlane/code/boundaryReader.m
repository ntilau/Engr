% BOUNDARYREADER(FILENAME), for string FILENAME, is a struct which
% associates the poly_edges with their boundary conditions

function boundary = boundaryReader(projectPath, projectName)

% initialise return value
boundary = struct;

% initialise boundary-id
bcId = 0;

file = strcat(projectPath, projectName, '.bc2');

fid = fopen(file);

if fid == -1
    error('couldn''t open file %s', file);
end


while ~feof(fid)
    
    % increment bcId
    bcId = bcId + 1;
       
    polyEdgesName = fscanf(fid, '%s', 1);
    
    if ~isempty(polyEdgesName)
        
        % polyEdgesName may be no valid variable name
        polyEdgesName = makeValidVarName(polyEdgesName, 'POLY_EDGES');
        boundary(bcId).polyEdgesName = polyEdgesName;
        
        bcType =  fscanf(fid, '%s', 1);        
        boundary(bcId).bcType = bcType;
        
        % bcType 'TRANSFINITE_BC' is associated with additional parameters
        if strcmp(bcType, 'TRANSFINITE_BC')
                     
            boundary(bcId).modeRepresentation = fscanf(fid, '%s', 1);
            
            % TE-mode
            mode = fscanf(fid, '%s', 1);    
            
            if ~strcmp(mode, 'TE')
                error('Unknown file format in file ''%s''. String ''TE'' expected, received %s' , file, mode);
            end
                               
            [tmp tmp2 tmp3 modeNumber] = blockReader(fid);
            boundary(bcId).(mode) =  modeNumber;
            
            % TM-mode
            mode = fscanf(fid, '%s', 1);   
            
            if ~strcmp(mode, 'TM')
                error('Unknown file format in file ''%s''. String ''TM'' expected, received %s' , file, mode);
            end
            
            [tmp tmp2 tmp3 modeNumber] = blockReader(fid);
            boundary(bcId).(mode) =  modeNumber;
        end
           
            
    end
end
            
fclose(fid);
