function [f, epsReal, epsImag] = readEpsFile(filename)

fid = fopen(filename, 'r');
a = fscanf(fid,'%g %g %g',[3 inf]);
fclose(fid);
f = a(1,:);
epsReal = a(2,:);
epsImag = a(3,:);
