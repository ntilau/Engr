function sqr=naimsqrt(arg)
%select the square complex root with negative imaginary part
sqr=sqrt(arg);
if imag(sqr)>0 
    sqr=-sqr;
end