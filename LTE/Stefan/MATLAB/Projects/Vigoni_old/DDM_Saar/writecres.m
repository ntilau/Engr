function writecres(foutname,R,N,type,what)
%   R: results vector
%   N: results vector length
%   type: 1=NODAL, 2=EDGE
%   what: 1=REAL, IMAGINARY, MAGNITUDE, PHASE



fid=fopen(foutname,'w');

fprintf(fid,'Type = %5i\n',type);
fprintf(fid,'Number = %5i\n',N);
if      what=='R'   %Stores real part
    for i=1:N
        fprintf(fid,'%5i %13.6e\n',i,real(R(i)));
    end
elseif  what=='I'   %Stores imaginary part
    for i=1:N
        fprintf(fid,'%5i %13.6e\n',i,imag(R(i)));
    end
elseif  what=='M'   %Stores magnitude
    for i=1:N
        fprintf(fid,'%5i %13.6e\n',i,abs(R(i)));
    end
elseif  what=='P'   %stores phase
    for i=1:N
        fprintf(fid,'%5i %13.6e\n',i,angle(R(i)));
    end
end
fclose(fid);
