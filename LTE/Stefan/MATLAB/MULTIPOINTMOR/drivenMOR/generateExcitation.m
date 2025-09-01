function [ rhsAVPact, evVectorAVP ] = generateExcitation(projectPath, portName, f0, numModes );


constants;

k0 = 2*pi*f0/c0;


%% compute eigenmode solutions
%--------------------------------------------------------------------------


    system(['cd ' projectPath portName ' & EM_eigenmodesolver2d '  portName ' ' ...
        num2str(f0) ' ' num2str(numModes) ' +SingleLevelCoupling writeMatrices +pg +o \w' ] );
    
    correspondence = [projectPath portName '\' portName '.num'];
    [nat2actPort, act2natPort ] = numReader( correspondence ) ;

    vectorName = [projectPath portName '\' portName '.2D_3D'];
    [evVectorAVP, EVMatrixAVP ] = evSolutionReader( vectorName ) ;

    T_AVP = MatrixMarketReader( [projectPath portName '\mat_1'] );
  

%% compute integral (w times H)
%--------------------------------------------------------------------------
disp(' ')
disp('Compute 3D exitation ...');


for kMode = 1:numModes
    rhsAVPnat = EVMatrixAVP(:,kMode)  ;
    for ll = 1:length(rhsAVPnat),
        rhsAVPact( nat2actPort(ll)+1, kMode ) = rhsAVPnat(ll); % Achtung + 1
    end

%     rhsAVP(:,kMode) = - evVectorAVP(kMode) * T_AVP * rhsAVPact.' / u_0 ;
%     alpha(kMode) = i*c0* evVectorAVP(kMode)*k0* rhsAVPact * T_AVP * rhsAVPact.' / u_0 ; 
end



