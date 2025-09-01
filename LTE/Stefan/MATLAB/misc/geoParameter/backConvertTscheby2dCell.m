function d = backConvertTscheby2dCell(a1, b1, a2, b2, c)
% input parameters:
%    a1 = lower bound of x-interval
%    b1 = upper bound of x-interval
%    a2 = lower bound of y-interval
%    b2 = upper bound of y-interval
%    c = two dimensional cell array containing coefficient vectors 
%        of Tschebyscheff polynomials
%
% output parameter:
%    d = coefficients of polynomials 1, x, x^2, ...

[numS1Pnts numS2Pnts] = size(c);

d1 = cell(numS1Pnts, numS2Pnts);
for rowCnt = 1:numS1Pnts
  for colCnt = 1:numS2Pnts
    d1{rowCnt, colCnt} = zeros(length(c{rowCnt, colCnt}), 1);
  end
end

for s1Cnt = 1:numS1Pnts
  n  = numS2Pnts;
  dd = cell(n, 1);
  for colCnt = 1:numS2Pnts
    dd{colCnt} = zeros(length(c{rowCnt, colCnt}), 1);
  end

  d1{s1Cnt, 1} = c{s1Cnt, end};

  for j = (numS2Pnts - 2):-1:1
    for k = (n - j):-1:1
      sv = d1{s1Cnt, k+1};
      d1{s1Cnt, k + 1} = 2 * d1{s1Cnt, k} - dd{k + 1};
      dd{k + 1} = sv;
    end
    sv = d1{s1Cnt, 1};
    d1{s1Cnt, 1} = -dd{1} + c{s1Cnt, j + 1};
    dd{1} = sv;
  end

  for j = (n - 1):-1:1
    d1{s1Cnt, j + 1} = d1{s1Cnt, j} - dd{j + 1};
  end

  d1{s1Cnt, 1} = -dd{1} + 0.5 * c{s1Cnt, 1};

  % take interval [a,b] into account
  cnst = 2 / (b2 - a2);
  fac = cnst;
  for j = 1:1:(n - 1)
    d1{s1Cnt, j + 1} = d1{s1Cnt, j + 1} * fac;
    fac = fac * cnst;
  end
  cnst = 0.5 * (a2 + b2);
  for j = 0:1:(n-2)
    for k = (n-2):-1:j
      d1{s1Cnt, k + 1} = d1{s1Cnt, k + 1} - cnst * d1{s1Cnt, k + 2};
    end
  end
end


d = cell(numS1Pnts, numS2Pnts);
for rowCnt = 1:numS1Pnts
  for colCnt = 1:numS2Pnts
    d{rowCnt, colCnt} = zeros(length(c{rowCnt, colCnt}), 1);
  end
end

for s2Cnt = 1:numS2Pnts
  n  = numS1Pnts;
  dd = cell(n, 1);
  for colCnt = 1:numS1Pnts
    dd{colCnt} = zeros(length(c{rowCnt, colCnt}), 1);
  end

  d{1, s2Cnt} = d1{end, s2Cnt};

  for j = (numS1Pnts - 2):-1:1
    for k = (n - j):-1:1
      sv = d{k+1, s2Cnt};
      d{k + 1, s2Cnt} = 2 * d{k, s2Cnt} - dd{k + 1};
      dd{k + 1} = sv;
    end
    sv = d{1, s2Cnt};
    d{1, s2Cnt} = -dd{1} + d1{j + 1, s2Cnt};
    dd{1} = sv;
  end

  for j = (n - 1):-1:1
    d{j + 1, s2Cnt} = d{j, s2Cnt} - dd{j + 1};
  end

  d{1, s2Cnt} = -dd{1} + 0.5 * d1{1, s2Cnt};

  % take interval [a,b] into account
  cnst = 2 / (b1 - a1);
  fac = cnst;
  for j = 1:1:(n - 1)
    d{j + 1, s2Cnt} = d{j + 1, s2Cnt} * fac;
    fac = fac * cnst;
  end
  cnst = 0.5 * (a1 + b1);
  for j = 0:1:(n-2)
    for k = (n-2):-1:j
      d{k + 1, s2Cnt} = d{k + 1, s2Cnt} - cnst * d{k + 2, s2Cnt};
    end
  end
end

