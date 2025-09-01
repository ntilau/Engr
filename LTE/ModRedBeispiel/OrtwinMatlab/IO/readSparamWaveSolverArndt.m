function [fPur, sMatrices] = readSparamWaveSolverArndt( filename ) 
% This function reads the S-matrices out of the sparam.txt file
% of the WaveSolver and stores them in a cell array.


%******************************************************************
%******************************************************************
numModes = 5;
%******************************************************************
%******************************************************************

fid = fopen(filename, 'r');   
fileString = fscanf(fid, '%c'); % string containing the whole file
whitePos = isspace(fileString);

spacePos = find(whitePos);
solPos = strfind(fileString, 'solution');
% find the number of strings in one line of the file 

for k=length(spacePos)-1:-1 :1,
   if spacePos(k+1)-1 == spacePos(k)
      fileString(spacePos(k+1))=' ';
      fileString(spacePos(k))='';    
   end
end

fileString = fscanf(fid, '%c'); % string containing the whole file
spacePos = find(fileString == ' ');
solPos = strfind(fileString, 'solution');
% find the number of strings in one line of the file 
numStrInLine = length(find(fileString(solPos(1):solPos(2)) == ' '));
freqs = zeros(length(spacePos)/numStrInLine,1);
% read first frequency
freqs(1) = str2num(fileString(1:spacePos(1)));
for k=2:length(spacePos)
  if mod(k,numStrInLine) == 1  % Frequency
    %freqs(ceil(k/7)) = str2num(fileString(spacePos(k-1):spacePos(k)));
    freqs(ceil(k/numStrInLine)) = str2num(fileString(spacePos(k-1):spacePos(k)));
  end
end
% determine dimension of S-matrix
dimSmatrix = length(find(freqs==freqs(1)));
% read S-Matrix and write it in multidimensional array
numFreqs = length(freqs)/dimSmatrix;  % number of different frequencies
fPur = freqs(1:dimSmatrix:end);
% use cell array to store the S-matrices
sMatrices = cell(numFreqs);
% Fill the S-matrices
for fCnt = 1:numFreqs
  for rCnt = 1:dimSmatrix
    for cCnt = 1:dimSmatrix
      strNum = (dimSmatrix*(fCnt-1)+(rCnt-1))*numStrInLine+5+(cCnt-1) + floor(2*(cCnt-1)/dimSmatrix) ;
      cmplxStr = fileString((spacePos(strNum-1)+1):(spacePos(strNum)-1));
      commaPos = find(cmplxStr == ',');
      sMatrices{fCnt}(rCnt,cCnt) = str2num(cmplxStr(2:(commaPos-1))) + ...
        j*str2num(cmplxStr((commaPos+1):(length(cmplxStr)-1)));
    end
  end
end
fclose(fid);
