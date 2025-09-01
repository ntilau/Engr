close all;
clear all;

filename = 'C:\work\examples\coax2\coax2_1e+009_(4,0)_5\s_11_f_1e+009_3e+009_100_m_4_4_1_trans.txt';
filename = 'C:\work\examples\coax2\coax2_1e+009_(1,0)_8\s_11_f_0_2e+009_2000_m_1_1_1.txt';

[m, f, s] = readSparamMORs11(filename);
plot(f,abs(s));
