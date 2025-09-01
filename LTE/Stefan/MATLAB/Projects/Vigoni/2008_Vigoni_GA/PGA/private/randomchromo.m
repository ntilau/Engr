function s = randomchromo( N )
%RANDOMCROMO Summary of this function goes here
%   Detailed explanation goes here

s = '';

for i=1:N
    s(i) = int2str(floor(2*rand));
end