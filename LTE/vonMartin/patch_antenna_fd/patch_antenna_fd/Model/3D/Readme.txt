
Rectangular Patch Antenna  
-------------------------

General Description 

   This example shows a rectangular patch antenna. It demonstrates 
   the usage of open boundary conditions for antennas and farfield 
   monitors with the frequency domain solver. 
   The results are mainly focused on the farfield radiation pattern 
   and S-parameters of the antenna. 
   Like the tutorial example of a patch antenna this antenna can also 
   be easily expanded into a patch antenna array.

   The same structure has also been simulated with the General Purpose
   HEX FD solver.

Structure Generation
   
   The structure can be defined using basic elements. The ground, the 
   substrate and the patch shape are constructed with bricks. The 
   inner feed and the inner conductor shape are cylinder shapes. 
   Due to structure's symmetry a magnetic symmetry plane at the XZ 
   plane can be introduced. Please note that this speeds up the solver
   because only one half of the structure has to be calculated now, 
   while the results remain exactly the same. 
   The boundary condition was chosen to be open (add space) opposite to the
   ground plane and electric at the ground plane. The other boundary
   conditions are open. The advantage of the "open (add space)" boundary
   condition is that an adequate distance from the patch to the boundary is
   set automatically.

   This example also demonstrates parametric construction. Therefore the    
   following parameters have been defined:
   
   Patch_length: 3.0 cm
   Patch_width:  2.7 cm
   x_shift:      0.3 cm
   y_shift:      0.0 cm

   It allows you to change the properties of the structure easily. 

   Note:
   When changing the y_shift parameter to a nonzero value, you 
   also have to switch off the magnetic symmetry plane. 

Solver Setup

   In order to obtain the farfield radiation pattern a farfield monitor at 
   the resonance frequency was defined. At the same frequency, E- and H-field
   monitors were defined. The adaptive mesh refinement frequency was moved to
   the frequency at which the monitors were defined, and the maximum number of 
   adaptation passes was set to twelve.
   Since otherwise the default settings are used, the broadband frequency sweep 
   is enabled.
   
Post Processing

   The resulting scattering parameters can be accessed through the "1D 
   Result" folder in the navigation tree. Select "2D/3D Results\E-Field\ 
   e-field (f=2.98)[1]" to see the calculated electric field or "2D/3D 
   Results\H-Field\h-field (f=2.98)[1]" for the magnetic field at the resonance
   frequency of the filter. The farfield radiation pattern can be opened under
   "Farfields\farfield (f=2.98)[1]". 


