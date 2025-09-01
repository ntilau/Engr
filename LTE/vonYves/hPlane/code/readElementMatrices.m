close all;
clear all;

% global node coordinates
y1 = 1; y2 = 2; y3 = 4;
z1 = 5; z2 = 1; z3 = 8;

% reading data from maple-files

aii = 0;
elmMatrixFileName = strvcat('AII', 'AIV', 'AVII', 'AVIII', 'AIX', 'AX');

for i:size(elmMatrixFileName)
    fileName = sprintf('%s.dat', elmMatrixFileName(i));
    fid = fopen(fileName);

    if (fid == -1)
        error('Couldn''t open file %s', elmMatrixName);
    else
        aii_str = fgetl(fid);
        fclose(fid);
        aii = eval(aii_str);
    end
end