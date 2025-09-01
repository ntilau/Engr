% This script builds the ROM
close all;
clear all;

tic

order = 15;

%% Read files

modelName = 'C:\work\examples\coaxParam\coaxParam_1e+008_MU_RELATIVE_3_(1,0)_10\';
modelName = 'C:\work\examples\coax2\coax2_1e+009_MU_RELATIVE_74_(1,0)_2\';
modelName = 'C:\work\examples\coaxParam\coaxParam_1e+008_EPSILON_RELATIVE_3_(4,0)_2\';
modelName = 'C:\work\examples\patch_antenna\patch_antenna_6e+009_EPSILON_RELATIVE_Box1_(4,0)_EPSILON_RELATIVE_Box2_(3,0)_3\';
modelName = 'C:\work\examples\coax2\coax2_2e+009_EPSILON_RELATIVE_74_(4,0)_4\';
modelName = 'C:\work\examples\lump_port_test\wg3_1e+008_EPSILON_RELATIVE_3_(4,0)_3\';
modelName = 'C:\work\examples\bga_ifx_1_4p_lossy\bga_ifx_1_4p_lossy_5e+009_5\';
modelName = 'C:\work\examples\lump_port_test\lump_port_test_modRed\wg3_1e+008_3\';

buildRedModelTranspBC(modelName, order);

toc
