close all;
clear all;

fileName = 'T:\Ortwin\Bertazzi_MicroStrip_half\Bertazzi_MicroStrip_halfWavePort1\Bertazzi_MicroStrip_halfWavePort1_6_2_1_0_1_1.txt';
eigVals = readResultsEigenModeSolver2D(fileName);

figure;
hold;
for k = 1:length(eigVals)
  for m = 1:length(eigVals{k}.values)
    plot(eigVals{k}.freq, abs(imag(eigVals{k}.values(m))), 'o');
  end
end
grid;


fileName = 'T:\Ortwin\Bertazzi_MicroStrip_half\Bertazzi_MicroStrip_halfWavePort1\Bertazzi_MicroStrip_halfWavePort1_5_2_1_0_1_1.txt';
eigVals = readResultsEigenModeSolver2D(fileName);

figure;
hold;
for k = 1:length(eigVals)
  for m = 1:length(eigVals{k}.values)
    plot(eigVals{k}.freq, abs(imag(eigVals{k}.values(m))), 'o');
  end
end
grid;