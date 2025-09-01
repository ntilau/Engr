function [fig_h, realax_h, imax_h] = plotImpedance(f, zMat, row, col)

Z = sortNetworkParamsByPorts(zMat);
fig_h = figure('position', [200, 200, 600, 600], 'Name', 'Impedance plot');
% plot real part of Z(row, col)
realax_h = subplot(2, 1, 1);
plot(f, real(Z{row, col}));
ylabel(sprintf('real(Z_{%d%d})', row, col));
xlabel('frequency (GHz)');

% plot imaginary part of Z(row, col)
subplot(2, 1, 2);
imax_h = plot(f, imag(Z{row, col}));
ylabel(sprintf('imag(Z_{%d%d})', row, col));
xlabel('frequency (GHz)');


