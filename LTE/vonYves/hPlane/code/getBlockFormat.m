% GETBLOCKFORMAT(BLOCKTYPE) is a struct to specify the format
% of an arbitrary block, based on EM_EIGENMODESOLVER2D-mesh-files
% with fields:
% nameFlag 
% countFlag 
% idFlag 
% idTypeC -> string for reading formatted data according to C-Syntax
% valueTypeFlag
% itemNameFlag 
% valueTypeC -> string for reading formatted data according to C-Syntax
% valueCount -> number of values per item



function format = getBlockFormat(blockType)

nameFlag = 0;
countFlag = 0;
idFlag = 0;
idTypeC = '';
valueTypeFlag = 0;
itemNameFlag = 0;
valueTypeC = '';
valueCount = 0;

if strcmp(blockType, 'AI')
    % integer array block
    countFlag = 1;
    valueTypeC = '%d';
    valueCount = 1;
    
elseif strcmp(blockType, 'AR')
    % real double array block
    countFlag = 1;
    valueTypeC = '%f';
    valueCount = 1;
    
elseif strcmp(blockType, 'AC')
    % complex double array block
    error('AC block is not implemented!');
    
elseif strcmp(blockType, 'POSITION')
    % position block (2d cartesian coordinates only)
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%d';
    valueTypeFlag = 1;
    valueTypeC = '%f';
    valueCount = 2;
    
elseif strcmp(blockType, 'NODE')
    % node block
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%d';
    valueTypeFlag = 1;
    valueTypeC = '%d';
    valueCount = 1;
 
elseif strcmp(blockType, 'EDGE')
    % edge block
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%d';
    valueTypeFlag = 1;
    valueTypeC = '%d';
    valueCount = 2;
    
elseif strcmp(blockType, 'FACE')
    % face block
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%d';
    valueTypeFlag = 1;
    valueTypeC = '%d';
    valueCount = 3;

elseif strcmp(blockType, 'POLY_EDGES')
    % poly edges block
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%d';
    valueTypeFlag = 1;
    itemNameFlag = 1;
    valueTypeC = 'AI';
    valueCount = 1;

elseif strcmp(blockType, 'POLY_FACES')
    % poly faces block
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%d';
    valueTypeFlag = 1;
    itemNameFlag = 1;
    valueTypeC = 'AI';
    valueCount = 1;    
    
elseif strcmp(blockType, 'MESH')
    % poly mesh block
    nameFlag = 1;
    countFlag = 1;
    idFlag = 1;
    idTypeC = '%s';
    valueTypeFlag = 0;
    itemNameFlag = 0;
    valueTypeC = '%s';
    valueCount = 1;    
    
end


format.nameFlag = nameFlag;
format.countFlag = countFlag;
format.idFlag = idFlag;
format.idTypeC = idTypeC;
format.valueTypeFlag = valueTypeFlag;
format.itemNameFlag = itemNameFlag;
format.valueTypeC = valueTypeC;
format.valueCount = valueCount;