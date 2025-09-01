function scaleFactor = scaleRhs(fCurrent, fExpansion, fCutOff, ModeNumber)

c0 = 299792.458e3;
% k0 = 2.0*pi*f0/c0;


sqrtComp1 =  fCurrent * sqrt( (fCutOff(ModeNumber) / fCurrent)^2 -1 );
sqrtComp2 =  fExpansion * sqrt( (fCutOff(ModeNumber) / fExpansion)^2 -1 );

% sqrtComp1 =  fCurrent * sqrt( 1 - (fCutOff(ModeNumber) / fCurrent)^2 );
% sqrtComp2 =  fExpansion * sqrt( 1 - (fCutOff(ModeNumber) / fExpansion)^2 );


scaleFactor =  sqrtComp1/sqrtComp2;
