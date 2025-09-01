'# MWS Version: Version 2009.6 - Apr 29 2009 - 04:03:23

'# length = cm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 2.8 fmax = 3.2


'@ use template: Antenna (on Planar Substrate)

' Template for Antenna on Planar Substrate
' ========================================
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
' set boundary conditions to open, zmin to electric
With Boundary
     .Xmin "open" 
     .Xmax "open" 
     .Ymin "open" 
     .Ymax "open" 
     .Zmin "electric" 
     .Zmax "expanded open" 
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

'@ define units

With Units 
     .Geometry "cm" 
     .Frequency "ghz" 
     .Time "ns" 
End With

'@ define layer: Metal

With Layer 
     .Reset 
     .Name "Metal" 
     .Type "Pec" 
     .Colour "0.752941", "0.752941", "0.752941" 
     .Wireframe "False" 
     .Transparency "0" 
     .Create 
End With

'@ define brick: Metal:Ground

With Brick
     .Reset 
     .Name "Ground" 
     .Layer "Metal" 
     .Xrange "-3", "3" 
     .Yrange "-3", "3" 
     .Zrange "-1", "0" 
     .Create
End With

'@ define layer: Substrate

With Layer 
     .Reset 
     .Name "Substrate" 
     .Type "Normal" 
     .Epsilon "2.33" 
     .Mue "1.0" 
     .Kappa "0.0" 
     .TangensD "0.0" 
     .FrequForTD "0.0" 
     .TangDGiven "False" 
     .Rho "0.0" 
     .Colour "0", "0.501961", "0" 
     .Wireframe "False" 
     .Transparency "0" 
     .Create 
End With

'@ define brick: Substrate:Substrate

With Brick
     .Reset 
     .Name "Substrate" 
     .Layer "Substrate" 
     .Xrange "-3", "3" 
     .Yrange "-3", "3" 
     .Zrange "0", "0.1" 
     .Create
End With

'@ pick face

Pick.PickFaceFromId "Substrate:Substrate", "1"

'@ align wcs with face

WCS.AlignWCSWithSelectedFace 
Pick.PickCenterpointFromId "Substrate:Substrate", "1" 
WCS.AlignWCSWithSelectedPoint

'@ define brick: Metal:Patch

With Brick
     .Reset 
     .Name "Patch" 
     .Component "Metal" 
     .Material "Metal" 
     .Xrange "-Patch_length/2", "Patch_length/2" 
     .Yrange "-Patch_width/2", "Patch_width/2" 
     .Zrange "0", "0.0" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "x_shift", "y_shift", "-1.1"

'@ store picked point: 1

Pick.NextPickToDatabase "1" 
Pick.PickEndpointFromId "Substrate:Substrate", "3"

'@ define cylinder: Substrate:inner_feed

With Cylinder 
     .Reset 
     .Name "inner_feed" 
     .Layer "Substrate" 
     .OuterRadius "0.5" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "zp(1)" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ boolean insert shapes: Metal:Ground, Substrate:inner_feed

Solid.Insert "Metal:Ground", "Substrate:inner_feed"

'@ boolean insert shapes: Substrate:Substrate, Substrate:inner_feed

Solid.Insert "Substrate:Substrate", "Substrate:inner_feed"

'@ store picked point: 2

Pick.NextPickToDatabase "2" 
Pick.PickEndpointFromId "Substrate:Substrate", "6"

'@ define cylinder: Metal:inner_conductor

With Cylinder 
     .Reset 
     .Name "inner_conductor" 
     .Layer "Metal" 
     .OuterRadius "0.14" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "zp(2)" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ pick face

Pick.PickFaceFromId "Substrate:inner_feed", "1"

'@ define port: 1

With Port 
     .Reset 
     .PortNumber "1" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Location "zmin" 
     .Xrange "-0.4", "0.6" 
     .Yrange "-0.5", "0.5" 
     .Create 
End With

'@ define automesh state

Mesh.Automesh "True"

'@ define frequency range

Solver.FrequencyRange "2.8", "3.2"

'@ define boundaries

With Boundary
     .Xmin "open" 
     .Xmax "open" 
     .Ymin "open" 
     .Ymax "open" 
     .Zmin "electric" 
     .Zmax "expanded open" 
     .Xsymmetry "none" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "none" 
End With

'@ define monitor: e-field (f=2.98)

With Monitor 
     .Reset 
     .Name "e-field (f=2.98)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .Frequency "2.98" 
     .Create 
End With

'@ define monitor: h-field (f=2.98)

With Monitor 
     .Reset 
     .Name "h-field (f=2.98)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .Frequency "2.98" 
     .Create 
End With

'@ define farfield monitor: farfield (f=2.98)

With Monitor 
     .Reset 
     .Name "farfield (f=2.98)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "2.98" 
     .Create 
End With

'@ activate global coordinates

WCS.ActivateWCS "global"

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "12" 
    .MeshIncrement "5" 
    .MaxDeltaS "0.01" 
    .NumberOfDeltaSChecks "2" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks "2" 
End With

'@ set tetrahedral mesh type

Mesh.MeshType "Tetrahedral"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "All" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-4" 
     .FDSolverLimitIterations "False" 
     .FDSolverMaxIterations "0" 
     .FDSolverLimitCPUs "False" 
     .FDSolverMaxCPUs "2" 
     .FDSolverStoreAllResults "False" 
     .StoreFDResultsInCache "False" 
     .FDSolverUseHelmholtzEquation "True" 
     .FDSolverLowFrequencyStabilization "False" 
     .FDSolverType "Auto" 
     .FDSolverMeshAdaptionHex "False" 
     .FDSolverMeshAdaptionTet "True" 
     .FDSolverAcceleratedRestart "True" 
     .FDSolverHexMORSettings "", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "False" 
     .FDSolverExtrudeOpenBC "True" 
     .FDSolverAddMonitorSamples "True" 
     .FDSolverSParaFit "True" 
     .FDSolverFitThreshold "True", "0.001" 
     .FDSolverSweepErrorChecks "2" 
     .FDSolverSweepMinimumSamples "3" 
     .FDSolverSweepConsiderAll "True" 
     .FDSolverSweepConsiderReset 
     .FDSolverInterpolationSamples "1001" 
     .FDSolverSweepWeightEvanescent "1.0" 
     .FDSolverAddFrequencyIntervall "2.98", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ farfield plot options

With FarfieldPlot 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .SetTheta360 "False" 
     .CartSymRange "False" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "False" 
     .SetScaleLinear "False" 
     .SetLogRange "40" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .AlignToMainLobe "False" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0", "1", "0" 
     .Origin "bbox" 
     .Userorigin "0.000000e+000", "0.000000e+000", "0.000000e+000" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "False" 
     .DecouplingPlaneAxis "X" 
     .DecouplingPlanePosition "0.000000e+000" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "30" 
     .SetPhaseCenterComponent "Theta" 
     .SetPhaseCenterPlane "both" 
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Tetrahedral Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "All" 
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
     .MaxCPUs "2" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "False" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "True" 
     .MixedOrder "False" 
     .UsePreconditionerIntEq "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "2.5e-3" 
     .MinMLFMMBoxSize "0.20" 
     .SweepErrorThreshold "True", "0.01" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "2.98", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ farfield plot options

With FarfieldPlot 
     .Plottype "3D" 
     .Vary "phi" 
     .Theta "90" 
     .Phi "90" 
     .Step "5" 
     .Step2 "5" 
     .SetLockSteps "True" 
     .SetPlotRangeOnly "False" 
     .SetThetaStart "0" 
     .SetThetaEnd "180" 
     .SetPhiStart "0" 
     .SetPhiEnd "360" 
     .SetTheta360 "False" 
     .SymmetricRange "False" 
     .SetTimeDomainFF "False" 
     .SetFrequency "2.98" 
     .SetTime "0" 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .ShowStructure "False" 
     .SetStructureTransparent "False" 
     .SetFarfieldTransparent "True" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "False" 
     .SetScaleLinear "True" 
     .SetLogRange "40" 
     .DBUnit "0" 
     .EnableFixPlotMaximum "False" 
     .SetFixPlotMaximumValue "1.0" 
     .SetInverseAxialRatio "False" 
     .AlignToMainLobe "False" 
     .Phistart "1.000000e+000", "0.000000e+000", "0.000000e+000" 
     .Thetastart "0.000000e+000", "0.000000e+000", "1.000000e+000" 
     .PolarizationVector "0", "1", "0" 
     .SetCoordinateSystemType "ludwig2ea" 
     .Origin "bbox" 
     .Userorigin "0.000000e+000", "0.000000e+000", "0.000000e+000" 
     .SetUserDecouplingPlane "False" 
     .UseDecouplingPlane "True" 
     .DecouplingPlaneAxis "Z" 
     .DecouplingPlanePosition "0.000000e+000" 
     .EnablePhaseCenterCalculation "False" 
     .SetPhaseCenterAngularLimit "30" 
     .SetPhaseCenterComponent "Theta" 
     .SetPhaseCenterPlane "both" 
End With

'@ define frequency domain solver parameters

Mesh.SetCreator "High Frequency" 
With FDSolver
     .Reset 
     .Method "Tetrahedral Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .NetworkComputingJobCount "3" 
     .Stimulation "All", "All" 
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
     .MaxCPUs "2" 
     .CalculateExcitationsInParallel "True" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "False" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "True" 
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
     .AddSampleInterval "2.98", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With
With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With
With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "electric" 
     .Zmax "expanded open" 
     .Xsymmetry "none" 
     .Ysymmetry "magnetic" 
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

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "12" 
    .MeshIncrement "5" 
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

'@ switch working plane

Plot.DrawWorkplane "false"

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
     .XminSpace "10" 
     .XmaxSpace "10" 
     .YminSpace "10" 
     .YmaxSpace "10" 
     .ZminSpace "0.0" 
     .ZmaxSpace "10" 
     .ApplyInAllDirections "False" 
End With 

'@ define frequency domain solver parameters

Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .Method "Tetrahedral Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .NetworkComputingJobCount "3" 
     .Stimulation "All", "All" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "True" 
     .MaxCPUs "1" 
     .CalculateExcitationsInParallel "True" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "False" 
     .Type "Direct" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "True" 
     .SetOpenBCTypeHex "Default" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "True" 
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
     .AddSampleInterval "2.98", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
End With


