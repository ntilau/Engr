cd ehdevMOR
[TheMatrices] = ehdev('../GEO/dpost_finemesh.fem','../GEO/dpost12.aux','../GEO/dpostMOR.out',0);

save('dpostMOR.mat','TheMatrices');

sweep.epsilonstart=2.;
sweep.epsilonend=10.;
sweep.epsilonN = 40;
sweep.matlabel = 2;

Np=2;
nmode=10;

for k=1:sweep.epsilonN
for ip=1:Np
    sweep.epsilon = (sweep.epsilonend-sweep.epsilonstart)*(k-1)/(sweep.epsilonN-1)+sweep.epsilonstart;
    epsilon(k) = sweep.epsilon;
    
    c0  =   0.2998e9;   %[m/s]

    k0=2*pi*1.2*10^10/c0;
    k02=k0*k0;
    vkt2(1)  =   k02;   %in waveguide-air
    vkt2(2)  =   k02*sweep.epsilon;    %in dielectrics
    
    FEM = TheMatrices.FEM0+vkt2(1)*TheMatrices.FEM1+vkt2(2)*TheMatrices.FEM2;

    M = [TheMatrices.AC,TheMatrices.BC;TheMatrices.CD,FEM];
    I = [TheMatrices.kt(ip).IC;TheMatrices.kt(ip).ID];
    
    V0 = M\I;
    
    V1= V0(1:length(TheMatrices.kt(ip).IC));
    V2= V0(length(TheMatrices.kt(ip).IC)+1:length(V0));
    %Storing results
    disp('+----Storing results');
    for jp=1:Np
        for j=1:nmode
            s=j+(jp-1)*nmode;
            S(jp,ip,k,j) = V1(s);
            %---------DEBUG
            if(ip==1 & jp==1)
                S11(k,j) = V1(s);
            elseif(ip==1 & jp==2)
                S21(k,j) = V1(s);
            elseif(ip==2 & jp==1)
                S12(k,j) = V1(s);
            elseif(ip==2 & jp==2)
                S22(k,j) = V1(s);
            end
            %--------------
        end
        %if flagout==1
        %    writecres('fields.out',V2,NNODE,1,'M')  
        %end
    end
end %end main loop frequency
end

TheSolution.S11=S11(:,1);
TheSolution.S12=S12(:,1);
TheSolution.S21=S21(:,1);
TheSolution.S22=S22(:,1);
TheSolution.epsilon = epsilon;

save('dpostMOR_S.mat','TheSolution');
