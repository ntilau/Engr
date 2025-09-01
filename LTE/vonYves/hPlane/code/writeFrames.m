function a = writeFrames(frames)

[tmp frameDim] = size(frames);

fid = fopen('frame.dat', 'w');

count = fwrite(fid, frames(1).cdata(1,1,1));

fclose(fid);

fid = fopen('frame.dat');

a = fread(fid);

fclose(fid);
