function printCalcData(project, assembling_time, solving_time)

fprintf('\n\n---------------------------------------------\n\n');

fprintf('Calculation Data:\n\n');
fprintf('Total Number of Elements: %d\n', project.faceDim);
fprintf('Total Number of Nodes: %d\n', project.nodeDim);
fprintf('Total Number of Edges: %d\n', project.edgeDim);
fprintf('Total Number of Degrees of Freedom: %d\n\n', project.geo.domain.overallDim);

fprintf('Elapsed Assembling Time: %fs\n', assembling_time);
fprintf('Elapsed Calculation Time: %fs', solving_time);

fprintf('\n\n---------------------------------------------\n\n');