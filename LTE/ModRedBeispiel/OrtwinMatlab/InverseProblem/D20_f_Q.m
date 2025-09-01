% Test if Q*f=const law holds for D20 material

close all;
clear all;

slope = (0.00265-0.00175)/12e9;
epsImag8 = (0.00175+slope*10e9)*10.2

filename = 'C:\work\examples\wg_perm_sym\D20_f_Q.txt';
fid = fopen(filename,'r');
data = fscanf(fid,'%g  %g', [2 inf]);
fclose(fid);

f = data(1,:);
Q = data(2,:);
plot(f,Q, 'ro');
grid;
hold

epsImag = -20./Q;
% 
freq = f(1):(f(end)-f(1))/100:14e9;
% % p = polyfit(f, epsImag, 2)
% % epsF = p(3)+p(2)*freq+p(1)*(freq.^2);
p = polyfit(f, epsImag, 1)
epsF = p(2)+p(1)*freq;

Qapx = -20./epsF;
plot(freq, Qapx);

figure;
plot(f, epsImag, 'ro');
hold;
epsF = p(2)+p(1)*freq;
plot(freq, (epsF));
grid;
