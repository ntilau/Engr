function y = eigs_handle(x) % function handle

global S;
global T;
global sigma;

y  = (S-sigma*T)\(T*x) ;   % calc x/D_lambda

% orthogonalize
global oMult;
global oInv;

y = oInv \ (oMult * y);

end
