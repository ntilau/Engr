function generateReducedModel2D(projectPath, portName, fExp, eigNumb)
constants;


%% Generate and load frequency independent matrices
disp(' ');
disp('Generate and load frequency independent matrices ...');
tic
[S_k0,S_k1,S_k2,T_k0,T_k1,T_k2] = getFreqDepMat(projectPath, portName );
toc

%% Generate projection matrix 
disp(' ');
myStr = ['Generate reduced Model for port: ' portName ' (' num2str(eigNumb) 'modes)'];
disp(myStr);
tic


V_ev = [];
for n=1:length(fExp)
    rhsAVPnatMat = getEigvecDepFreq(eigNumb, fExp(n), projectPath, portName);

    correspondence = [projectPath portName '\' portName '.num'];
    [nat2actPort, act2natPort ] = numReader( correspondence ) ;

    % nat2act port correspondence
    for k1 = 1:length(rhsAVPnatMat(1,:)),
        rhsAVPnat = rhsAVPnatMat(:,k1);
        for k2 = 1:length(rhsAVPnatMat(:,1)),
            rhsAVPact( nat2actPort(k2)+1 ) = rhsAVPnat(k2); % Achtung + 1
        end
        V_ev = [V_ev rhsAVPact.'];
    end
end

% -------------------------------------------------------------------------
% Delete Dirichlet entries
V_positions = vectorReader([projectPath portName '\jV_unknowns' ]);

dirMat = generateDirMat(projectPath, portName);

V_ev = dirMat * V_ev;
V_positions = dirMat * V_positions;

% -------------------------------------------------------------
%Orthogonalization
[Q_ev,R] = qr(V_ev,0);
%  or   Singular value decomposition
%[Q_ev,SSS,V] = svd(V_ev,0);
%Q_ev = Q_ev(:,1:24);



%% Decompose Q_ev in Q_At, Q_psi und Q_jV

At_DoF_Numbers = find(V_positions==0);
psi_DoF_Numbers = find(V_positions<0);
jV_DoF_Numbers = find(V_positions>0);

q_jV1 = zeros(length(Q_ev(:,1)),1);
q_psi1 = zeros(length(Q_ev(:,1)),1);
q_At1 = zeros(length(Q_ev(:,1)),1);
q_jV1(jV_DoF_Numbers) = 1;
q_psi1(psi_DoF_Numbers) = 1;
q_At1(At_DoF_Numbers) = 1;

for kk= 1:length(Q_ev(1,:)),
  Q_jV(:,kk) = Q_ev(:,kk).*(q_jV1);
  Q_psi(:,kk) = Q_ev(:,kk).*q_psi1;
  Q_At(:,kk) = Q_ev(:,kk).*q_At1;
%     Q_psi_on_jV(:,kk) = GeneratePsi_on_jV(Q_ev(:,kk), V_positions, 1 ); 
%   Q_jV_on_psi(:,kk) = GeneratejV_on_Psi(Q_ev(:,kk), V_positions, 1 ); 
end


%% Generate reduced order model

Q_av = [ Q_At +  Q_jV ];
% [Q_av,R] = qr(Q_av,0);

T_Q_av = T_k0 * Q_av; % temporary vector

% Generate Ipsi and Iphi
[I_psi, I_phi] = GenerateI(V_positions);  
T_psi = I_psi' * T_k0 * I_psi;

psi_0 = -I_psi * (T_psi \ (I_psi' * T_Q_av));
psi_1 = -I_psi * (T_psi \ (I_phi' * T_Q_av));

Q_0 = Q_av + psi_0;
Q_1 = psi_1;

% --------------------------------------------------------------------- 
% Multiply divergece condition lines in original problem by (-1)
S_k0(jV_DoF_Numbers,:) =   -1 * S_k0(jV_DoF_Numbers,:);
S_k1(jV_DoF_Numbers,:) =   -1 * S_k1(jV_DoF_Numbers,:);
S_k2(jV_DoF_Numbers,:) =   -1 * S_k2(jV_DoF_Numbers,:);
TU = T_k0;
T_k0(jV_DoF_Numbers,:) =   -1 * T_k0(jV_DoF_Numbers,:);

% Compute reduced frequency independent matrices
S_000 = Q_0' * S_k0 * Q_0;
S_100 = Q_1' * S_k0 * Q_0;
S_001 = Q_0' * S_k0 * Q_1;
S_101 = Q_1' * S_k0 * Q_1;

S_010 = Q_0' * S_k1 * Q_0;
S_110 = Q_1' * S_k1 * Q_0;
S_011 = Q_0' * S_k1 * Q_1;
S_111 = Q_1' * S_k1 * Q_1;

S_020 = Q_0' * S_k2 * Q_0;
S_120 = Q_1' * S_k2 * Q_0;
S_021 = Q_0' * S_k2 * Q_1;
S_121 = Q_1' * S_k2 * Q_1;

T_000 = Q_0' * T_k0 * Q_0;
T_100 = Q_1' * T_k0 * Q_0;
T_001 = Q_0' * T_k0 * Q_1;
T_101 = Q_1' * T_k0 * Q_1;


TU_000 = Q_0.' * TU * Q_0;
TU_100 = Q_1.' * TU * Q_0;
TU_001 = Q_0.' * TU * Q_1;
TU_101 = Q_1.' * TU * Q_1;


% collect terms
S_0 = S_000;
S_1 = S_100 + S_001 + S_010;
S_2 = S_101 + S_110 + S_011 + S_020;
S_3 = S_111 + S_120 + S_021;
S_4 = S_121;

T_0 = T_000;
T_1 = T_100 + T_001 ;
T_2 = T_101 ;

TU_0 = TU_000;
TU_1 = TU_100 + TU_001;
TU_2 = TU_101;


%% Project start vector of traced modes into subspace
kExp = 2*pi*fExp(1)/c0;
V1 = (Q_0 + kExp * Q_1 )'*Q_ev(:,1:eigNumb);

toc

%% Save reduced model
disp(' ')
disp('Saving reduced order model...');


fName = [projectPath portName '\redMat'];


    writeMatFull(S_0, [fName '_S_0']);
    writeMatFull(S_1, [fName '_S_1']);
    writeMatFull(S_2, [fName '_S_2']);
    writeMatFull(S_3, [fName '_S_3']);
    writeMatFull(S_4, [fName '_S_4']);
    writeMatFull(T_0, [fName '_T_0']);
    writeMatFull(T_1, [fName '_T_1']);
    writeMatFull(T_2, [fName '_T_2']);
    writeMatFull(TU_0, [fName '_TU_0']);
    writeMatFull(TU_1, [fName '_TU_1']);
    writeMatFull(TU_2, [fName '_TU_2']);
    writeMatFull(V1, [fName '_V1']);

fName = [projectPath portName '\projMat'];
    
    Q_0 = dirMat' * Q_0;
    Q_1 = dirMat' * Q_1;

    writeMatFull(Q_0, [fName '_Q0']);
    writeMatFull(Q_1, [fName '_Q1']);

