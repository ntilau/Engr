function [ eigVal2D, eigVec2D ] = evaluateReducedModel2D(projectPath, portName, fEval, eigNumb)


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

%             Model Evaluation

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

projStr = [portName];
dirStr = [projectPath];
f2 = fEval;


c0 = 299792.458e3;
k2 = 2*pi*f2/c0;


%% Load Reduced Model


fName = [ dirStr projStr ];

S_0 = readMatFull([fName '\redMat_S_0']);
S_1 = readMatFull([fName '\redMat_S_1']);
S_2 = readMatFull([fName '\redMat_S_2']);
S_3 = readMatFull([fName '\redMat_S_3']);
S_4 = readMatFull([fName '\redMat_S_4']);
T_0 = readMatFull([fName '\redMat_T_0']);
T_1 = readMatFull([fName '\redMat_T_1']);
T_2 = readMatFull([fName '\redMat_T_2']);
TU_0 = readMatFull([fName '\redMat_TU_0']);
TU_1 = readMatFull([fName '\redMat_TU_1']);
TU_2 = readMatFull([fName '\redMat_TU_2']);
V1 = readMatFull([fName '\redMat_V1']);
% 
TU_red = TU_0 + k2(1) * TU_1 + k2(1)^2 * TU_2;



% [S_red, T_red] = computeST(k2(1), S_0, S_1, S_2, S_3, S_4, T_0, T_1, T_2);
% [V1,D] = eig(S_red, T_red);
for n1=1:length(V1(1,:)), V1(:,n1)=V1(:,n1)/sqrt(V1(:,n1).'*TU_red*V1(:,n1));
end


eigVec2D = [  ];
eigVal2D = [  ];

tic
%-------------------------------------------------------------------------
' Compute fast frequency sweep 2D'
for n=1:length(f2),
%     f2(n)

    % Solve eigenvalue problem of reduced model
    [S_red, T_red] = computeST(k2(n), S_0, S_1, S_2, S_3, S_4, T_0, T_1, T_2);
    [V,D] = eig(S_red, T_red);
    ev_square = diag(D);
    ev(n,:) = sqrt(ev_square);

%------------------------------------------
%     % compute residual
%     vv = Q_0 * V + Q_1 * V * k2(n);
%     for n1=1:length(V(1,:)), vv(:,n1)=vv(:,n1)/norm(vv(:,n1), 2);
%     end
%     res = S_k0 * vv + S_k1 * vv * k2(n) + S_k2 * vv * k2(n)^2 - T_k0 * vv * D;
%     for m = 1:length(ev(1,:))
%         rr(m, n) = norm(res(:,m), 2) / norm(vv(:,m), 2);
%     end

%------------------------------------------
    % Eigenmode traceing
    TU_red = TU_0 + k2(n) * TU_1 + k2(n)^2 * TU_2;
    for n1=1:length(V(1,:)), V(:,n1)=V(:,n1)/sqrt(V(:,n1).'*TU_red*V(:,n1));
    end
    VL= V.'*TU_red*V1;
    for n1=1:length(VL(1,:)),
        [Y,eigIndexTemp] = max(abs(VL(:,n1)));
        eigIndex(n,n1)=-1;
        doesExist =  find( eigIndex(n,:)== eigIndexTemp );
        if isempty(doesExist) ~= 1,
            sprintf('it happens!!!')
            f2(n)
            VL(eigIndexTemp,n1)=0;
            [Y,eigIndex(n,n1)] = max(abs(VL(:,n1)));
%             eigIndex(n,n1)= eigIndexTemp;
        else
%             sprintf('it happens!!!');
            eigIndex(n,n1)= eigIndexTemp;
        end
    end
    TraceCoeff(n).Frequency = V.'*TU_red*V1;    % Save Trace coefficients
    
    V1=V(:,eigIndex(n,:));
    
    for eigCount = 1:length(VL(1,:)),
        eigVec(:,eigCount) = V(:,eigIndex(n,eigCount)) ;
        eigVal(:,eigCount) = ev(n,eigIndex(n,eigCount)) ;
    end
    eigVec2D = [eigVec2D eigVec  ];
    eigVal2D = [eigVal2D eigVal  ];
% *************************************************************************   
% *************************************************************************
% Achtung Plot
% *************************************************************************
% *************************************************************************
% figure(77);
% 
%     subplot(2,1,1);
%     hold on;
%     plot(f2(n), -imag(ev(n,:)),'.');
%     hold off;
%     subplot(2,1,2);
%     hold on;
%     plot(f2(n), -real(ev(n,:)),'.');
%     hold off;
% *************************************************************************  
% *************************************************************************
% Achtung Plot
% *************************************************************************
% *************************************************************************    
end

%--------------------------------------------------------------------------
%Adding dirichlet values

% D_Vector = vectorReader([dirStr projStr '\d' ]);
% 
% InvDirPos = find(D_Vector==0);
% V_ev = V_ev(InvDirPos,:);




% % -----------------------------------------------------------------------
% % -----------------------------------------------------------------------
% % Save Reduced Model
% 
% % -----------------------------------------------------------------------
% % -----------------------------------------------------------------------

time2=toc;
sprintf('Model evaluation time: %f', time2)

%     writeMatFull(ev, [fName '\redEV']);
%     writeMatFull(eigIndex, [fName '\redEigIndex']);
    
%     sprintf('finished writing')




