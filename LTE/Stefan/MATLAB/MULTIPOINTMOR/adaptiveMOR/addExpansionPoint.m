function [sysMatRed, redRhs, redLeft] = addExpansionPoint(newExpFrequency, sysMatRed)

global S abcMat T Qp R rhs lVec numLeftVecs f0 freqParam;

c0 = 299792.458e3;
u_0 = 4e-7*pi;
e_0 = 1/u_0/c0^2;
n_0 =sqrt(u_0/e_0);

ke = 2*pi*newExpFrequency/c0;

%% 
disp(['Adding Expansion Frequency ' num2str(newExpFrequency, '%10.3e')]);
[fact.L, fact.U, fact.P, fact.Q] = lu(S + ke*abcMat - ke^2*T);
Qn=[];
for k = 1:numLeftVecs
    scale(k) = scaleRhs(newExpFrequency, f0, freqParam.fCutOff, k);
    RHS{k} = i*scale(k)*rhs{k}  ;
    sol{k} = fact.Q*(fact.U\(fact.L\(fact.P*RHS{k})));        
    Qn = [Qn sol{k}];
end

% disp('...reducing Modell');
% for k = 1:numLeftVecs,
%     Qp = [ Qp  sol{k} ];
% end



% Subspace Projection
% [Qp,R] = qr([Qp, Qn],0);
% Qn = Qp(:, end-1:end);
% Qp = Qp(:, 1:end-2);

[xDim, yDim] = size(sysMatRed{1});
[xP, yP] = size(Qp);

[Qnew, Rnew] = gramSchmidt(Qp, R, Qn, xDim );

Qp = Qnew(:,1:end-2);
Qn = Qnew(:,end-1:end);

sysMatRed{1}(1:yP , xDim+1:xDim+2) =  Qp.'*S*Qn;
sysMatRed{1}(yDim+1:yDim+2, 1:yP) =  Qn.'*S*Qp;
sysMatRed{1}(xDim+1:xDim+2, xDim+1:xDim+2) =  Qn.'*S*Qn;
sysMatRed{2}(1:yP , xDim+1:xDim+2) =  Qp.'*T*Qn;
sysMatRed{2}(yDim+1:yDim+2, 1:yP) =  Qn.'*T*Qp;
sysMatRed{2}(xDim+1:xDim+2, xDim+1:xDim+2) =  Qn.'*T*Qn;
sysMatRed{3}(1:yP , xDim+1:xDim+2) =  Qp.'*abcMat*Qn;
sysMatRed{3}(yDim+1:yDim+2, 1:yP) =  Qn.'*abcMat*Qp;
sysMatRed{3}(xDim+1:xDim+2, xDim+1:xDim+2) =  Qn.'*abcMat*Qn;


Qp = [Qp Qn];

for k = 1:numLeftVecs,
   redRhs{k} = Qp.'*rhs{k};
   redLeft{k} = lVec{k}'*Qp;
end



