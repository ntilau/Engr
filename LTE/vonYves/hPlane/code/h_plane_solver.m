% -------------------------------------------------------
% H-plane solver 
% -------------------------------------------------------

clear;
close all;

format long;

%% physical constants
EPSILON_0 = 8.854e-12;
MU_0 = 4*pi*1e-7;
C_0 = 1 / sqrt(EPSILON_0 * MU_0);

%% define variables
% set name and path for project files
projectName = 'webb_filter';
projectPath = '..\Projects\webb_filter_0.005x0.01x0.04\';
% set path where system matrices should be written
resultPath  = strcat(projectPath, 'system_matrices\');
if ~isdir(resultPath)
    mkdir(resultPath);
end

showMesh                = false;
showMovie               = false;
storeMovie              = false; % save movie
writeReflectionDataFile = false;
plotReflectionData      = true;
writeSysMat             = true; % write system matrices to file
impFormFlag             = false; % solving impedance formulation

% set start and end of frequency range and steps within
startFrequency = 15e9;
endFrequency   = 30e9;
nFrequencyStep = 51;
frequency = linspace(startFrequency, endFrequency, nFrequencyStep);

% set number of movie-frames per oscillation 
nrOfFrames = 1;

% set basis function order 
order = 2;

%% read project data
project = projectreader(projectPath, projectName, order);

%% important system sizes
% number of non-port variables
nonPortVarDim = project.geo.domain.nonPort.scalarDim;
% number of ports carrying transfinite elements
portDim = size(project.geo.domain.port, 2);


%% set excitation parameters
% amplitude of incident wave
a0 = 1;

sysMatDim = project.geo.domain.overallDim;
% initialise S-parameter matrix
N = zeros(portDim);

% initialize matrix R to store reflection coefficients
R = zeros(nFrequencyStep, 3);

%% assemble stiffness and mass matrix
fprintf('\nSystem matrix assembly...\n');
tic
[stiffMatrix, massMatrix] = stiffMassMatrixAssembly(project, order);

% impose dirichlet boundary conditions in main equation system
[stiffMatrix, massMatrix, dirIndex] = imposeDirichlet(project, order, stiffMatrix, massMatrix);
assemblingTime = toc;

% start measurement for solving time
tic

for iFreq = 1:nFrequencyStep;
      
    % print status message on command line
    fprintf('\nFrequency step: %d of %d steps\n', iFreq, nFrequencyStep);        
    
    f = frequency(iFreq);
    omega = 2 * pi * f;
    k0 = omega / C_0;
    
    % -----------------------------------------------------------
    % calculate electrical field amplitude for TE10-mode
    % -----------------------------------------------------------
    E0 = getEAmplitude(project, omega);
                      
    % ---------------------------------------
    % induce modal functions
    % --------------------------------------- 
    [C portSol] = getModeCoeffMatrix(project, order, omega, E0);
    stiffMatReduced = C' * stiffMatrix * C;
    massMatReduced = C' * massMatrix * C;
    
    sysMatReduced = stiffMatReduced - k0^2 * massMatReduced;      

    % new size of reduced system matrix
    [tmp sysMatRedDim] = size(sysMatReduced); 
    
    for portCnt = 1:portDim
        % ---------------------------------------
        % define excitation vector on right hand side
        % ---------------------------------------
        excitation = sparse(sysMatRedDim,1);
        excitation(nonPortVarDim + portCnt, 1) = a0;

        % calculate right hand side
        if impFormFlag
            rhs = j / omega * MU_0 * excitation; %#ok<UNRCH>
        else
            rhs =  - 1j / omega * 2 * MU_0 * excitation;
        end

        % ---------------------------------------
        % add reaction matrix D to system matrix
        % ---------------------------------------
        D = sparse(sysMatRedDim, sysMatRedDim);
        D((nonPortVarDim + 1):sysMatRedDim, (nonPortVarDim + 1):sysMatRedDim) = eye(portDim);

        % write system matrices to file
        if writeSysMat && iFreq == 1
            if portCnt == 1
                mmwrite(strcat(resultPath, 'k^2 matrix.mm'), massMatReduced);
                mmwrite(strcat(resultPath, 'system matrix.mm'), sysMatReduced);
                mmwrite(strcat(resultPath, 'ident0.mm'), D);
            end
            writeFullVector(full(rhs), sprintf('%srhs%d.fvec', resultPath, portCnt - 1));
            writeFullVector(full(excitation), sprintf('%sleftVec%d.fvec', resultPath, portCnt - 1));
        end

        if ~impFormFlag && portCnt == 1
            sysMatReduced = sysMatReduced  - 1j / omega * MU_0 * D;
        end

        % calculate solution
        solution = sysMatReduced \ rhs;

        % calculate network matrix column
        if impFormFlag
            nonPortVarDim = project.geo.domain.nonPort.scalarDim; %#ok<UNRCH>
            N(:,portCnt) = solution((project.geo.domain.nonPort.scalarDim + 1):end);
        else
            nonPortVarDim = project.geo.domain.nonPort.scalarDim;
            N(:,portCnt) = solution((nonPortVarDim + 1):end) - excitation((nonPortVarDim + 1):end);
        end

        % compute FEM solution from TFE solution (reconstruct port fields)
        if 1 % iFreq == freqSteps
            solutionFEM = sparse(sysMatDim,1);
            solutionFEM(1:sysMatRedDim - portDim,1) = solution(1:sysMatRedDim - portDim,1);
            solutionFEM = solutionFEM + a0 * portSol{1};
            %         solutionFEM = solutionFEM + S(2,1) * portSol{2};

            %         rhsFEM = sparse(sysMatDim, 1);
            %         imposeMode;
            %
            %         solutionFEM = systemMatrix \ rhsFEM;
            %Frames = plotFEM_solution(solutionFEM, project, order);
            %movie(Frames, 10);
            %         break;
        end
        
    end % portCnt loop
    
    if impFormFlag
        S = inv(N - eye(portDim)) * (N + eye(portDim)); %#ok<UNRCH>
    else 
        S = N;
    end
    
    % store magnitude of reflection factor
    R(iFreq,1) = f;                           % actual frequency
    R(iFreq,2) = abs(S(1,1));                 % magnitude
    R(iFreq,3) = 20 * log10(abs(S(1,1)));     % magnitude(dB)

end % iFreq loop

% stop solving time clock
solving_time = toc;

% store movie
if storeMovie
    movieFileName = sprintf('..\\movies\\%s_order_%d.avi', projectName, order);
    movie2avi(frames, movieFileName, 'compression', 'None');
end

% write reflection coefficient data to file
if writeReflectionDataFile
    plotFile = sprintf('..\\plots\\%s_order_%d.dat', projectName, order);
    dlmwrite(plotFile, R, '\t');
end

% plot magnitude of s-parameters
if plotReflectionData    
    figure;
    plot(R(:,1),R(:,3), '-xr');
    xlabel('Frequency (Hz)');
    ylabel('s11 (dB)');
    
%     hold on;
%     plot(Rz(:,1),Rz(:,3), '-xr');
%     xlabel('Frequency (Hz)');
%     ylabel('s11 (dB)');
%     legend('Impedanz-Formulierung');
%     
%     figure(3);
%     plot(s_norm(:,1), s_norm(:,2), '-b');
%     xlabel('Frequency (Hz)');
%     ylabel('||s(:,1)||');   
end

% print cpu times on standard output
printCalcData(project, assemblingTime, solving_time);


