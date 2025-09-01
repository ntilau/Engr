function P = PUwInverse(U, w, m, n)


P = U(w : (n - m + w - 1), w : (n - m + w - 1));
for t = (w + 1) : m
  P = U(t : (n - m + t - 1), t : (n - m + t - 1)) * P;
end


