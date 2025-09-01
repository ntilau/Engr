% [TYPE, NAME, COUNT, DATA] = BLOCKREADER(FID), for file-identifier FID of type int,
% returns a vector with string TYPE, string NAME, int COUNT and struct DATA.
% DATA contains the fields corresponding to the particular block type
% COUNT is the number of items per DATA-block
%


function [type, name, count, data] = blockReader(fid)

% initialise return values
type = '';
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

% read block type
type = fscanf(fid, '%s', 1);

if strcmp(type, 'FILE')
    % do nothing
    data = struct([]);
    return;
    
elseif strcmp(type, 'AI')
    % int array
    % alter return type to array
    data = [];

    count = fscanf(fid, '%d', 1);
    
    % read value
    for i=1:count
        data(i) = fscanf(fid, '%d', 1);
    end
    
elseif strcmp(type, 'AR')
    % real double array
    % alter return type to array
    data = [];    
    
    count = fscanf(fid, '%d', 1);
    
    % read value
    for i=1:count
        data(i) = fscanf(fid, '%f', 1);
    end
    
elseif strcmp(type, 'AC')
    % complex double array
    count = fscanf(fid, '%d', 1);
    
    error('AC block not implemented');
        
elseif strcmp(type, 'POSITION')
    % create position struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);    
    
    for i=1:count

        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;   
        
        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType;
        
        % y- and z-position
        data(i).y = fscanf(fid, '%f', 1);
        data(i).z = fscanf(fid, '%f', 1);


    end

elseif strcmp(type, 'NODE')
    % create node struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count
        % node id
        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;   

        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType;
                
        % position id
        posId = fscanf(fid, '%d', 1);
        data(i).posId = posId + 1;        
    end
    
elseif strcmp(type, 'EDGE')
    % create node struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count
        % edge id
        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;   
        
        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType; 
        
        % node id's
        node1Id = fscanf(fid, '%d', 1);
        node2Id = fscanf(fid, '%d', 1);        
        data(i).node1Id = node1Id + 1;        
        data(i).node2Id = node2Id + 1;                
    end
    
elseif strcmp(type, 'FACE')
    % create face struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count
        % face id
        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;   
        
        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType;
        
        % edge id's
        edge1Id = fscanf(fid, '%d', 1);
        edge2Id = fscanf(fid, '%d', 1);        
        edge3Id = fscanf(fid, '%d', 1);        
        data(i).edge1Id = edge1Id + 1;        
        data(i).edge2Id = edge2Id + 1;
        data(i).edge3Id = edge3Id + 1;
    end

    
elseif strcmp(type, 'ELEMENT')
    % create face struct
    error('ELEMENT block not implemented');
                
elseif strcmp(type, 'POLY_NODES')
    % create poly nodes struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count
        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;        
        
        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType;
                
        itemName = fscanf(fid, '%s', 1);
        itemName = makeValidVarName(itemName, type);        
        data(i).itemName = itemName;
     
        [tmp tmp2 tmp3 nodeArray] = blockReader(fid);
        
        % increment all node id's in nodeArray
        nodeArray = nodeArray + 1;
        data(i).node = nodeArray;
       
    end
                
elseif strcmp(type, 'POLY_EDGES')
    % create poly lines struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count

        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;        
        
        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType;
                
        itemName = fscanf(fid, '%s', 1);
        itemName = makeValidVarName(itemName, type);     
        data(i).itemName = itemName;
        
        [tmp tmp2 tmp3 edgeArray] = blockReader(fid);
        
        % increment all node id's in nodeArray
        edgeArray = edgeArray + 1;
        data(i).edge = edgeArray;
       
    end

elseif strcmp(type, 'POLY_FACES')
    % create poly faces struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count

        id = fscanf(fid, '%d', 1);
        data(i).id =  id + 1;        
        
        valueType = fscanf(fid, '%s', 1);
        data(i).valueType = valueType;
                
        itemName = fscanf(fid, '%s', 1);
        itemName = makeValidVarName(itemName, type);     
        data(i).itemName = itemName;
        
        [tmp tmp2 tmp3 faceArray] = blockReader(fid);
        
        % increment all node id's in nodeArray
        faceArray = faceArray + 1;
        data(i).face = faceArray;
        
    end
        
elseif strcmp(type, 'MESH')
    % create mesh lines struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count

        blockType = fscanf(fid, '%s', 1);
        blockType = makeValidVarName(blockType, 'BLOCK_TYPE');
                
        blockName = fscanf(fid, '%s', 1);
        blockName = makeValidVarName(blockName, 'BLOCK_NAME');   
                
        data.(blockType) = blockName;        
       
    end
 
elseif strcmp(type, 'MATERIAL_PROPERTY')
    % create mesh lines struct
    name = fscanf(fid, '%s', 1);
    count = fscanf(fid, '%d', 1);
        
    for i=1:count
        
        % propertyType: permittivity, permeability, conductivity
        propertyType = fscanf(fid, '%s', 1);
        propertyType = lower(propertyType);
                
        % propertyDescription: scalar, tensor, real, comples...
        propertyDescription = fscanf(fid, '%s', 1);
        
        % values or tensor components of property
        [tmp tmp2 tmp3 propertyParam] = blockReader(fid);
        
        data.(propertyType).description = propertyDescription;
        data.(propertyType).param = propertyParam;
       
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

% convert title to lower case
type = lower(type);       

    



        
        
        