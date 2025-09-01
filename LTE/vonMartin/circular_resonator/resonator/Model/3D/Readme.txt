
Circular Resonator
------------------

General Description

   In this example the S-parameter calculation of a circular resonator
   is presented. The device consists of two strip lines rotated by 90 
   degree and connected by a ring structure.

Structure Generation

   The strip lines are constructed using solid bricks, while the connecting
   ring structure is given by a cylinder. The ground plane underneath the 
   substrate brick is represented by the electric boundary condition.
   Above the complete resonant structure some space is defined with the
   help of the background properties.

Solver Setup

   For excitation two waveguide ports are specified at the end of the strip 
   line, excited with a gaussian pulse to provide a broadband calculation 
   in the frequency range from 0 to 10 GHz.

Post Processing

   The requested S-parameters are automatically derived from the time
   signals at the two ports and are listed in the navigation tree in
   the folder '1D Results'. Regarding the absolute value of the scattering
   parameters the occurring resonances of the structure are visible.
   Furthermore the calculated port modes of the given waveguide ports can 
   be examined in the folder '2D/3D Results'.