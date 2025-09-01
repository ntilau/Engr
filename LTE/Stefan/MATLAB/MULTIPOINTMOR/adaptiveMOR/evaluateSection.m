function     [s11, s12] = evaluateSection(sysMatRed, rhs, leftVecs, fStart, fEnd, fStep);

global numLeftVecs f0 freqParam;

c0 = 299792.458e3;
u_0 = 4e-7*pi;
e_0 = 1/u_0/c0^2;
n_0 =sqrt(u_0/e_0);



%% 
% disp(['Adding Expansion Frequency ' num2str(newExpFrequency), '%10.5e into reduced Modell' ]);

% disp(' ');

S_red = sysMatRed{1};
T_red = sysMatRed{2};
abc_red = sysMatRed{3};


%Solve Reduced System
fs = linspace(fStart, fEnd, (fEnd-fStart)/fStep+1);
ks = 2*pi*fs/c0;

I = diag(ones(1,numLeftVecs));

for n = 1:length(fs),
    for k = 1:numLeftVecs,
       scale = scaleRhs(fs(n), f0, freqParam.fCutOff, k);
       rhsScaled =  i*scale * rhs{k}; 
       sol_red1{n,k} = (S_red + ks(n)*abc_red - ks(n)^2*T_red) \ rhsScaled ;
    end
    
    for kl=1:numLeftVecs,
       for kr=1:numLeftVecs,
          Z(kl, kr) = leftVecs{kl}*sol_red1{n,kr} ;
       end
    end
    
    sMat = inv(-I + Z)*(Z + I);
    s11(n)=sMat(1,1);
    s12(n)=sMat(1,2);
%     sParam(2,1,n)=sMat(2,1);
%     sParam(2,2,n)=sMat(2,2);
end


%% Save results
% disp(' ');
% disp('Saving results ...');
% tic
% 
% fNameSpara = strcat(modelName, 'sMulti_f_', num2str(freqParam.fMin,'%14.14g'), '_', ...
%   num2str(freqParam.fMax,'%14.14g'), '_', num2str(freqParam.numPnts,'%14.14g'));
% 
% fNameSpara = strcat(fNameSpara, '.txt');
% 
% saveSmatrix(sMat, freqParam, materialParams, fNameSpara, numLeftVecs, paramSpace, paramNames);
%  
% toc


