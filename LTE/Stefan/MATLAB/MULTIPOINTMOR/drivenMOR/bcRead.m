function [ bcStructure ] = bcRead(filename)

fid = fopen( filename, 'r' );
if fid == -1,
    error(strcat('Could not open file: ', filename)); 
end

faceStr = 'FACE';
bcCounter = 1;
currentStr = fscanf(fid, '%s', 1);

while ( strcmp(currentStr, '') ~= 1   )

   bcStructure(bcCounter).name = fscanf(fid, '%s', 1);   
   bcStructure(bcCounter).bc = fscanf(fid, '%s', 1);  
   
   if strcmp( bcStructure(bcCounter).bc, 'TRANSFINITE_BC_EIGENMODE' ),
      bcStructure(bcCounter).bcType = 1;
   else
       bcStructure(bcCounter).bcType = 0;
   end  
   
   currentStr = fscanf(fid, '%s', 1);
   while (  ( strcmp( currentStr, faceStr ) ~= 1 )  &&  ( strcmp(currentStr, '') ~= 1 )  ),
      bcStructure(bcCounter).bc = [ bcStructure(bcCounter).bc ' ' currentStr ];
      currentStr = fscanf(fid, '%s', 1);
   end
   bcCounter = bcCounter + 1;
end


fclose( fid );

