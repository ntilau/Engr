function epsilon = computeEpsilon(f)

%epsilon = 0.0095*(1e10-f)/(1e10-1e6) + 0.018*(f-1e6)/(1e10-1e6);
epsilon = 4.9*(1e10-f)/(1e10-1e6) + 4.7*(f-1e6)/(1e10-1e6);
