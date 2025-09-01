function sqr=preasqrt(arg)
%select the square complex root with positive real part
sqr = sqrt(arg);
if real(sqr) < 0 
    sqr = -sqr; 
end