function [evVector, EVMatrix] = evSolutionReader( filename ) 
% Reads solution file of SingleLevelCoupling option (*.2D_3D files)

fid = fopen( filename, 'r' );
if fid == -1
    error(strcat('Could not open file: ', filename)); 
end

bracketO1 = fscanf(fid, '%s', 1);
fileStr = fscanf(fid, '%s', 1);

mlpStr = fscanf(fid, '%s', 1);
mlpNr  = fscanf( fid, '%i', 1 );

levelStr = fscanf(fid, '%s', 1);
levelNr  = fscanf( fid, '%i', 1 );

modeDimensionStr = fscanf(fid, '%s', 1);
modeDimensionNr  = fscanf( fid, '%i', 1 );


for k=1:modeDimensionNr;


    vEigenValStr = fscanf(fid, '%s', 1);
    eigenPairStr  = fscanf(fid, '%s', 1);
    eigenValStr  = fscanf(fid, '%s', 1);
    bracketO2 = fscanf(fid, '%s', 1);

    type = fscanf(fid, '%s', 1);
    vectorSizeNr = fscanf( fid, '%i', 1 );
    if type == 'AC',
        ev = readComplex(fid);
    else
        error('not yet implemented', 'Wrong array type in reader');
    end

    bracketC2 = fscanf(fid, '%s', 1);
    eigenSolStr  = fscanf(fid, '%s', 1);
    bracketO2 = fscanf(fid, '%s', 1);

    type = fscanf(fid, '%s', 1);
    vectorSizeNr = fscanf( fid, '%i', 1 );

    if type == 'AR',
        for k2=1:vectorSizeNr,
            EV(k2) = fscanf(fid, ' %f', 1);
        end
    elseif type == 'AC'
        for k2=1:vectorSizeNr,
            EV(k2) = readComplex(fid);
        end

    else
        error('not yet implemented', 'Wrong array type in reader');
    end
    bracketC2 = fscanf(fid, '%s', 1);
    evVector(k) = ev;
    EVMatrix(:,k) = EV';
end


fclose( fid );
