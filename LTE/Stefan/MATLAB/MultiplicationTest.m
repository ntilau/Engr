modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_4\';

sys2 = MatrixMarketReader(strcat(modelName, 'modelMat_2'));
Kry = readMatFull(strcat(modelName, 'krylov'));
sys2Red = conj(Kry) * sys0 * Kry.'

sys3 = MatrixMarketReader(strcat(modelName, 'modelMat_3'));
sys3Red = conj(Kry) * sys3 * Kry.'

% rowKryArr2 = vectorReader(strcat(modelName, 'rowKryArr2'));
% rowKryArr = vectorReader(strcat(modelName, 'rowKryArr'));
% res = vectorReader(strcat(modelName, 'res'));
% 
% % testM = rowKryArr2'*res
% 
% % sys0 = MatrixMarketReader(strcat(modelName, 'modelMat'));
% resTest = sys0 * rowKryArr;
% max(res-resTest) / max(res)

modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_4\';

sysTest{1} = MatrixMarketReader(strcat(modelName, 'modelMat_0'));
sysTest{2} = MatrixMarketReader(strcat(modelName, 'modelMat_1'));
sysTest{3} = MatrixMarketReader(strcat(modelName, 'modelMat_2'));
sysTest{4} = MatrixMarketReader(strcat(modelName, 'modelMat_3'));
sysTest{5} = MatrixMarketReader(strcat(modelName, 'modelMat_4'));
sysTest{8} = MatrixMarketReader(strcat(modelName, 'modelMat_7'));

max(max(sysTest{2}-sysMat{2})) / max(max(sysMat{2}))
max(max(sysTest{3}-sysMat{3})) / max(max(sysMat{3}))
max(max(sysTest{4}-sysMat{4})) / max(max(sysMat{4}))
max(max(sysTest{5}-sysMat{5})) / max(max(sysMat{5}))
max(max(sysTest{8}-sysMat{8})) / max(max(sysMat{8}))

max(max(sysTest{1}-sys0)) / max(max(sys0))

max(max(Q-Kry.'./Q))

sys0Red = Q' * sys0 * Q
sys0Red2 = Q' * sysTest{1} * Q
sys0Red-sys0Red2

modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_4\';
sysRed0 = readMatFull(strcat(modelName, 'sysMatRed_2_1'));

modelName = ...
'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_EPSILON_RELATIVE_2_(1,0)_9_MatLab\';
sysRed0M = readMatFull(strcat(modelName, 'sysMatRed_2_1'));

sysRed0-sysRed0M
max(max(sysRed0-sysRed0M))

P = rand(5, 3) + j * rand(5, 3);
[U,S,V] = svd(P);
A = rand(5,5) + j * rand(5,5);
A = A + conj(A')
Ared = U' * A * U



