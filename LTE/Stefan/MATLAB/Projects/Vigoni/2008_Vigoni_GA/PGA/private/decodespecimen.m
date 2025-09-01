function v = decodespecimen( p, igen, ispec )
%DECODESPECIMEN Summary of this function goes here
%   Detailed explanation goes here

s = p.population.specimens{igen}{ispec};
first = 1;
last  = 0;
for i = 1:p.phenotype.Npar
    bits = p.phenotype.N{i};
    last = last + bits;
    ss = s(first:last);
    first = first + bits;
    aux = bin2dec(ss)/(2^bits-1);
    v(i) = (p.phenotype.max{i}-p.phenotype.min{i})*aux + p.phenotype.min{i};
end
    
    