% Plot von Eigenmoden

close all;
clear all;

load 'Moden_20_1e7.mat';
figure(1);


close all;
figure(1);

hold on;
for k=1:20
ComplexPlotEM( Eigen.Freq, Eigen.Value(:,k),'.' );
end
hold off;
xlabel('Frequenz');
ylabel('-alpha bzw. beta');
title('Mode 1 bis 20');
grid on;





