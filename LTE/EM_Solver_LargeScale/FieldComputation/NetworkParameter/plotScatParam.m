function [fig_h, realax_h, imax_h] = plotScatParam(f, sMat, row, col)

S = sortNetworkParamsByPorts(sMat);
fig_h = figure('position', [200, 200, 600, 600], 'Name', 'Scattering Parameter');
% plot magnitude S(row, col)
realax_h = subplot(2, 1, 1);
plot(f, db(abs(S{row, col})));
ylabel(sprintf('|S_{%d%d}| (dB)', row, col));
xlabel('frequency (Hz)');

% plot phase part of Z(row, col)
subplot(2, 1, 2);
imax_h = plot(f, 180 / pi * angle(S{row, col}));
ylabel(sprintf('phase(S_{%d%d}) (rad)', row, col));
xlabel('frequency (Hz)');
ylim([-180, 180]);
set(gca, 'YTick', -180:90:180);


