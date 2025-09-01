% clear;
% close all;

N = 91;
er1max=9;
er2max=9;
a = 22.86 * 1e-3;
b = 10.16 * 1e-3;
d1 = 15 * 1e-3;
d2 = 5 * 1e-3;
d3 = 5 * 1e-3;
mr1 = 1;
mr2 = mr1;

f=11e9;

for i=1:N
    for j=1:N
        er1(i,j) = (er1max-1)*(i-1)/(N-1)+1;
        er2(i,j) = (er2max-1)*(j-1)/(N-1)+1;
        G(j,i) = analyticTwoDiel(a,b,d1,d2,d3,er1(i,j),mr1,er2(i,j),mr2,f);
    end
end

figure;
%subplot(1,2,1);
surf (er1,er2,abs(G));
shading('interp');
view([0,90]);
xlabel('\epsilon_{r2}');
ylabel('\epsilon_{r1}');
