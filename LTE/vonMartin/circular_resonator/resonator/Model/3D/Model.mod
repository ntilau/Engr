'# MWS Version: Version 2009.7 - Jun 17 2009 - 04:04:26

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0 fmax = 10


'@ use template: Planar Coupler (Microstrip, Coplanar)

' Template for Planar Coupler (Microstrip or Coplanar)
' ====================================================
' (CSTxMWSxONLY)
' draw the bounding box
Plot.DrawBox True
' set units to mm, ghz
With Units 
     .Geometry "mm" 
     .Frequency "ghz" 
     .Time "ns" 
End With 
' set background material to vacuum
With Background 
     .Type "Normal" 
     .Epsilon "1.0" 
     .Mue "1.0" 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
End With 
' set boundary conditions to electric
With Boundary
     .Xmin "electric" 
     .Xmax "electric" 
     .Ymin "electric" 
     .Ymax "electric" 
     .Zmin "electric" 
     .Zmax "electric" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
End With
' optimize mesh settings for planar structures
With Mesh 
     .MergeThinPECLayerFixpoints "True"
     .RatioLimit "50" 
     .AutomeshRefineAtPecLines "True", "4"
End With 
' change mesh adaption scheme to energy 
' 		(planar structures tend to store high energy 
'     	 locally at edges rather than globally in volume)
MeshAdaption3D.SetAdaptionStrategy "Energy"

'@ define background

With Background 
     .Type "Normal" 
     .Epsilon "1.0" 
     .Mue "1.0" 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "5" 
End With

'@ define cylinder: default:solid1

With Cylinder 
     .Reset 
     .Name "solid1" 
     .Layer "default" 
     .OuterRadius "7" 
     .InnerRadius "4" 
     .Axis "z" 
     .Zrange "0", "0.05" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ store picked point: 1

Pick.NextPickToDatabase "1" 
Pick.PickExtraCirclepointFromId "default:solid1", "4", "4", "1"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ set workplane properties

With WCS
     .SetWorkplaneSize "14" 
     .SetWorkplaneRaster "1" 
     .SetWorkplaneSnap "TRUE" 
     .SetWorkplaneSnapRaster "1" 
     .SetWorkplaneAutoadjust "TRUE" 
End With

'@ store picked point: 2

Pick.NextPickToDatabase "2" 
Pick.PickExtraCirclepointFromId "default:solid1", "4", "4", "1"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ store picked point: 3

Pick.NextPickToDatabase "3" 
Pick.PickExtraCirclepointFromId "default:solid1", "4", "4", "1"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ define brick: default:solid2

With Brick
     .Reset 
     .Name "solid2" 
     .Layer "default" 
     .Xrange "-14", "xp(3)" 
     .Yrange "yp(3) - 0.5*(0.6)", "yp(3) + 0.5*(0.6)" 
     .Zrange "0", "0.05" 
     .Create
End With

'@ transform: rotate default:solid2

With Transform 
     .Reset 
     .Name "default:solid2" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "90" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .Rotate 
End With

'@ boolean add shapes: default:solid1, default:solid2_1

Solid.Add "default:solid1", "default:solid2_1"

'@ boolean add shapes: default:solid1, default:solid2

Solid.Add "default:solid1", "default:solid2"

'@ change layer: default:solid1 to: PEC:solid1

Solid.ChangeLayer "default:solid1", "PEC"

'@ define layer: substrate

With Layer 
     .Reset 
     .Name "substrate" 
     .Type "Normal" 
     .Epsilon "10" 
     .Mue "1.0" 
     .Kappa "0.0" 
     .TangensD "0.0" 
     .FrequForTD "0.0" 
     .TangDGiven "False" 
     .Rho "0.0" 
     .Colour "0", "0.501961", "0.752941" 
     .Wireframe "False" 
     .Transparency "0" 
     .Create 
End With

'@ define brick: substrate:solid2

With Brick
     .Reset 
     .Name "solid2" 
     .Layer "substrate" 
     .Xrange "-14", "14" 
     .Yrange "-14", "14" 
     .Zrange "-0.635", "0" 
     .Create
End With

'@ define automesh state

Mesh.Automesh "True"

'@ define frequency range

Solver.FrequencyRange "0", "10"

'@ define port: 1

With Port 
     .Reset 
     .PortNumber "1" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Full" 
     .Orientation "xmin" 
     .PortOnBound "True" 
     .ClipPickedPortToBound "False" 
     .Xrange "-11", "-11" 
     .Yrange "-11", "10" 
     .Zrange "-0.635", "5.05" 
     .Create 
End With

'@ define port: 2

With Port 
     .Reset 
     .PortNumber "2" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Full" 
     .Orientation "ymin" 
     .PortOnBound "True" 
     .ClipPickedPortToBound "False" 
     .Xrange "-11", "10" 
     .Yrange "-11", "-11" 
     .Zrange "-0.635", "5.05" 
     .Create 
End With

'@ define boundaries

With Boundary
     .Xmin "magnetic" 
     .Xmax "magnetic" 
     .Ymin "magnetic" 
     .Ymax "magnetic" 
     .Zmin "electric" 
     .Zmax "magnetic" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
End With

'@ define solver parameters

Mesh.SetCreator "High Frequency" 
With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "1" 
     .StimulationMode "1" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseDistributedComputing "False" 
     .DistributeMatrixCalculation "False" 
     .MPIParallelization "False" 
     .SuperimposePLWExcitation "False" 
End With 

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "8" 
    .MeshIncrement "5.0" 
    .MaxDeltaS "0.01" 
    .NumberOfDeltaSChecks "2" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks   "2" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .SetMinimumMeshCellGrowth  "5" 
    .ErrorEstimatorType        "Automatic" 
    .RefinementType            "Quality enhancement + snap new nodes to boundary" 
    .ImproveBadElementQuality  "True" 
    .SubsequentChecksOnlyOnce  "False" 
    .WavelengthBasedRefinement "True" 
    .EnableLinearGrowthLimitation "True" 
    .SetLinearGrowthLimitation "30" 
End With


'@ define frequency domain solver parameters

Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .Method "Tetrahedral Mesh" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .NetworkComputingJobCount "3" 
     .Stimulation "1", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "8" 
     .CalculateExcitationsInParallel "True" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
     .MixedOrder "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "true" 
     .UseFastRCSSweepIntEq "true" 
     .SetRCSSweepProperties "0.0", "0.0", "0","0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.01" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "False" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
End With


'@ set tetrahedral mesh type

Mesh.MeshType "Tetrahedral" 


'@ define boundaries

With Boundary
     .Xmin "magnetic" 
     .Xmax "magnetic" 
     .Ymin "magnetic" 
     .Ymax "magnetic" 
     .Zmin "electric" 
     .Zmax "magnetic" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
     .XminThermal "isothermal" 
     .XmaxThermal "isothermal" 
     .YminThermal "isothermal" 
     .YmaxThermal "isothermal" 
     .ZminThermal "isothermal" 
     .ZmaxThermal "isothermal" 
     .XsymmetryThermal "none" 
     .YsymmetryThermal "none" 
     .ZsymmetryThermal "none" 
     .ApplyInAllDirections "False" 
     .XminTemperature "" 
     .XminTemperatureType "None" 
     .XmaxTemperature "" 
     .XmaxTemperatureType "None" 
     .YminTemperature "" 
     .YminTemperatureType "None" 
     .YmaxTemperature "" 
     .YmaxTemperatureType "None" 
     .ZminTemperature "" 
     .ZminTemperatureType "None" 
     .ZmaxTemperature "" 
     .ZmaxTemperatureType "None" 
End With


'@ rename port: 1 to: 3

Port.Rename "1", "3" 


'@ delete port: port2

Port.Delete "2" 


'@ delete port: port3

Port.Delete "3" 


'@ define port: 1

With Port 
     .Reset 
     .PortNumber "1" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Free" 
     .Orientation "xmin" 
     .PortOnBound "True" 
     .ClipPickedPortToBound "False" 
     .Xrange "-14", "-14" 
     .Yrange "-10", "10" 
     .Zrange "-0.635", "5.05" 
     .XrangeAdd "0.0", "0.0" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "0.0", "0.0" 
     .SingleEnded "False" 
     .Create 
End With 


'@ define port: 2

With Port 
     .Reset 
     .PortNumber "2" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Free" 
     .Orientation "ymin" 
     .PortOnBound "True" 
     .ClipPickedPortToBound "False" 
     .Xrange "-10", "10" 
     .Yrange "-14", "-14" 
     .Zrange "-0.635", "5.05" 
     .XrangeAdd "0.0", "0.0" 
     .YrangeAdd "0.0", "0.0" 
     .ZrangeAdd "0.0", "0.0" 
     .SingleEnded "False" 
     .Create 
End With 


'@ define background

With Background 
     .Reset 
     .Type "Normal" 
     .Epsilon "1.0" 
     .Mue "1.0" 
     .ThermalType "Normal" 
     .ThermalConductivity "0.0" 
     .HeatCapacity "0.0" 
     .Rho "0.0" 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0" 
     .ApplyInAllDirections "False" 
End With 


