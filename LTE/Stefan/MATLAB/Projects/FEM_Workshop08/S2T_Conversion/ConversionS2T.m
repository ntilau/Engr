%--------------------------------------------------------------------------
%       conversion of scatter matrices to transmission matrices
%--------------------------------------------------------------------------

clear ;
close all ;
clc ;


%  to get the scatter matrices for the different frequencies
run ('C:\work\MATLAB\Projects\FEM_Workshop08\S2T_Conversion\S_Parameter_HFSS');

% with H differnet scatter matrices
% with N different frequencies
% with an m x n matrix for each frequency 
[m,n,H,N] = size(S);


% only for quadratic matrices useable
if m ~= n
    error('no quadratic matrices')
end

%--------------------------------------------------------------------------
%     building of the 2x2 scatter-matrices (S_11, S_12, S_21, S_22)
%--------------------------------------------------------------------------

S_11 = S(1:1:n/2     ,1:1:n/2    ,:,:);
S_22 = S((n/2+1):1:n ,(n/2+1):1:n,:,:);
S_21 = S((n/2+1):1:n ,1:1:n/2    ,:,:);
S_12 = S(1:1:n/2     ,(n/2+1):1:n,:,:);

% initialise the matrices T, T_mult, S_mult and A

T=zeros(m,n,H,N);
T_mult=zeros(m,n,N);
S_mult=zeros(m,n,N);
A=zeros(m,n,N);
HLmatrix = zeros(m,n,N,H-1);

U = zeros(m,n,N);
J = zeros(m,n,N);

for k=1:1:size(S,4)
    for h=1:1:size(S,3)
        
        %------------------------------------------------------------------
        % conversion of the mxn scatter matrices S_i to the mxn 
        %              transmission matrice T_i
        %------------------------------------------------------------------
        
        T(:,:,k,h)=[inv(S_21(:,:,h,k))                                           , ...
                   -inv(S_21(:,:,h,k))*S_22(:,:,h,k)                             ; ...
                    S_11(:,:,h,k)*inv(S_21(:,:,h,k))                             , ...
                    S_12(:,:,h,k)-S_11(:,:,h,k)*inv(S_21(:,:,h,k))*S_22(:,:,h,k)];
                
        if h==1
            % if the scattering matrices have the dimension of h==1
            A(:,:,k)=T(:,:,k);
            
        else
            
            %--------------------------------------------------------------
            %                   implicate the waveguide
            %--------------------------------------------------------------
            
            for d=1:1:n
                for f=1:1:n
                    if h == 1
                        % do nothing
                    else    
                        if d == f
                            if d<=n/2
                                HLmatrix(d,d,k,h-1) = exp(i*HL_Parameter(1,f,h-1,k)*HL_Parameter(2,f,h-1,k));
                            else
                                HLmatrix(d,d,k,h-1) = 1;
                            end   
                        end
                    end
                end
            end
            
            %--------------------------------------------------------------
            % multiply the transmission matrices T_i --> T_mult
            %--------------------------------------------------------------
            
            T_mult(:,:,k)=A(:,:,k)*HLmatrix(:,:,k)*T(:,:,k);
            A(:,:,k)= T_mult(:,:,k);
            
        end
    end
        %------------------------------------------------------------------
        % building of the 2x2 transmission matrices(T_11, T_12, T_21, T_22)
        %------------------------------------------------------------------
        
        T_mult_11 = T_mult(1:1:n/2     ,1:1:n/2    ,:);
        T_mult_22 = T_mult((n/2+1):1:n ,(n/2+1):1:n,:);
        T_mult_21 = T_mult((n/2+1):1:n ,1:1:n/2    ,:);
        T_mult_12 = T_mult(1:1:n/2     ,(n/2+1):1:n,:);
        
        %------------------------------------------------------------------
        % conversion of the mxn transmission matrices T_mult_i to the mxn 
        %                  scattering matrices S-mult_i
        %------------------------------------------------------------------
        
        S_mult(:,:,k)=[T_mult_21(:,:,k)*inv(T_mult_11(:,:,k))                                    ,   ...
                       T_mult_22(:,:,k)-T_mult_21(:,:,k)*inv(T_mult_11(:,:,k))*T_mult_12(:,:,k)  ;   ...
                       inv(T_mult_11(:,:,k))                                                     ,   ...
                      -inv(T_mult_11(:,:,k))*T_mult_12(:,:,k)]                                   ;
                  
        %------------------------------------------------------------------          
        % verify, if the absolute values of the scattering matrix entries 
        %                     are smaller than one
        %------------------------------------------------------------------
        
       if max(max(abs(S_mult(:,:,k))))  >=  1
           error ('absolute values of the scattermatrix entries are bigger than one')
       end
       
       %-------------------------------------------------------------------   
       %       verify, if the scattering matrix S_mult is symmetric
       %-------------------------------------------------------------------
       
       summe = sum(sum(abs(S_mult(:,:,k).' - S_mult(:,:,k))));
       if  summe >= 5e-05
           error('scattering matrix S_mult is not symmetric')
       end       
end
