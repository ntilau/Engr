% PROJECTREADER(PROJECTNAME) for string PROJECTNAME, 
% returns a struct with all topological and geometrical data
function project = projectreader(projectPath, projectName, scalarOrder) 

project.name = projectName;

% reading project data
meshData = meshReader(projectPath, projectName);
boundary = boundaryReader(projectPath, projectName);
material = materialReader(projectPath, projectName);
materialProperty = materialPropertyReader(material, projectPath);

% read waveguide dimensions
wg = readWGDimensions(projectPath);
% read x-dependency coefficient for TE10-E-field
amplitudeXFactor = readAmplitudeFactor(projectName);

project.wg_height = wg.height;
project.wg_width = wg.width;
project.amplitudeXFactor = amplitudeXFactor;

% --------------------------------------------------------
% create project
% --------------------------------------------------------

% contain all topology data in field 'topo'
currentId = 0; % initialise Id for enumerating Nodes etc
project.topo.node = getNodeData(meshData, currentId);
currentId = currentId + length(project.topo.node);
project.topo.edge = getEdgeData(meshData, currentId);
currentId = currentId + length(project.topo.edge);
project.topo.face = getFaceData(meshData, currentId);

% contain all geometric data in field 'geo'
project.geo.poly_edges = meshData.poly_edges;
project.geo.poly_faces = meshData.poly_faces;
project.geo.material = getMaterialData(material, meshData, materialProperty);
project.geo.materialProperty = materialProperty;
project.geo.boundary = getBoundaryData(boundary, meshData);

% determine sizes of material and boundary
[tmp materialDim] =  size(project.geo.material);
[tmp boundaryDim] =  size(project.geo.boundary);

project.materialDim = materialDim;
project.boundaryDim = boundaryDim;

% --------------------------------------------------------
% determine general dimensions
% --------------------------------------------------------

% count all nodes
project.nodeDim = meshData.nodeDim;

% count all edges
project.edgeDim = meshData.edgeDim;

% count all elements
project.faceDim = meshData.faceDim;

% count all components
project.componentDim = project.nodeDim + project.edgeDim + project.faceDim;


% --------------------------------------------------------
% establish relations between geometric and topologic items
% --------------------------------------------------------
project.link.face2mtr = linkFace2Material(project);
project.link.edge2bc = linkEdge2Boundary(project);


% --------------------------------------------------------
% Depending on the order, several position indices per 
% component are required. These indices are listed in a table
% and can be accessed via unique identifiers
% --------------------------------------------------------
project.geo.domain = getDomainDimensions(project, scalarOrder);
project.geo.index = createIndexTable(project, scalarOrder);





