function D = generateDirMat(dirStr, projStr)

d = vectorReader([dirStr projStr '\d' ]);

xDim = length(d);
yInvDirPos = find(d == 0);
yDim = length(yInvDirPos);

D = sparse(yDim, xDim);

for yCount = 1:length(yInvDirPos),
   D( yCount, yInvDirPos(yCount) ) = 1;
end


