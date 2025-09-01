
Dielectric Resonator Filter
---------------------------

General Description

   This filter is build up by a metallic box, including two 
   cylindrical, dielectric insertions. Elongated inner 
   conductors of two coaxial lines are the input and the output 
   of the structure. 
   The two dielectric discs act as coupled resonators such that the
   entire device becomes a high quality band pass filter.
   
   This example demonstrates the fast frequency sweep.
   
   The same structure has also been simulated with the General Purpose
   HEX FD solver, the Resonant: Fast S-parameter solver and with the 
   Time Domain solver. These examples can be found in the subfolders 
   "Frequency Domain Analysis" and "Transient Analysis".
   
Structure Generation
   
   The most important parts of the structure are modelled by cylinders.
   The coaxial lines as well as the dielectric discs are of cylindrical
   shape. Only the metallic ground plane where the coaxial ports are
   located and the surrounding space are bricks. For the real world
   structure there is a metallic box that encloses the structure. For the
   simulation, this box is omitted, because it can be simulated by 
   electric boundary conditions.
   
Solver Setup

   Because of the symmetry of the structure a magnetic symmetry condition
   is used (Only one half of the structure needs to be simulated to obtain
   the results of the entire structure).
   This exanple is simulated using the frequency domain solver with 20 
   frequency samples in the range from 4.5 GHz to 4.6 GHz.
   The broadband frequency sweep is enabled. The solver reaches the 
   scattering parameter convergence threshold (0.01 as a default) after 
   calculating nine frequency samples.
   The progression of the scattering parameter sweep error measure is show 
   in the "1D Results\Convergence\S-Parameter" folder.

Post Processing

   The scattering parameters can be accessed through the "1D Results" folder
   in the navigation tree.
   The results of the frequency domain S-parameter calculation can be compared 
   to those obtained by the other frequency domain solvers as well as the time
   domain calculation by copying the signals into a user defined tree folder
   (for more information have a look at the topic "1D Result View" in the
   MWS online help).
