function [f, sMatrices] = readHFSSresults( filename ) 
% This function reads the S-matrices out of the .m file
% of HFSS and stores them in a three dimensional array.

run(filename);
[r c] = size(S);
dimScatMat = log2(c);
sMatrices = cell(r,1);
for k = 1:r
  sMatrices{k} = reshape(S(k,:), dimScatMat, dimScatMat);
end
