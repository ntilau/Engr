%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of Eigenvalue with a modified Arnoldi Iteration that
% orthogonalises the update vector to the gradient space
%
%   function call
%      function [val, vec] = run_eigs(S, T, G, k, sigma)
%
%   input variables
%      S     ...stiffness system matrix
%      T     ...mass system matrix
%      G     ...discrete gradient operator
%      k     ...number of eigenvalues to calculate
%      sigma ...initial guess of eigenvalue
%
%   output variables
%      val   ...ordered list of all calculated eigenvalues
%      vec   ...matrix of all calculated eigenvectors (column-wise)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [vec, val] = run_eigs(S, T, G, k, sigma)

global L U P Q tmp          % make matrices available in function handle

[m, n] = size(S) ; 
[L, U, P, Q] = lu(G'*T*G) ; % make LU factorisation for efficiency
tmp = G'*T ;
[vec, val] = eigs(@eigs_handle,n,k,sigma) ; % calculate eigenvalues

    function y = eigs_handle(x, L, U, P, Q, tmp) % function handle
        global L U P Q tmp
        c  = Q*(U\(L\(P*tmp*x))) ;  % calc c = (G'*T*G)\(G'*T)
        x0 = x - (G*c) ;            % eliminate all gradients
        y  = (S-sigma*T)\(T*x0) ;   % calc x/D_lambda
    end

end