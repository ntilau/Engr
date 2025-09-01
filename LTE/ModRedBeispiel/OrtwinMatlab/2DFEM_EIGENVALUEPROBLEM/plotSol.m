%
%
%
function plotSol(omega_calc, omega_real, Ez_calc, Ez_real, X, Y, x, proj, order)

set(0,'DefaultFigureWindowStyle','docked') ;

figure ;
plot(omega_calc,'k+') ;
hold on ;
plot(omega_real(1:x), 'ks') ;
hold off ;
legend('omega_{calc}', 'omega_{exact}') ;

for ii = 1:x
    hold on ;
    figure ;
    subplot(1, 2, 1) ; tmp = pcolor(X, Y, Ez_real(:,:,ii)) ;
    set(tmp, 'EdgeColor', 'none', 'FaceColor', 'interp') ;
    subplot(1, 2, 2) ; showPhi(Ez_calc(:,ii), proj, order) ;

end