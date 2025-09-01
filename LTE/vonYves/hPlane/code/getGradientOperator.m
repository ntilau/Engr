function G = getGradientOperator(scalarOrder)

% calculate degrees of freedom in one element
scalarDim = spaceDim(scalarOrder, 's');

G = zeros(scalarDim, 1);

G(1,2) = -1;
G(1,3) = -1;
G(2,1) = -1;
G(2,3) = 1;
G(3,1) = 1;
G(3,2) = 1;

if scalarOrder > 1
    G(4,6) = 1;
    G(5,7) = 1;
    G(6,8) = 1;
end

if scalarOrder > 2
    G(7,12) = 1;
    G(8,13) = 1;
    G(9,14) = 1;
    G(10,15) = 1;
end