% iterates a set of linespecifications
% lCnt ... counter 
% markerFlag... add marker if set
function lineSpec = getLineSpecification(lCnt, grey)

Line.color = {'b' 'r' 'g' 'k' 'm' 'c' 'y' };
Line.style = {'-'  '-.' '--' ':'};
Line.marker = {'' 'o' 's' '+' 'd'};

if nargin == 1
    grey = false;
end

if grey
    % set line specifications
    styleCnt = mod(lCnt - 1, length(Line.style)) + 1;
    markerCnt = styleCnt;


    lineSpec = sprintf('%s%s', Line.style{styleCnt}, ...
        Line.marker{markerCnt});
else

    % set line specifications
    % pass all colors -> increment style ->
    % -> pass all colors -> increment style etc.
    colorCnt = mod(lCnt - 1, length(Line.color)) + 1;
    styleInc = floor((lCnt - 1) / length(Line.color)) + 1;      
    markerInc = floor((lCnt - 1) /...
        (length(Line.color) * length(Line.style))) + 1;
    
    styleCnt = mod(styleInc - 1, length(Line.style)) + 1;
    markerCnt = mod(markerInc - 1, length(Line.marker)) + 1;


    lineSpec = sprintf('%s%s%s', Line.style{styleCnt}, Line.color{colorCnt}, ...
        Line.marker{markerCnt});
    
end
