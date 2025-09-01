%
% Prepa lo sweep
%
clear;
close all;
clc;

mesh.fine   = 'GEO/dpostWR90_finemesh_old.fem';%'GEO/iris_fine.fem';%'GEO/empty_very_fine.fem';%'GEO/dpostWR90_finemesh.fem';
% mesh.fine   = 'GEO/dpostWR90_cmeshS.fem';
mesh.dd     = 'GEO/dpostWR90_cmeshDoms.fem';%'GEO/iris_dd.fem';%'GEO/empty_dd.fem';%'GEO/dpostWR90_cmeshS.fem';%'GEO/dpostWR90_cmeshS.fem'; %'GEO/dpostWR90_cmeshS.fem';
mesh.out    = 'GEO/dpostWR90_out.out';%'GEO/iris.out';%'GEO/empty_out.out';%'GEO/dpostWR90_out.out';
mesh.Np     = 2;
mesh.a      = [22.86 22.86];%[18.35,  18.35];
mesh.b      = [10.16 10.16];%[9.55,   9.56];
mesh.plab   = [11, 12];
mesh.PEClab = 1;
mesh.PMClab = 0;
mesh.nmode  = 1;
mesh.plane  = 'H';
mesh.ndie   = 2;%2;
mesh.Eps    = [1.0, 1.0];
mesh.Mu     = [1.0, 1.0];
mesh.mlab   = [1, 2];

sweep.frequency.start = 10;
sweep.frequency.stop  = 15;
sweep.frequency.N     = 6;

sweep.epsilon.materials = 1;
sweep.epsilon.start(1)  = 4;
sweep.epsilon.stop(1)   = 6;%6;
sweep.epsilon.N(1)      = 11;%11;
sweep.epsilon.mlabel(1) = 2;
sweep.epsilon.domain    = -1;

flagout = 1;

[results,freq] = ehdevDDforMOR(mesh,sweep,flagout);
%[Vt,xy,S11,S21,S12,S22,results,freq] = ehdev('GEO/iris_fine.fem','GEO/iris.aux','GEO/werner.out',0);
for kk = 1:length(results.epsilon)
    for ff = 1:length(freq)
        S11(ff,kk) =results.epsilon{kk}.S(1,1,ff,1);
        S12(ff,kk) =results.epsilon{kk}.S(1,2,ff,1);
        S21(ff,kk) =results.epsilon{kk}.S(2,1,ff,1);
        S22(ff,kk) =results.epsilon{kk}.S(2,2,ff,1);
        
        TheBigThing.SC{ff,kk} = results.epsilon{kk}.SC{ff};
        TheBigThing.C{ff,kk} = results.epsilon{kk}.C{ff};
        TheBigThing.E{ff,kk} = results.epsilon{kk}.E{ff};
        TheBigThing.Y{ff,kk} = results.epsilon{kk}.Y{ff};
    end
    epsilon = [sweep.epsilon.start];
    if sweep.epsilon.N > 1
        clear epsilon;
        epsilon(:,kk) = [sweep.epsilon.start : (sweep.epsilon.stop - sweep.epsilon.start)./(sweep.epsilon.N-1) : sweep.epsilon.stop]';
    end
end
for ff = 1:length(freq)
    TheBigThing.AC{ff} = results.AC(ff);
    TheBigThing.BC{ff} = results.BC(ff);
    TheBigThing.CD{ff} = results.CD(ff);
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
save('results/dpostWR90.mat','TheBigThing');



