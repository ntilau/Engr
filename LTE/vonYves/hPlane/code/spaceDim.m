% SPACEDIM calculates the function space dimension (degrees of freedom)
% syntax: DIM = SPACEDIM(ORDER, KINDOFFUNCTION)
% 
% string KINDOFFUNCTION specifies whether the functions
% are scalar (KINDOFFUNCTION = 's') or 
% 2D-vectorial (KINDOFFUNCTION = 'v')
% int ORDER is the order of the regarded functions

function dim = spaceDim(order, kindOfFunction)


if strcmp(kindOfFunction, 's')
    if order
        dim = (order + 1)*(order + 2)/2;
    else
        dim = 0;
    end
elseif strcmp(kindOfFunction, 'v')
    switch order
        case 0
            dim = 0;
        case 1
            dim = 3;
        case 2
            dim = 8;
        case 3
            dim = 15;
    end
else
    error('%s is not a valid parameter for function spaceDim', kindOfFunction);
end