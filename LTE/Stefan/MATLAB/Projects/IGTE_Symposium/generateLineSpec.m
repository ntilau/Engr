% iterates a set of linespecifications
% lCnt ... counter 
% markerFlag... add marker if set
function lineSpec = generateLineSpec(lCnt, markerFlag)

Line.width = [4 3 2 1];
Line.color = {'b' 'r' 'm' 'g' 'k' 'c'};
Line.style = {'-' '--' ':' '-.'};
if markerFlag
    Line.marker = {'o' 's' '+' 'd'};
else
    Line.marker = {'' '' '' ''};
end

sw = 0;

if sw
    % set line specifications
    % pass all colors -> increment style ->
    % -> pass all colors -> increment style etc.
    styleCnt = mod(lCnt - 1, length(Line.style)) + 1;
    widthCnt = floor((lCnt - 1) / length(Line.style)) + 1;
    widthCnt = mod(styleCnt - 1, length(Line.width)) + 1;
    markerCnt = styleCnt;


    lineSpec = sprintf('%s%s', Line.style{styleCnt}, ...
        Line.marker{markerCnt});
else

    % set line specifications
    % pass all colors -> increment style ->
    % -> pass all colors -> increment style etc.
    colorCnt = mod(lCnt - 1, length(Line.color)) + 1;
    styleCnt = floor((lCnt - 1) / length(Line.color)) + 1;
    styleCnt = mod(styleCnt - 1, length(Line.style)) + 1;
    markerCnt = styleCnt;


    lineSpec = sprintf('%s%s%s', Line.style{styleCnt}, Line.color{colorCnt}, ...
        Line.marker{markerCnt});
    
end