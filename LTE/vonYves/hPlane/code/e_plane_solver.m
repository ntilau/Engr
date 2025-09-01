% -------------------------------------------------------
% E-plane solver 
% -------------------------------------------------------

clear all;
close all;

% -------------------------------------------------------
% declare global variables
% -------------------------------------------------------
global project
global scalarOrder vectorialOrder 
global scalarDim vectorialDim 
global stiffMatrix massMatrix
global systemMatrix rhs
global solution excitation
global omega E0
global epsilon_0 mu_0

% -------------------------------------------------------
% define variables
% -------------------------------------------------------
% set switches
ON = true;
OFF = false;
% set name and path for project files
projectName = 'e_plane';

showMesh = OFF;
showMovie = ON;
storeMovie = OFF;
storeFsMovie = OFF;
writeReflectionDataFile = OFF;
plotReflectionData = OFF;

% Simulation of H-Plane problems
hPlaneFlag = ON;


% set start and end of frequency range
start_f = 160e6;
end_f = 240e6;

% set number of movie-frames per oscillation 
nrOfFrames = 8;

% set system order
order = 1;

% set number of frequency steps
freqSteps = 1;

% define physical constants
epsilon_0 = 8.854e-12;
mu_0 = 4*pi*1e-7;


% scalar basis functions order (x-components of E)
scalarOrder = order;
% vectorial basis functions order (y,z-components of E)
vectorialOrder = order;

% calculate degrees of freedom in one element
scalarDim = spaceDim(scalarOrder, 's');
vectorialDim = spaceDim(vectorialOrder, 'v');

% -------------------------------------------------------
% read project data
% -------------------------------------------------------
project = projectReader(projectName);

% -------------------------------------------------------
% important system sizes
% -------------------------------------------------------
% whole system matrix size
sysMatDim = project.geo.domain.overallDim;

% number of non-port variables
nonPortVarDim = project.geo.domain.nonPort.scalarDim + project.geo.domain.nonPort.vectorialDim;

% number of ports carrying transfinite elements
[tmp portDim] = size(project.geo.domain.port);

% initialize system matrices
systemMatrix = sparse(sysMatDim, sysMatDim);
massMatrix = sparse(sysMatDim, sysMatDim);
stiffMatrix = sparse(sysMatDim, sysMatDim);

% -------------------------------------------------------
% set excitation parameters
% -------------------------------------------------------
% amplitude of incident wave
a0 = 1;
% define on which port the incident wave should occur
portNr = 1;

% initialise S-parameter matrix
S = zeros(portDim);

% initialsise matrix R to store reflection coefficients
R = zeros(freqSteps, 3);

% -----------------------------------------------------------
% calculate S-parameters at distinct frequencies
% -----------------------------------------------------------

% -------------------------------------------------------
% assemble stiffness and mass matrix
% -------------------------------------------------------
fprintf('\nSystem matrix assembly...\n');
tic
stiffMassMatrixAssembly;

% impose dirichlet boundary conditions in main equation system
imposeDirichlet;
assembling_time = toc;

% start measurement for solving time
tic

for freqStepCnt = 1:freqSteps;
      
    % print status message on command line
    msg = sprintf('\nFrequency step: %d of %d steps\n', freqStepCnt, freqSteps);    
    fprintf(msg);
    
    % calculate actual frequency
    if freqStepCnt == 1
        f = start_f;
    else
        f = start_f + (freqStepCnt-1) * (end_f - start_f) / (freqSteps - 1);
    end
    
    % angular frequency and wavenumber
    omega = 2*pi*f;  
    k0_square = omega^2 * epsilon_0 * mu_0;    
    
    % -------------------------------------------------------
    % assemble system matrix
    % -------------------------------------------------------
    systemMatrix = stiffMatrix + k0_square * massMatrix;
    
    % -----------------------------------------------------------
    % calculate electrical field amplitude for TE10-mode
    % -----------------------------------------------------------
    E0 = getEAmplitude(project);
    
    % ---------------------------------------
    % induce modal functions
    % --------------------------------------- 
    C = getModeCoeffMatrix;
    sysMatReduced = C' * systemMatrix * C;
    
    % new size of reduced system matrix
    [tmp sysMatRedDim] = size(sysMatReduced); 

    % ---------------------------------------    
    % add reaction matrix D to system matrix
    % ---------------------------------------    
    D = sparse(sysMatRedDim, sysMatRedDim);
    D((nonPortVarDim + 1):sysMatRedDim, (nonPortVarDim + 1):sysMatRedDim) = eye(portDim); 

    sysMatReduced = sysMatReduced + j * omega * mu_0 * D;
        
    % ---------------------------------------
    % define excitation vector on right hand side
    % ---------------------------------------    
    excitation = sparse(sysMatRedDim,1);
    excitation(nonPortVarDim + portNr, 1) = a0;

    % calculate right hand side
    rhs = 2 * j * mu_0 * omega * excitation;

    % calculate solution
    solution = sysMatReduced \ rhs;
    
    % calculate corresponding S-matrix column
    S(:,portNr) = getSMatrixColumn;
    
    % store magnitude of reflection factor
    R(freqStepCnt,1) = f;                           % actual frequency
    R(freqStepCnt,2) = abs(S(1,1));                 % magnitude
    R(freqStepCnt,3) = 20 * log10(abs(S(1,1)));     % magnitude(dB)

    % ---------------------------------------
    % plot field and/or play movie
    % ---------------------------------------
    if nrOfFrames && (showMovie || storeMovie)
        % plot field for excitation on port 1
        if portNr == 1

            a = zeros(portDim,1);
            a(portNr,1) = a0;
            b = S(:,1);
            
            % get modal function coefficients for plotting field on ports
            modalCoeffs = zeros((project.geo.domain.overallDim - nonPortVarDim),1);
            for i=1:portDim
                % extract mode coefficients out of C-matrix
                modalCoeffs = modalCoeffs + (a(i) + b(i)) * C((nonPortVarDim + 1):end,(nonPortVarDim + i));
            end
            
            fieldSolution = [solution(1:(end-portDim)); modalCoeffs];
            
            % create matrix of phase-shifted solution vectors
            solutionMatrix = zeros(sysMatDim,nrOfFrames);         
            for frameCnt = 1:nrOfFrames
                solutionMatrix(:,frameCnt) = fieldSolution * exp(j * pi * 2 * (frameCnt -1) / (nrOfFrames));
            end
            
            [frames figHandle] = showSolution(solutionMatrix, showMesh);

            if showMovie && nrOfFrames > 1
                playMovie(frames, figHandle);
            end      
        end
    end
    
    
    % create frames for frequency-shift movie
    % (one oscillation per frequency step)
    if storeFsMovie
        if freqStepCnt == 1
            % play two movies per frequency
            freqShiftFrames = [frames];
        elseif freqStepCnt > 1
            freqShiftFrames = [freqShiftFrames frames];
        end
    end
      
end
% stop measurement of solving time
solving_time = toc;

% store movie
if storeMovie
    movieFileName = sprintf('..\\movies\\%s_order_%d.avi', projectName, order);
    movie2avi(frames, movieFileName, 'compression', 'None');
end

% store freqency-shift movie
if storeFsMovie
    fsMovieFileName = sprintf('..\\movies\\%s_order_%d_freqShift.avi', projectName, order);
    movie2avi(freqShiftFrames, fsMovieFileName);
end

% write reflection coefficient data to file
if writeReflectionDataFile
    plotFile = sprintf('..\\plots\\%s_order_%d.dat', projectName, order);
    dlmwrite(plotFile, R, '\t');
end

% plot magnitude of s-parameters
if plotReflectionData    
    figure
    plot(R(:,1),R(:,3));
end

% print duration of calculations on standard output
printCalcData(project, assembling_time, solving_time);


