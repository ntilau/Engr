function P = PUw(U, w, m, n)

P = inv(U(w:(n - m + w - 1), w:(n - m + w - 1)));
for t = (w+1):m
  P = P * inv(U(t:(n - m + t - 1), t:(n - m + t - 1)));
end
  