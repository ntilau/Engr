function plotReducedModel2D(f2, eigVal2D, numModes, kPort);




for n = 1:length(f2),
for kMode = 1:numModes,
%     eValue(kMode, n)  = abs(real(eigVal2D(:, (n-1)*numModes + kMode ))) + i*abs(imag(eigVal2D(:, (n-1)*numModes + kMode )));
    eValue(kMode, n)  = eigVal2D(:, (n-1)*numModes + kMode );
end
end


figure(50+kPort);
for kMode = 1:numModes,
subplot(2,1,1);
hold on;
plot(f2*1e-9, imag(eValue(kMode,:)));
xlabel('Frequency (GHz)','FontSize',12);
ylabel('|\beta (rad/m)|','FontSize',12);
hold off;
grid on;
subplot(2,1,2);
hold on;
plot(f2*1e-9, -real(eValue(kMode,:)));
xlabel('Frequency (GHz)','FontSize',12);
ylabel('-|\alpha (Np/m)|','FontSize',12);
hold off;
grid on;
end


% figure(50+kPort+10);
% for kMode = 1:numModes,
% subplot(2,1,1);
% hold on;
% plot(f2*1e-9, real(eValue(kMode,:)));
% xlabel('Frequency (GHz)','FontSize',12);
% ylabel('Re(\gamma^2)','FontSize',12);
% hold off;
% grid on;
% subplot(2,1,2);
% hold on;
% plot(f2*1e-9, imag(eValue(kMode,:)));
% xlabel('Frequency (GHz)','FontSize',12);
% ylabel('Im(\gamma^2)','FontSize',12);
% hold off;
% grid on;
% end


