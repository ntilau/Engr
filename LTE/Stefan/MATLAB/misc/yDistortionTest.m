

lengthX = 0.01;
lengthY = 0.01;

lenseXpos = 0.005;
lenseYpos = 0.005;

xPos = 0:0.0001:0.01;
yPos = 0:0.0001:0.01;

lenseYposDistortion = 0.001;

for xCnt = 1:length(xPos)
  for yCnt = 1:length(yPos)
    if xPos(xCnt) <= lenseXpos && yPos(yCnt) <= lenseYpos
      deltaY(xCnt, yCnt) = lenseYposDistortion / lenseXpos * xPos(xCnt)...
        * yPos(yCnt) / lenseYpos;
    elseif xPos(xCnt) > lenseXpos && yPos(yCnt) <= lenseYpos
      deltaY(xCnt, yCnt) = lenseYposDistortion / lenseXpos * ...
        (lengthX - xPos(xCnt)) * yPos(yCnt) / lenseYpos;
    elseif xPos(xCnt) <= lenseXpos && yPos(yCnt) > lenseYpos
      deltaY(xCnt, yCnt) = lenseYposDistortion / lenseXpos * ...
        xPos(xCnt) * (lengthY - yPos(yCnt)) / lenseYpos;
    elseif xPos(xCnt) > lenseXpos && yPos(yCnt) > lenseYpos
      deltaY(xCnt, yCnt) = lenseYposDistortion / lenseXpos * ...
        (lengthX - xPos(xCnt)) * (lengthY - yPos(yCnt)) / lenseYpos;      
    else
      deltaY(xCnt, yCnt) = 0;
    end
  end
end

surf(xPos, yPos, deltaY)
