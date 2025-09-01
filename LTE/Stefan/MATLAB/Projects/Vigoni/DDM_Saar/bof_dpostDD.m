sweep.epsilonstart=2.;
sweep.epsilonend=12.;
sweep.epsilonN = 101;
sweep.matlabel = 2;

for kk=1:sweep.epsilonN
    sweep.epsilon = (sweep.epsilonend-sweep.epsilonstart)*(kk-1)/(sweep.epsilonN-1)+sweep.epsilonstart;

    [S,S11DDM,S21DDM,S12DDM,S22DDM,freqDDM] = ehdevDD('GEO/dpost_finemesh.fem','GEO/dpost_cmeshS.fem','GEO/dpost.aux','GEO/dpostDD.out',0,sweep);

    S11(:,kk) =S11DDM(:,1);
    S12(:,kk) =S12DDM(:,1);
    S21(:,kk) =S21DDM(:,1);
    S22(:,kk) =S22DDM(:,1);
    
    freq(:,kk) = freqDDM';
    epsilon(:,kk) = sweep.epsilon*((1:size(freqDDM,2))./(1:size(freqDDM,2)))'
end

TheBigThing.freq = freq;
TheBigThing.epsilon = epsilon;
TheBigThing.Nfreq = size(freq,1);
TheBigThing.Nepsilon = size(epsilon,2);
TheBigThing.S11 = S11;
TheBigThing.S12 = S12;
TheBigThing.S21 = S21;
TheBigThing.S22 = S22;
TheBigThing.comment = 'This used GEO/dpost_finemesh.fem for the MESH and GEO/dpost_cmeshS.fem for the DD as well as GEO/dpost.aux';
save('dpost.mat','TheBigThing');



