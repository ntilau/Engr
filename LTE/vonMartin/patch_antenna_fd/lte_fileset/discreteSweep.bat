@echo off
set OLD_NUM_THREADS=%OMP_NUM_THREADS%
set OMP_NUM_THREADS=2
for /L %%N IN (2800, 4, 3200) DO ( 
 EM_WaveSolver 3d %%Ne6 -out p -dx
)
set OMP_NUM_THREADS=1
EM_WaveModelReduction 3d 3e9 2.8e9 3.2e9 1001 100 -out p > logMOR.txt 2>&1
set OMP_NUM_THREADS=%OLD_NUM_THREADS%

