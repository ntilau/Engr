function cap = platCond3d(lengthX, lengthY, distZ, h)

pi_ = 3.141592653589793238;
c0 = 299792.458e3;
mu0 = 4e-7 * pi_;
eps0 = 1.0 / mu0 / c0 / c0;
eta0 = mu0 * c0;

A = zeros(round(2*lengthX*lengthY/h^2));
[r, c] = size(A);
dimA = r;
obsCnt = 0
for srcPnt = 0:dimA-1
  if srcPnt < dimA/2
    yCoordSrc = mod(srcPnt, lengthY/h)*h;
    xCoordSrc = floor(srcPnt/(lengthY/h))*h;
    zCoordSrc = 0;
  else
    yCoordSrc = mod(srcPnt-dimA/2, lengthY/h)*h;
    xCoordSrc = floor((srcPnt-dimA/2)/(lengthY/h))*h;
    zCoordSrc = distZ;
  end
  srcPntCoords = [xCoordSrc, yCoordSrc, zCoordSrc];
  for obsPnt = 0:dimA-1
    if (srcPnt == obsPnt)
      % source point is observation point
      A(srcPnt+1,obsPnt+1) = h/pi/eps0*log(sqrt(2)+1);
    else
      % compute distance of source point and observation point
      if obsPnt < dimA/2
        yCoordObs = mod(obsPnt, lengthY/h)*h;
        xCoordObs = floor(obsPnt/(lengthY/h))*h;
        zCoordObs = 0;
      else
        yCoordObs = mod(obsPnt-dimA/2, lengthY/h)*h;
        xCoordObs = floor((obsPnt-dimA/2)/(lengthY/h))*h;
        zCoordObs = distZ;
      end
      obsPntCoords = [xCoordObs, yCoordObs, zCoordObs];
      A(srcPnt+1,obsPnt+1) = h^2/(4*pi*eps0*norm(obsPntCoords-srcPntCoords));
    end
  end
end

v = zeros(dimA,1);
v(1:dimA/2) = -1;
v((dimA/2+1):dimA) = +1;

sigma = A\v;
Q = sum(sigma((dimA/2+1):dimA))*h^2;
cap = Q/2;
capAnalyt = eps0*lengthX*lengthY/distZ
