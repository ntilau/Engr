function scaleFactor = scaleRhs(fCurrent, fExpansion, fCutOff)

sqrtComp1 =  fCurrent * sqrt( (fCutOff / fCurrent)^2 -1 );
sqrtComp2 =  fExpansion * sqrt( (fCutOff / fExpansion)^2 -1 );

scaleFactor =  (sqrtComp1 / sqrtComp2);
