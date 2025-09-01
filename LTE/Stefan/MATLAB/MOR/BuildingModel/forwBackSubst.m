function x = forwBackSubst(Fact, b, pardisoFlag)

if pardisoFlag
  [x err] = pardisoSolveLTE(Fact.mtype, Fact.iparm, Fact.pt, ...
    Fact.A_val, Fact.A_ia, Fact.A_ja, Fact.ncol, v, 0);
  if err ~= 0
    error(['Pardiso error during solving: ' err]);
  end
else
  if isfield(Fact, 'P');
    x = Fact.P * b;
  end
  x = Fact.U \ (Fact.L \ x);
  if isfield(Fact, 'Q');
    x = Fact.Q * x;
  end
end
