function writeSysMatRedNames(sysMatRedNames, filename)

fid = fopen( filename, 'wt' );
if fid == -1
  error(strcat('Could not open file: ', filename));
end

[r c] = size(sysMatRedNames);

fprintf(fid, '%i %i \n', r, c);
for rowCnt = 1:r
  fprintf(fid, '{ AI %i ', c);
  for colCnt = 1:c
    fprintf(fid, '%i ', sysMatRedNames(rowCnt, colCnt));
  end
  fprintf(fid, '} \n');
end

fclose(fid);