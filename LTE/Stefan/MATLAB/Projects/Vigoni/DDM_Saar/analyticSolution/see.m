N = 151;
ermax=9;
mrmax=9;
a = 22.86;
b = 10.16;
d1 = 10;
d2 = 7;

f=11;

for i=1:N
    for j=1:N
        er(i,j) = (ermax-1)*(i-1)/(N-1)+1;
        mr(i,j) = (mrmax-1)*(j-1)/(N-1)+1;
        G(j,i) = analytic(a,b,d1,d2,er(i,j) - 0.01 * sqrt(-1),mr(i,j),f);
    end
end

%subplot(1,2,1);
surf (er,mr,abs(G));
shading('interp');
view([0,90]);
xlabel('\mu_r');
ylabel('\epsilon_r');
