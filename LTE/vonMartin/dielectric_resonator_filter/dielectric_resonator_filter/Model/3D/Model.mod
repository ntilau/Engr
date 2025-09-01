'# MWS Version: Version 2009.5 - Mar 20 2009 - 04:02:06

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4 fmax = 12


'@ use template: Resonator

' Template for Resonator
' ==============================
' set units to mm, ghz
With Units 
     .Geometry "mm" 
     .Frequency "ghz" 
     .Time "ns" 
End With 
' set background material to pec
With Background 
     .Type "pec" 
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

'@ set workplane properties

With WCS
     .SetWorkplaneSize "10" 
     .SetWorkplaneRaster "1" 
     .SetWorkplaneSnap "TRUE" 
     .SetWorkplaneSnapRaster "0.1" 
     .SetWorkplaneAutoadjust "TRUE" 
End With

'@ define brick: PEC:brick

With Brick
     .Reset 
     .Name "brick" 
     .Layer "PEC" 
     .Xrange "0", "l1+l2+l3/2" 
     .Yrange "0", "h" 
     .Zrange "0", "w" 
     .Create
End With

'@ activate local coordinates

WCS.ActivateWCS "local"

'@ move wcs

WCS.MoveWCS "local", "l1", "h", "w/2"

'@ rotate wcs

WCS.RotateWCS "u", "90"

'@ define layer: coax

With Layer
     .Reset 
     .Name "coax"
     .FrqType "hf" 
     .Type "Normal" 
     .Epsilon "2.4" 
     .Mue "1.0" 
     .Kappa "0.0" 
     .TanD "0.0" 
     .TanDFreq "0.0" 
     .TanDGiven "False" 
     .TanDModel "ConstTanD" 
     .KappaM "0.0" 
     .TanDM "0.0" 
     .TanDMFreq "0.0" 
     .TanDMGiven "False" 
     .DispModelEps "None" 
     .DispModelMue "None" 
     .Rho "0.0" 
     .Colour "0", "1", "1" 
     .Wireframe "False" 
     .Transparency "0" 
     .Create
End With

'@ define cylinder: coax:coax dielectr.

With Cylinder 
     .Reset 
     .Name "coax dielectr." 
     .Layer "coax" 
     .OuterRadius "r1" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "h" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ define layer colour: coax

With Layer 
     .Name "coax" 
     .Colour "1", "0.501961", "0" 
     .Wireframe "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ boolean insert shapes: PEC:brick, coax:coax dielectr.

Solid.Insert "PEC:brick", "coax:coax dielectr."

'@ define cylinder: PEC:coax feed

With Cylinder 
     .Reset 
     .Name "coax feed" 
     .Layer "PEC" 
     .OuterRadius "r2" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "lc" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ boolean insert shapes: coax:coax dielectr., PEC:coax feed

Solid.Insert "coax:coax dielectr.", "PEC:coax feed"

'@ move wcs

WCS.MoveWCS "local", "l2", "0.0", "0.0"

'@ move wcs

WCS.MoveWCS "local", "0.0", "0.0", "h"

'@ move wcs

WCS.MoveWCS "local", "0.0", "0.0", "hv/2"

'@ rotate wcs

WCS.RotateWCS "u", "90"

'@ move wcs

WCS.MoveWCS "local", "0.0", "0.0", "-hr/2"

'@ define layer: resonator

With Layer
     .Reset 
     .Name "resonator"
     .FrqType "hf" 
     .Type "Normal" 
     .Epsilon "38" 
     .Mue "1.0" 
     .Kappa "0.0" 
     .TanD "0.0" 
     .TanDFreq "0.0" 
     .TanDGiven "False" 
     .TanDModel "ConstTanD" 
     .KappaM "0.0" 
     .TanDM "0.0" 
     .TanDMFreq "0.0" 
     .TanDMGiven "False" 
     .DispModelEps "None" 
     .DispModelMue "None" 
     .Rho "0.0" 
     .Colour "1", "0.501961", "0.501961" 
     .Wireframe "False" 
     .Transparency "0" 
     .Create
End With

'@ define cylinder: resonator:resonator

With Cylinder 
     .Reset 
     .Name "resonator" 
     .Layer "resonator" 
     .OuterRadius "r3" 
     .InnerRadius "r4" 
     .Axis "z" 
     .Zrange "0", "hr" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create 
End With

'@ pick end point

Pick.PickEndpointFromId "PEC:brick", "9"

'@ align wcs with point

WCS.AlignWCSWithSelectedPoint

'@ rotate wcs

WCS.RotateWCS "u", "-90"

'@ store picked point: 10

Pick.NextPickToDatabase "10" 
Pick.PickEndpointFromId "PEC:brick", "9"

'@ store picked point: 11

Pick.NextPickToDatabase "11" 
Pick.PickEndpointFromId "PEC:brick", "3"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ define brick: Vacuum:brick

With Brick
     .Reset 
     .Name "brick" 
     .Layer "Vacuum" 
     .Xrange "xp(10)", "xp(11)" 
     .Yrange "yp(10)", "yp(11)" 
     .Zrange "0", "hv" 
     .Create
End With

'@ define layer colour: Vacuum

With Layer 
     .Name "Vacuum" 
     .Colour "0.5", "0.8", "1" 
     .Wireframe "False" 
     .Transparency "46" 
     .ChangeColour 
End With

'@ boolean insert shapes: Vacuum:brick, resonator:resonator

Solid.Insert "Vacuum:brick", "resonator:resonator"

'@ pick end point

Pick.PickEndpointFromId "PEC:brick", "8"

'@ align wcs with point

WCS.AlignWCSWithSelectedPoint

'@ pick face

Pick.PickFaceFromId "PEC:brick", "9"

'@ transform: mirror coax

With Transform 
     .Reset 
     .Name "coax" 
     .Origin "Free" 
     .Center "0", "-8", "-15.4" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MirrorAdvanced 
End With

'@ pick face

Pick.PickFaceFromId "Vacuum:brick", "10"

'@ transform: mirror resonator

With Transform 
     .Reset 
     .Name "resonator" 
     .Origin "Free" 
     .Center "0", "-8", "-15.4" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MirrorAdvanced 
End With

'@ pick face

Pick.PickFaceFromId "Vacuum:brick", "10"

'@ transform: mirror Vacuum

With Transform 
     .Reset 
     .Name "Vacuum" 
     .Origin "Free" 
     .Center "0", "-8", "-15.4" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MirrorAdvanced 
End With

'@ pick face

Pick.PickFaceFromId "PEC:brick", "9"

'@ transform: mirror PEC

With Transform 
     .Reset 
     .Name "PEC" 
     .Origin "Free" 
     .Center "0", "-8", "-1.95" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MirrorAdvanced 
End With

'@ boolean add shapes: PEC:brick, PEC:brick_1

Solid.Add "PEC:brick", "PEC:brick_1"

'@ boolean add shapes: Vacuum:brick, Vacuum:brick_1

Solid.Add "Vacuum:brick", "Vacuum:brick_1"

'@ boolean add shapes: coax:coax dielectr., coax:coax dielectr._1

Solid.Add "coax:coax dielectr.", "coax:coax dielectr._1"

'@ boolean add shapes: PEC:coax feed, PEC:coax feed_1

Solid.Add "PEC:coax feed", "PEC:coax feed_1"

'@ boolean add shapes: resonator:resonator, resonator:resonator_1

Solid.Add "resonator:resonator", "resonator:resonator_1"

'@ pick face

Pick.PickFaceFromId "Vacuum:brick", "17"

'@ align wcs with face

WCS.AlignWCSWithSelectedFace 
Pick.PickCenterpointFromId "Vacuum:brick", "17" 
WCS.AlignWCSWithSelectedPoint

'@ define automesh state

Mesh.Automesh "True"

'@ define frequency range

Solver.FrequencyRange "4", "8"

'@ define boundaries

With Boundary
     .Xmin "electric" 
     .Xmax "electric" 
     .Ymin "electric" 
     .Ymax "magnetic" 
     .Zmin "electric" 
     .Zmax "electric" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "magnetic" 
End With

'@ pick face

Pick.PickFaceFromId "coax:coax dielectr.", "10"

'@ define port: 1

With Port 
     .Reset 
     .PortNumber "1" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Orientation "ymax" 
     .PortOnBound "True" 
     .ClipPickedPortToBound "False" 
     .Xrange "6", "10" 
     .Yrange "3.9", "3.9" 
     .Zrange "6", "10" 
     .Create 
End With

'@ pick face

Pick.PickFaceFromId "coax:coax dielectr.", "4"

'@ define port: 2

With Port 
     .Reset 
     .PortNumber "2" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Orientation "ymax" 
     .PortOnBound "True" 
     .ClipPickedPortToBound "False" 
     .Xrange "56", "60" 
     .Yrange "3.9", "3.9" 
     .Zrange "6", "10" 
     .Create 
End With

'@ clear picks

Pick.ClearAllPicks

'@ set tetrahedral mesh type

Mesh.MeshType "Tetrahedral"

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
     .AddSampleInterval "4.6", "", "1", "Equidistant", "True" 
     .AddSampleInterval "4.5", "4.6", "20", "Automatic", "False" 
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

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "10" 
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
     .StoreAllResults "True" 
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
     .AddSampleInterval "4.6", "", "1", "Equidistant", "True" 
     .AddSampleInterval "4.5", "4.6", "20", "Automatic", "False" 
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

'@ pick face

Pick.PickFaceFromId "coax:coax dielectr.", "4"

'@ set shape accuracy

Solid.ShapeVisualizationAccuracy "100" 
Solid.ShapeVisualizationOffset "0" 
Pick.ClearAllPicks

'@ define frequency range

Solver.FrequencyRange "4", "12"

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "10" 
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
     .AddSampleInterval "12", "", "1", "Equidistant", "True" 
     .AddSampleInterval "4", "12", "100", "Automatic", "False" 
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

'@ clear picks

Pick.ClearAllPicks

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
     .AddSampleInterval "12", "", "1", "Equidistant", "True" 
     .AddSampleInterval "4", "12", "50", "Automatic", "False" 
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

'@ switch working plane

Plot.DrawWorkplane "false"

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
     .AddSampleInterval "12", "", "1", "Equidistant", "True" 
     .AddSampleInterval "4", "12", "100", "Automatic", "False" 
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


'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "10" 
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


