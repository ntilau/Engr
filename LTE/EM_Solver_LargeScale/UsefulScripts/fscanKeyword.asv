function pos = fsearchKeyword(fid, key)

tmpstr = '';
while ~strcmpi(tmpstr, key) && ~feof(fid)
    tmpstr = fscanf(fid, '%s', 1);
end

pos = ftell(fid);