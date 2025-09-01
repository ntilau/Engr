function [ frmStructure ] = frmRead(filename)

fid = fopen( filename, 'r' );
if fid == -1,
    error(strcat('Could not open file: ', filename)); 
end

bcCounter = 1;
currentStr = fscanf(fid, '%s', 1);

while ( strcmp(currentStr, '') ~= 1   )
   frmStructure(bcCounter).name = currentStr;   
   frmStructure(bcCounter).frm = fscanf(fid, '%s', 1);  
   currentStr = fscanf(fid, '%s', 1); 
   bcCounter = bcCounter + 1;
end


fclose( fid );

