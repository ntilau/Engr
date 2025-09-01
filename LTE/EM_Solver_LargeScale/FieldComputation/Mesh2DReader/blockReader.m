% [TYPE, NAME, COUNT, DATA] = BLOCKREADER(FID), for file-identifier FID of blockType int,
% returns a vector with string TYPE, string NAME, int COUNT and struct DATA.
% DATA contains the fields corresponding to the particular block blockType
% COUNT is the number of items per DATA-block
%

function [blockType, name, count, data] = blockReader(fid)

% initialise return values
blockType = '';
name = '';
count = 0;
data = struct;

% first character has to be an opening curly brace
startMarker = '';

% loop avoids errors caused by white spaces at end of file
while (~strcmp(startMarker, '{') && ~feof(fid))
    startMarker = fscanf(fid, '%s', 1);
    if feof(fid)
        data = struct([]);
        return;
    end
end

% read block blockType
blockType = lower(fscanf(fid, '%s', 1));

if strcmpi(blockType, 'FILE')
    % do nothing
    data = struct([]);
    return;
    
elseif strcmpi(blockType, 'AI')
    % int array
    % alter return blockType to array
    data = [];

    count = fscanf(fid, '%d', 1);
    
    % read value
    for k=1:count
        data(k) = fscanf(fid, '%d', 1);
    end
    
elseif strcmpi(blockType, 'AR')
    % real double array
    % alter return blockType to array
    data = [];    
    
    count = fscanf(fid, '%d', 1);
    
    % read value
    for k=1:count
        data(k) = fscanf(fid, '%f', 1);
    end
    
elseif strcmpi(blockType, 'AC')    
    % complex double array
    count = fscanf(fid, '%d', 1);
    
    data = zeros(1, count);
    
    % complex double array    
    % read value
    for k=1:count  
        % read opening paranthesis
        c = '';
        while ~strcmp(c, '(')
            c = fscanf(fid, '%c', 1);
        end
        
        % read real part
        re = fscanf(fid, '%f', 1);
        c = '';
        while ~strcmp(c, ',')
            c = fscanf(fid, '%c', 1);
        end
        
        % read imaginary part
        im = fscanf(fid, '%f', 1);
        
        % read closing paranthesis
        c = '';
        while ~strcmp(c, ')')
            c = fscanf(fid, '%c', 1);
        end    
        
        data(k) = re + 1j * im;
    end
            
elseif strcmpi(blockType, 'POSITION')
    % create position matrix
    blockType = 'position';
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);    
    
    data = zeros(count, 2);    
    for k=1:count

        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in POSITION-Block.');
        end
        
        % read nodeType 'K2'
        if ~strcmp(fscanf(fid, '%s', 1), 'K2')
            warning('Invalid node blockType.');
        end
                
        % read x- and y-position
        data(k,1) = fscanf(fid, '%f', 1);
        data(k,2) = fscanf(fid, '%f', 1);
    end

elseif strcmpi(blockType, 'NODE')
    % NODE block is redundant because of equivalent numbering as positions
    % create node struct
    blockType = 'Node';
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for k=1:count              
        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in NODE-Block.');
        end        
        
        data(k).id =  id;   

        valueType = fscanf(fid, '%s', 1);
        data(k).valueType = valueType;
                
        % position id
        posId = fscanf(fid, '%d', 1);
        data(k).posId = posId + 1;        
    end
    
elseif strcmpi(blockType, 'EDGE')
    blockType = 'edge';
    % create edge matrix
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
     
    data = zeros(count, 2);    
    for k=1:count
        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in EDGE-Block.');
        end
        
        % read edgeType 'S'
        if ~strcmp(fscanf(fid, '%s', 1), 'S')
            warning('Invalid edge blockType.');
        end
        
        % read start and end node
        data(k,1) = fscanf(fid, '%d', 1) + 1;
        data(k,2) = fscanf(fid, '%d', 1) + 1;                
    end    
    
elseif strcmpi(blockType, 'FACE')
    blockType = 'face';
    % create face matrix
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    data = zeros(count, 3);    
    for k=1:count
        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in FACE-Block.');
        end
        
        % read faceType 'T'
        if ~strcmp(fscanf(fid, '%s', 1), 'T')
            warning('Invalid face blockType.');
        end
        % read edge ids
        data(k,1) = fscanf(fid, '%d', 1) + 1;
        data(k,2) = fscanf(fid, '%d', 1) + 1;
        data(k,3) = fscanf(fid, '%d', 1) + 1;
    end    
        
elseif strcmpi(blockType, 'ELEMENT')
    % create face struct
    error('ELEMENT block is not implemented yet');
                
elseif strcmpi(blockType, 'POLY_NODES')
    blockType = 'PolyNode';
                
    % create poly nodes struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for k=1:count
        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in POLY_NODES-Block.');
        end         
        
        data(k).type = fscanf(fid, '%s', 1);
                        
        itemName = makeValidVarName(fscanf(fid, '%s', 1), blockType);         
        data(k).name = itemName;
     
        [tmp tmp2 tmp3 nodeArray] = blockReader(fid);
        
        % increment all node id's in nodeArray        
        data(k).node = nodeArray + 1;       
    end
    
elseif strcmpi(blockType, 'POLY_EDGES')    
    blockType = 'PolyEdge';
    
    % create poly lines struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for k=1:count
        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in POLY_EDGES-Block.');
        end           
                
        data(k).type = fscanf(fid, '%s', 1);
                
        itemName = makeValidVarName(fscanf(fid, '%s', 1), blockType); 
        data(k).name = itemName;
        
        [tmp tmp2 tmp3 edgeArray] = blockReader(fid);
        
        % increment all edge id's in edgeArray        
        data(k).edge = edgeArray + 1;       
    end

elseif strcmpi(blockType, 'POLY_FACES')    
    blockType = 'PolyFace';
    
    % create poly faces struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for k=1:count
        id = fscanf(fid, '%d', 1) + 1;
        if id ~= k
            warning('Possibly inconsistent indexing in POLY_EDGES-Block.');
        end              
        data(k).type = fscanf(fid, '%s', 1);
                
        itemName = makeValidVarName(fscanf(fid, '%s', 1), blockType);
        data(k).name = itemName;
        
        [tmp tmp2 tmp3 faceArray] = blockReader(fid);
        
        % increment all faces id's in faceArray        
        data(k).face = faceArray + 1;        
    end
        
elseif strcmpi(blockType, 'MESH')
    blockType = 'MeshComponent';
    
    % create mesh lines struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for k=1:count                

        type = fscanf(fid, '%s', 1);
        data(k).type = makeValidVarName(type, 'BLOCK_TYPE');
                
        blockName = fscanf(fid, '%s', 1);
        data(k).name = makeValidVarName(blockName, 'BLOCK_NAME');                  
    end
 
elseif strcmpi(blockType, 'MATERIAL_PROPERTY')
    blockType = 'MaterialProperty';
    % requirements: every material-file must contain
    % epsilon_relative
    % mu_relative
    % sigma
    
    % create mesh lines struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
    
    if count ~= 3
        error('Three material properties are required');
    end
        
    for k = 1:count        
        % propertyType: permittivity, permeability, conductivity        
        propName = lower(fscanf(fid, '%s', 1));
        % propertyValueSet: scalar, tensor, real, complex...
        data.(propName).valueType = fscanf(fid, '%s', 1);
        
        % values or tensor components of property
        [tmp tmp2 tmp3 propertyParam] = blockReader(fid);                      
        data.(propName).value = propertyParam;       
    end
else
    data = struct([]); 
    return;
end

endMarker = fscanf(fid, '%s', 1);
    
% block end
if ~strcmp(endMarker, '}')
    error('''%s'' is not the valid block end marker', endMarker);
end

    



        
        
        