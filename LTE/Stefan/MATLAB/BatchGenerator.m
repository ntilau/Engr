
filename = 'C:\work\examples\CST\3dtransline\CallWaveSolver.bat';
fid = fopen(filename, 'wt');

numPnts = 14;
fStart = 1e9;
fStop = 7.5e9;
stepSize = (fStop - fStart) / (numPnts - 1);

for pnt = fStart : stepSize : fStop
  fprintf(fid, 'EM_WaveSolver 3d %d +direct -dx -sol -out t_v1\n', pnt);
end

status = fclose(fid);
