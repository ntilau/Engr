close all;
clear;

addpath(genpath('C:\work\Matlab'));
set(0, 'DefaultFigureWindowStyle', 'docked');

modelNameOriginalBase = 'C:\work\examples\bandpassfilter\bandpass2\referenceValues\bandpass2_1.1e+009_5_l12_';

% nominal values
l12n = 0.18;
d1n = 0.016;
d2n = 0.04;

% parameter intervals
s1Start = -0.03;
s1End   = 0.03;
s1NumPnts = 9;
s2Start = -0.008;
s2End   = 0.016;
s2NumPnts = 9;
s3Start = -0.02;
s3End   = 0.04;
s3NumPnts = 9;

% compute interpolation points
% hierarchical interpolation points for debug purpose
% sIntPnts{1} = -0.03 : 0.015/2 : 0.03;
% sIntPnts{2} = -0.008 : 0.004/2 : 0.016;
% sIntPnts{3} = -0.02 : 0.01/2 : 0.04;
sIntPnts{1} = s1Start : (s1End-s1Start)/(s1NumPnts-1) : s1End;
sIntPnts{2} = s2Start : (s2End-s2Start)/(s2NumPnts-1) : s2End;
sIntPnts{3} = s3Start : (s3End-s3Start)/(s3NumPnts-1) : s3End;

s1NumPnts = length(sIntPnts{1});
s2NumPnts = length(sIntPnts{2});
s3NumPnts = length(sIntPnts{3});

sysMatIntp = cell(s1NumPnts, s2NumPnts, s3NumPnts);
k2MatIntp  = cell(s1NumPnts, s2NumPnts, s3NumPnts);

for s1Cnt = 1:length(sIntPnts{1})
  for s2Cnt = 1:length(sIntPnts{2})
    for s3Cnt = 1:length(sIntPnts{3})
      % call MeshDistorter
      systemString = ['cd C:\work\examples\bandpassfilter\bandpass2\referenceValues\ & '...
        'MeshDistorter bandpass2 1.1e9 5 ' num2str(l12n + sIntPnts{1}(s1Cnt)) ' ' ...
        num2str(d1n + sIntPnts{2}(s2Cnt)) ' ' num2str(d2n + sIntPnts{3}(s3Cnt)) ' -dx \w'];
      system(systemString);
      
      % name of new created directory
      dirName = buildDirName(modelNameOriginalBase, l12n + sIntPnts{1}(s1Cnt), ...
        d1n + sIntPnts{2}(s2Cnt), d2n + sIntPnts{3}(s3Cnt));
      compressData(dirName);
    end
  end
end