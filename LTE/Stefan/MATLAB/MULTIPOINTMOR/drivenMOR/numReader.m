function [vector1,vector2] = numReader( filename ) 
% Reads 2D to 3D Coupling files (*.num)

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

% read header
bracketO1 = fscanf(fid, '%s', 1);
EnumerationStr = fscanf(fid, '%s', 1);

sizeStr = fscanf(fid, '%s', 1);
sizeNr  = fscanf( fid, '%i', 1 );

aliveCntStr = fscanf(fid, '%s', 1);
aliveCntNr  = fscanf( fid, '%i', 1 );

deadCntStr = fscanf(fid, '%s', 1);
deadCntNr  = fscanf( fid, '%i', 1 );

% read matrix nat2act
nat2actStr = fscanf(fid, '%s', 1);
bracketO2  = fscanf(fid, '%s', 1);

type = fscanf(fid, '%s', 1);
VectorSizeNr = fscanf( fid, '%i', 1 );

if type == 'AI'
    for k = 1:VectorSizeNr,
        vector1(k) = fscanf(fid, ' %i', 1);
    end
else
    error('not yet implemented', 'Wrong array type in reader');
end
bracketC2  = fscanf(fid, '%s', 1);

% % read matrix act2nat
% act2natStr = fscanf(fid, '%s', 1);
% bracketO1  = fscanf(fid, '%s', 1);
% 
% type = fscanf(fid, '%s', 1);
% VectorSizeNr = fscanf( fid, '%i', 1 );
% 
% if type == 'AI'
%     for k = 1:VectorSizeNr,
%         vector2(k) = fscanf(fid, ' %i', 1);
%     end
% else
%     error('not yet implemented', 'Wrong array type in reader');
% end
% bracketC2  = fscanf(fid, '%s', 1);

vector2 = [];




fclose( fid );
