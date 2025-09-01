[S,S11DDM,S21DDM,S12DDM,S22DDM,freqDDM] = ehdevDD('GEO/iris2.fem','GEO/iris2_dd.fem','GEO/prova.aux','GEO/bofDDM.out',0);
cd ehdev1
[Vt,xy,S,S11,S21,S12,S22,freq] = ehdev('../GEO/iris2.fem','../GEO/prova.aux','../GEO/bof.out',0)

plot(freqDDM,abs(S11DDM(:,1)),'*',freqDDM,abs(S12DDM(:,1)),'*',freqDDM,abs(S21DDM(:,1)),'*',freqDDM,abs(S22DDM(:,1)),'*');
hold
plot(freq,abs(S11(:,1)),'o',freq,abs(S12(:,1)),'o',freq,abs(S21(:,1)),'o',freq,abs(S22(:,1)),'o');