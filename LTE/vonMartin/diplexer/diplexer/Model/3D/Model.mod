'# MWS Version: Version 2009.5 - Mar 20 2009 - 04:02:06

'# length = mm
'# frequency = GHz
'# time = s
'# frequency range: fmin = 74 fmax = 78


'@ define brick: Vacuum:solid1

With Brick
     .Reset 
     .Name "solid1" 
     .Layer "Vacuum" 
     .Xrange "-a", "0" 
     .Yrange "0", "b" 
     .Zrange "-l1", "2*a+l1+lk" 
     .Create
End With

'@ define brick: Vacuum:solid2

With Brick
     .Reset 
     .Name "solid2" 
     .Layer "Vacuum" 
     .Xrange "0", "c2+t+d2+f2_s1+f2_s2+f2_s3+f2_s4+f2_s5+f2_s6+f2_s7+f2_s8+f2_R1+f2_R2+f2_R3+f2_R4+f2_R5+f2_R6+f2_R7+l1" 
     .Yrange "0", "b" 
     .Zrange "0", "a" 
     .Create
End With

'@ define brick: PEC:solid3

With Brick
     .Reset 
     .Name "solid3" 
     .Layer "PEC" 
     .Xrange "c2", "c2+t" 
     .Yrange "0", "b" 
     .Zrange "0", "a" 
     .Create
End With

'@ activate local coordinates

WCS.ActivateWCS "local"

'@ clear picks

Pick.ClearAllPicks

'@ pick center point

Pick.PickCenterpointFromId "PEC:solid3", "4"

'@ align wcs with point

WCS.AlignWCSWithSelectedPoint

'@ define brick: Vacuum:solid4

With Brick
     .Reset 
     .Name "solid4" 
     .Layer "Vacuum" 
     .Xrange "0", "t" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-w2/2", "w2/2" 
     .Create
End With

'@ boolean insert shapes: Vacuum:solid2, Vacuum:solid4

Solid.Insert "Vacuum:solid2", "Vacuum:solid4"

'@ boolean insert shapes: PEC:solid3, Vacuum:solid4

Solid.Insert "PEC:solid3", "Vacuum:solid4"

'@ boolean add shapes: Vacuum:solid1, Vacuum:solid2

Solid.Add "Vacuum:solid1", "Vacuum:solid2"

'@ boolean add shapes: Vacuum:solid1, Vacuum:solid4

Solid.Add "Vacuum:solid1", "Vacuum:solid4"

'@ move wcs

WCS.MoveWCS "local", "t+d2", "0.0", "0.0"

'@ define brick: PEC:solid4

With Brick
     .Reset 
     .Name "solid4" 
     .Layer "PEC" 
     .Xrange "0", "f2_s1" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s1+f2_R1", "0.0", "0.0"

'@ define brick: PEC:solid5

With Brick
     .Reset 
     .Name "solid5" 
     .Layer "PEC" 
     .Xrange "0", "f2_s2" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s2+f2_R2", "0.0", "0.0"

'@ define brick: PEC:solid6

With Brick
     .Reset 
     .Name "solid6" 
     .Layer "PEC" 
     .Xrange "0", "f2_s3" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s3+f2_R3", "0.0", "0.0"

'@ define brick: PEC:solid7

With Brick
     .Reset 
     .Name "solid7" 
     .Layer "PEC" 
     .Xrange "0", "f2_s4" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s4+f2_R4", "0.0", "0.0"

'@ define brick: PEC:solid8

With Brick
     .Reset 
     .Name "solid8" 
     .Layer "PEC" 
     .Xrange "0", "f2_s5" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s5+f2_R5", "0.0", "0.0"

'@ define brick: PEC:solid9

With Brick
     .Reset 
     .Name "solid9" 
     .Layer "PEC" 
     .Xrange "0", "f2_s6" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s6+f2_R6", "0.0", "0.0"

'@ define brick: PEC:solid10

With Brick
     .Reset 
     .Name "solid10" 
     .Layer "PEC" 
     .Xrange "0", "f2_s7" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f2_s7+f2_R7", "0.0", "0.0"

'@ define brick: PEC:solid11

With Brick
     .Reset 
     .Name "solid11" 
     .Layer "PEC" 
     .Xrange "0", "f2_s8" 
     .Yrange "-b/2", "b/2" 
     .Zrange "-f2_s0/2", "f2_s0/2" 
     .Create
End With

'@ activate global coordinates

WCS.ActivateWCS "global"

'@ activate local coordinates

WCS.ActivateWCS "local"

'@ pick end point

Pick.PickEndpointFromId "Vacuum:solid1", "43"

'@ align wcs with point

WCS.AlignWCSWithSelectedPoint

'@ move wcs

WCS.MoveWCS "local", "0.0", "0.0", "a+l1"

'@ define brick: Vacuum:solid12

With Brick
     .Reset 
     .Name "solid12" 
     .Layer "Vacuum" 
     .Xrange "0", "c1+t+d1+f1_s1+f1_s2+f1_s3+f1_s4+f1_s5+f1_s6+f1_s7+f1_s8+f1_R1+f1_R2+f1_R3+f1_R4+f1_R5+f1_R6+f1_R7+l1" 
     .Yrange "0", "b" 
     .Zrange "0", "a" 
     .Create
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick center point

Pick.PickCenterpointFromId "Vacuum:solid12", "1"

'@ pick center point

Pick.PickCenterpointFromId "Vacuum:solid1", "19"

'@ define units

With Units 
     .Geometry "mm" 
     .Frequency "hz" 
     .Time "s" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ move wcs

WCS.MoveWCS "local", "c1", "0.0", "a/2"

'@ define brick: PEC:solid13

With Brick
     .Reset 
     .Name "solid13" 
     .Layer "PEC" 
     .Xrange "0", "t" 
     .Yrange "0", "b" 
     .Zrange "-a/2", "a/2" 
     .Create
End With

'@ define brick: Vacuum:solid14

With Brick
     .Reset 
     .Name "solid14" 
     .Layer "Vacuum" 
     .Xrange "0", "t" 
     .Yrange "0", "b" 
     .Zrange "-w1/2", "w1/2" 
     .Create
End With

'@ boolean insert shapes: Vacuum:solid12, Vacuum:solid14

Solid.Insert "Vacuum:solid12", "Vacuum:solid14"

'@ boolean insert shapes: PEC:solid13, Vacuum:solid14

Solid.Insert "PEC:solid13", "Vacuum:solid14"

'@ boolean add shapes: Vacuum:solid1, Vacuum:solid12

Solid.Add "Vacuum:solid1", "Vacuum:solid12"

'@ boolean add shapes: Vacuum:solid1, Vacuum:solid14

Solid.Add "Vacuum:solid1", "Vacuum:solid14"

'@ move wcs

WCS.MoveWCS "local", "t+d1", "0.0", "0.0"

'@ define brick: PEC:solid14

With Brick
     .Reset 
     .Name "solid14" 
     .Layer "PEC" 
     .Xrange "0", "f1_s1" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f1_s1+f1_R1", "0.0", "0.0"

'@ define brick: PEC:solid15

With Brick
     .Reset 
     .Name "solid15" 
     .Layer "PEC" 
     .Xrange "0", "f1_s2" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f1_s2+f1_R2", "0.0", "0.0"

'@ define brick: Vacuum:solid16

With Brick
     .Reset 
     .Name "solid16" 
     .Layer "Vacuum" 
     .Xrange "0", "f1_s3" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ change layer: Vacuum:solid16 to: PEC:solid16

Solid.ChangeLayer "Vacuum:solid16", "PEC"

'@ move wcs

WCS.MoveWCS "local", "f1_s3+f1_R4", "0.0", "0.0"

'@ define brick: PEC:solid17

With Brick
     .Reset 
     .Name "solid17" 
     .Layer "PEC" 
     .Xrange "0", "f1_s4" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f1_s4+f1_R4", "0.0", "0.0"

'@ define brick: PEC:solid18

With Brick
     .Reset 
     .Name "solid18" 
     .Layer "PEC" 
     .Xrange "0", "f1_s5" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f1_s5+f1_R5", "0.0", "0.0"

'@ define brick: PEC:solid19

With Brick
     .Reset 
     .Name "solid19" 
     .Layer "PEC" 
     .Xrange "0", "f1_s6" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f1_s6+f1_R6", "0.0", "0.0"

'@ define brick: PEC:solid20

With Brick
     .Reset 
     .Name "solid20" 
     .Layer "PEC" 
     .Xrange "0", "f1_s7" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ move wcs

WCS.MoveWCS "local", "f1_s7+f1_R7", "0.0", "0.0"

'@ define brick: PEC:solid21

With Brick
     .Reset 
     .Name "solid21" 
     .Layer "PEC" 
     .Xrange "0", "f1_s8" 
     .Yrange "0", "b" 
     .Zrange "-f1_s0/2", "f1_s0/2" 
     .Create
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick center point

Pick.PickCenterpointFromId "Vacuum:solid1", "36"

'@ pick center point

Pick.PickCenterpointFromId "Vacuum:solid1", "18"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick face

Pick.PickFaceFromId "Vacuum:solid1", "36"

'@ pick end point

Pick.PickEndpointFromId "Vacuum:solid1", "21"

'@ define extrude: Vacuum:solid22

With Extrude 
     .Reset 
     .Name "solid22" 
     .Layer "Vacuum" 
     .Mode "Picks" 
     .Height "4.994" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "True" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ pick face

Pick.PickFaceFromId "Vacuum:solid1", "38"

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
     .Location "zmin" 
     .Xrange "-3.099", "0" 
     .Yrange "0", "1.549" 
     .Create 
End With

'@ pick face

Pick.PickFaceFromId "Vacuum:solid1", "18"

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
     .Location "xmax" 
     .Yrange "0", "1.549" 
     .Zrange "6.313", "9.412" 
     .Create 
End With

'@ pick face

Pick.PickFaceFromId "Vacuum:solid22", "5"

'@ boolean add shapes: Vacuum:solid1, Vacuum:solid22

Solid.Add "Vacuum:solid1", "Vacuum:solid22"

'@ pick face

Pick.PickFaceFromId "Vacuum:solid1", "5"

'@ define port: 3

With Port 
     .Reset 
     .PortNumber "3" 
     .NumberOfModes "1" 
     .AdjustPolarization False 
     .PolarizationAngle "0.0" 
     .ReferencePlaneDistance "0" 
     .TextSize "50" 
     .Coordinates "Picks" 
     .Location "xmax" 
     .Yrange "0", "1.549" 
     .Zrange "0", "3.099" 
     .Create 
End With

'@ define units

With Units 
     .Geometry "mm" 
     .Frequency "ghz" 
     .Time "s" 
End With

'@ define background

With Background 
     .Type "Pec" 
     .Epsilon "1.0" 
     .Mue "1.0" 
     .XminSpace "0.0" 
     .XmaxSpace "0.0" 
     .YminSpace "0.0" 
     .YmaxSpace "0.0" 
     .ZminSpace "0.0" 
     .ZmaxSpace "0.0" 
End With

'@ define automesh state

Mesh.Automesh "True"

'@ define frequency range

Solver.FrequencyRange "74", "78"

'@ define boundaries

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

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10.0" 
     .LinesPerWavelength "20" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ define boundaries

With Boundary
     .Xmin "electric" 
     .Xmax "electric" 
     .Ymin "electric" 
     .Ymax "electric" 
     .Zmin "electric" 
     .Zmax "electric" 
     .Xsymmetry "none" 
     .Ysymmetry "electric" 
     .Zsymmetry "none" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ define boundaries

With Boundary
     .Xmin "electric" 
     .Xmax "electric" 
     .Ymin "electric" 
     .Ymax "electric" 
     .Zmin "electric" 
     .Zmax "electric" 
     .Xsymmetry "none" 
     .Ysymmetry "electric" 
     .Zsymmetry "none" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ define special solver parameters

With Solver 
     .TimeBetweenUpdates "20" 
     .NumberOfPulseWidths "50" 
     .EnergyBalanceLimit "0.03" 
     .UseArfilter "False" 
     .ArMaxEnergyDeviation "0.1" 
     .ArPulseSkip "1" 
     .WaveguideBroadband "False" 
     .SetBBPSamples "5" 
     .SetSamplesFullDeembedding "20" 
     .MatrixDump "False" 
     .SetFading "False" 
     .TimestepReduction "0.45" 
     .NumberOfSubcycles "4" 
     .SubcycleFillLimit "70" 
     .UseParallelization "False" 
     .MaximumNumberOfProcessors "2" 
     .TimeStepStabilityFactor "1.0" 
     .UseOpenBoundaryForHigherModes "True" 
     .SetModeFreqFactor "0.5" 
     .SurfaceImpedanceOrder "10" 
     .SetPortShielding "False" 
     .SetTimeStepMethod "Automatic" 
     .FrequencySamples "1000" 
     .ConsiderTwoPortReciprocity "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "Vacuum:solid1", "87"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid14", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid13", "18"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid14", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid14", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid15", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid15", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid16", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid16", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid17", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid17", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid18", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid18", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid19", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid19", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid20", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid20", "6"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:solid21", "7"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick edge

Pick.PickEdgeFromId "PEC:solid5", "10", "1"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "1" 
     .StimulationMode "1" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10.0" 
     .LinesPerWavelength "40" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "1" 
     .StimulationMode "1" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10.0" 
     .LinesPerWavelength "50" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ define automesh parameters

With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "4" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .AutomeshRefineDielectrics "True" 
     .MergeThinPECLayerFixpoints "False" 
     .EquilibrateMesh "True" 
     .UsePecEdgeModel "True" 
     .MeshType "PBA" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "1" 
     .StimulationMode "1" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ define automesh parameters

With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "4" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .AutomeshRefineDielectrics "True" 
     .MergeThinPECLayerFixpoints "False" 
     .EquilibrateMesh "False" 
     .UsePecEdgeModel "True" 
     .MeshType "PBA" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
End With

'@ pick face

Pick.PickFaceFromId "Vacuum:solid1", "49"

'@ align wcs with face

WCS.AlignWCSWithSelectedFace 
Pick.PickCenterpointFromId "Vacuum:solid1", "49" 
WCS.AlignWCSWithSelectedPoint

'@ slice shape: Vacuum:solid1

Solid.SliceShape "solid1", "Vacuum"

'@ clear picks

Pick.ClearAllPicks

'@ define automesh for: Vacuum:solid1

Solid.SetMeshProperties "Vacuum:solid1", "PBA", "True" 
Solid.SetAutomeshParameters "Vacuum:solid1", "0", "True" 
Solid.SetAutomeshStepwidth "Vacuum:solid1", "40/1000", "0", "0" 
Solid.SetAutomeshExtendwidth "Vacuum:solid1", "0", "0", "0"

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10.0" 
     .LinesPerWavelength "30" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
End With

'@ define automesh for: Vacuum:solid1

Solid.SetMeshProperties "Vacuum:solid1", "PBA", "True" 
Solid.SetAutomeshParameters "Vacuum:solid1", "0", "True" 
Solid.SetAutomeshStepwidth "Vacuum:solid1", "40/1200", "0", "0" 
Solid.SetAutomeshExtendwidth "Vacuum:solid1", "0", "0", "0"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10.0" 
     .LinesPerWavelength "10" 
     .MinimumLineNumber "10" 
     .Automesh "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "5" 
     .LinesPerWavelength "10" 
     .MinimumLineNumber "10" 
     .Automesh "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10" 
     .LinesPerWavelength "30" 
     .MinimumLineNumber "30" 
     .Automesh "True" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
     .FDSolverStimulation "All", "All" 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-5" 
     .FDSolverAccuracyTet "1e-4" 
     .FDSolverLimitIterations "False" 
     .FDSolverMaxIterations "0" 
     .FDSolverStoreAllResults "False" 
     .StoreFDResultsInCache "False" 
     .FDSolverUseHelmholtzEquation "True" 
     .FDSolverType "Auto" 
     .FDSolverMeshAdaptionHex "False" 
     .FDSolverMeshAdaptionTet "True" 
     .FDSolverAcceleratedRestart "True" 
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverTDCompatibleMaterials "True" 
     .FDSolverAddMonitorSamples "True" 
     .FDSolverSParaFit "True" 
     .FDSolverFitThreshold "True", "0.001" 
     .FDSolverSweepErrorChecks "2" 
     .FDSolverSweepMinimumSamples "3" 
     .FDSolverSweepConsiderAll "True" 
     .FDSolverSweepConsiderReset 
     .FDSolverInterpolationSamples "1001" 
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ arfilter settings for s-parameters

With Arfilter
     .SetType "s-parameter" 
     .SetFirstTime "1.7772752158862e-009" 
     .SetSkip "10" 
     .SetMaxFrq "117.6" 
     .SetMaxOrder "20" 
     .SetWindowLength "2" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
     .FDSolverStimulation "All", "All" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
     .FDSolverAddMonitorSamples "True" 
     .FDSolverSParaFit "True" 
     .FDSolverFitThreshold "True", "0.001" 
     .FDSolverSweepErrorChecks "2" 
     .FDSolverSweepMinimumSamples "3" 
     .FDSolverSweepConsiderAll "True" 
     .FDSolverSweepConsiderReset 
     .FDSolverInterpolationSamples "1001" 
     .FDSolverSweepWeightEvanescent "1.0" 
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ define automesh parameters

With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "4" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .SetAutomeshRefineDielectricsType "Wave" 
     .MergeThinPECLayerFixpoints "False" 
     .EquilibrateMesh "False" 
     .UsePecEdgeModel "True" 
     .MeshType "PBA" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "100" 
     .CurvatureRefinementFactor "0.05" 
     .SmallFeatureSize "0.0" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .QualityEnhancement "True" 
     .DensityTransitions "0.5" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "Fast PBA" 
     .FastPBAAccuracy "3" 
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .UseSubgridding "False" 
     .SetMaximumSubgridDepth "5" 
     .AlwaysExcludePec "False" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
     .FDSolverAddMonitorSamples "True" 
     .FDSolverSParaFit "True" 
     .FDSolverFitThreshold "True", "0.001" 
     .FDSolverSweepErrorChecks "2" 
     .FDSolverSweepMinimumSamples "3" 
     .FDSolverSweepConsiderAll "True" 
     .FDSolverSweepConsiderReset 
     .FDSolverInterpolationSamples "1001" 
     .FDSolverSweepWeightEvanescent "1.0" 
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ define automesh parameters

With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "4" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .SetAutomeshRefineDielectricsType "Wave" 
     .MergeThinPECLayerFixpoints "False" 
     .EquilibrateMesh "False" 
     .UsePecEdgeModel "True" 
     .MeshType "PBA" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "100" 
     .CurvatureRefinementFactor "0.05" 
     .SmallFeatureSize "0.0" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .QualityEnhancement "True" 
     .DensityTransitions "0.5" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "PBA" 
     .FastPBAAccuracy "3" 
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .SetMaximumSubgridDepth "" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10" 
     .LinesPerWavelength "20" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
     .FDSolverAddMonitorSamples "True" 
     .FDSolverSParaFit "True" 
     .FDSolverFitThreshold "True", "0.001" 
     .FDSolverSweepErrorChecks "2" 
     .FDSolverSweepMinimumSamples "3" 
     .FDSolverSweepConsiderAll "True" 
     .FDSolverSweepConsiderReset 
     .FDSolverInterpolationSamples "1001" 
     .FDSolverSweepWeightEvanescent "1.0" 
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "10" 
     .LinesPerWavelength "10" 
     .MinimumLineNumber "10" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
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
     .FDSolverMeshAdaptionHex "True" 
     .FDSolverMeshAdaptionTet "True" 
     .FDSolverAcceleratedRestart "True" 
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
     .FDSolverAddMonitorSamples "True" 
     .FDSolverSParaFit "True" 
     .FDSolverFitThreshold "True", "0.001" 
     .FDSolverSweepErrorChecks "2" 
     .FDSolverSweepMinimumSamples "3" 
     .FDSolverSweepConsiderAll "True" 
     .FDSolverSweepConsiderReset 
     .FDSolverInterpolationSamples "1001" 
     .FDSolverSweepWeightEvanescent "1.0" 
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "35" 
    .MinimumLineNumber "35" 
End With

'@ define aks solver parameters

With Solver
     .CalculationType "Eigenmode" 
     .EigenmodeSolverType "AKS" 
     .AKSReset 
     .AKSModes "10" 
     .AKSPenaltyFactor "1" 
     .AKSEstimation "0" 
     .AKSAutomaticEstimation "True" 
     .AKSEstimationCycles "5" 
     .AKSIterations "2" 
     .AKSAccuracy "1e-012" 
     .AKSMaximumNumberOfProcessors "2" 
     .StoreEigenmodeResultsInCache "False" 
     .AKSAdaptionActive "False" 
     .CalculateExternalQFactor "False" 
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
     .FDSolverMeshAdaptionHex "True" 
     .FDSolverMeshAdaptionTet "True" 
     .FDSolverAcceleratedRestart "True" 
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
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
     .FDSolverAddFrequencyIntervall "75.2", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "77", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "20" 
    .MeshIncrement "5" 
    .MaxDeltaS "0.01" 
    .NumberOfDeltaSChecks "2" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks "2" 
End With

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
     .FDSolverMeshAdaptionHex "True" 
     .FDSolverMeshAdaptionTet "True" 
     .FDSolverAcceleratedRestart "True" 
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
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
     .FDSolverAddFrequencyIntervall "75.2", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "77", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ set pba mesh type

Mesh.MeshType "PBA"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
     .FDSolverOrder "First" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
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
     .FDSolverAddFrequencyIntervall "77", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "75.2", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ define eigenmode solver parameters

With Solver
     .CalculationType "Eigenmode" 
     .EigenmodeSolverType "JDM" 
     .AKSReset 
     .AKSModes "2" 
     .ModesInFrequencyRange "False" 
     .EigenmodeSolverAccuracy "1e-6" 
     .AKSPenaltyFactor "1" 
     .StoreEigenmodeResultsInCache "False" 
     .AKSAdaptionActive "False" 
     .EigenmodeSolverEpsFrequency "True", "" 
     .EigenmodeSolverTDCompatibleMaterials "False" 
     .CalculateExternalQFactor "False" 
     .EigenmodeSolverUsePerturbation "False" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
     .FDSolverOrder "First" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
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
     .FDSolverAddFrequencyIntervall "75.2", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "77", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ define aks solver parameters

With Solver
     .CalculationType "Eigenmode" 
     .EigenmodeSolverType "AKS" 
     .AKSReset 
     .AKSModes "2" 
     .AKSPenaltyFactor "1" 
     .AKSEstimation "0" 
     .AKSAutomaticEstimation "True" 
     .AKSEstimationCycles "5" 
     .AKSIterations "2" 
     .AKSAccuracy "1e-012" 
     .AKSMaximumNumberOfProcessors "2" 
     .StoreEigenmodeResultsInCache "False" 
     .AKSAdaptionActive "False" 
     .CalculateExternalQFactor "False" 
     .EigenmodeSolverUsePerturbation "False" 
End With

'@ define eigenmode solver parameters

With Solver
     .CalculationType "Eigenmode" 
     .EigenmodeSolverType "JDM" 
     .AKSReset 
     .AKSModes "2" 
     .ModesInFrequencyRange "False" 
     .EigenmodeSolverAccuracy "1e-6" 
     .AKSPenaltyFactor "1" 
     .StoreEigenmodeResultsInCache "False" 
     .AKSAdaptionActive "False" 
     .EigenmodeSolverEpsFrequency "True", "" 
     .EigenmodeSolverTDCompatibleMaterials "False" 
     .CalculateExternalQFactor "False" 
     .EigenmodeSolverUsePerturbation "False" 
End With

'@ define automesh parameters

With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "4" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .SetAutomeshRefineDielectricsType "Wave" 
     .MergeThinPECLayerFixpoints "False" 
     .EquilibrateMesh "False" 
     .UsePecEdgeModel "True" 
     .MeshType "PBA" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "100" 
     .CurvatureRefinementFactor "0.05" 
     .SmallFeatureSize "0.0" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .DensityTransitions "0.5" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "PBA" 
     .FastPBAAccuracy "3" 
End With 
With Solver 
     .UseSplitComponents "False" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .SetMaximumSubgridDepth "" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ define eigenmode solver parameters

With Solver
     .CalculationType "Eigenmode" 
     .EigenmodeSolverType "JDM" 
     .AKSReset 
     .AKSModes "2" 
     .ModesInFrequencyRange "False" 
     .EigenmodeSolverAccuracy "1e-6" 
     .AKSPenaltyFactor "1" 
     .StoreEigenmodeResultsInCache "False" 
     .AKSAdaptionActive "False" 
     .EigenmodeSolverEpsFrequency "True", "" 
     .EigenmodeSolverTDCompatibleMaterials "False" 
     .CalculateExternalQFactor "False" 
     .EigenmodeSolverUsePerturbation "False" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
     .FDSolverOrder "First" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
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
     .FDSolverAddFrequencyIntervall "77", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "75.2", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ define eigenmode solver parameters

With Solver
     .CalculationType "Eigenmode" 
     .EigenmodeSolverType "JDM" 
     .AKSReset 
     .AKSModes "2" 
     .ModesInFrequencyRange "False" 
     .EigenmodeSolverAccuracy "1e-6" 
     .AKSPenaltyFactor "1" 
     .StoreEigenmodeResultsInCache "False" 
     .AKSAdaptionActive "False" 
     .EigenmodeSolverEpsFrequency "True", "" 
     .EigenmodeSolverTDCompatibleMaterials "False" 
     .CalculateExternalQFactor "False" 
     .EigenmodeSolverUsePerturbation "False" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Hexahedral Mesh (MOR)" 
     .FDSolverOrder "First" 
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
     .FDSolverHexMORSettings "76", "1001" 
     .FDSolverNewIterativeSolver "True" 
     .FDSolverTDCompatibleMaterials "True" 
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
     .FDSolverAddFrequencyIntervall "77", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "75.2", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "20", "Automatic" 
End With

'@ execute macro: Results / Measure Resonances and Q-values from frq-data

        Const NMax = 10
        Dim cst_frequency(NMax) As Single
        Dim cst_amplitude(NMax) As Single
        Dim cst_qfactor(NMax) As String
        Dim cst_string(NMax) As String
        Dim cst_checkbox(NMax) As Boolean
        Dim NFound As Long
        Dim cstmon_e As Long
        Dim cstmon_h As Long
        Dim cstmon_p As Long
        Dim cstmon_f As Long
        Dim iimode As Long
        For iimode=1 To NFound
                If cst_checkbox(iimode) Then
                        With Monitor
                            .Reset
                            .Dimension "Volume"
                            .Frequency Replace(CStr(cst_frequency(iimode)),",", ".")
                                If cstmon_e Then
                                    .Name "e_"+CStr(iimode)+"_"+Replace(CStr(cst_frequency(iimode)),",", ".")
                                    .FieldType "Efield"
                                    .Create
                                End If
                                If cstmon_h Then
                                    .Name "h_"+CStr(iimode)+"_"+Replace(CStr(cst_frequency(iimode)),",", ".")
                                    .FieldType "Hfield"
                                    .Create
                                End If
                                If cstmon_p Then
                                    .Name "p_"+CStr(iimode)+"_"+Replace(CStr(cst_frequency(iimode)),",", ".")
                                    .FieldType "Powerflow"
                                    .Create
                                End If
                                If cstmon_f Then
                                    .Name "f_"+CStr(iimode)+"_"+Replace(CStr(cst_frequency(iimode)),",", ".")
                                    .FieldType "Farfield"
                                    .Create
                                End If
                        End With
                End If
        Next

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Hexahedral Mesh (MOR)" 
     .OrderTet "First" 
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
     .HexMORSettings "76", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "True" 
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
     .SweepErrorThreshold "True", "0.001" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "75.2", "", "1", "Equidistant", "True" 
     .AddSampleInterval "77", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "20", "Automatic", "False" 
End With

'@ network extraction MOR settings

With NetworkParameterExtraction
   .Method "MOR"
   .InitalNumberOfPoles 10
   .Accuracy 0.01
   .EnsureOutOfBandPassivity "True"
   .DifferentialNetlist "False"
   .UseARFilterResults "False"
   .CircuitFilename "diplexer^MOR.net"
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Hexahedral Mesh (MOR)" 
     .OrderTet "First" 
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
     .HexMORSettings "76", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "True" 
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
     .SweepErrorThreshold "True", "0.001" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "75.2", "", "1", "Equidistant", "True" 
     .AddSampleInterval "77", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "20", "Automatic", "False" 
End With

'@ network extraction MOR settings

With NetworkParameterExtraction
   .Method "MOR"
   .InitalNumberOfPoles 10
   .Accuracy 0.01
   .EnsureOutOfBandPassivity "True"
   .DifferentialNetlist "False"
   .UseARFilterResults "False"
   .CircuitFilename "diplexer^MOR.net"
   .NetlistFormat "Berkeley SPICE"
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
     .MaxCPUs "2" 
     .CalculateExcitationsInParallel "True" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "76", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "True" 
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
     .SweepErrorThreshold "True", "0.001" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "77", "", "1", "Equidistant", "True" 
     .AddSampleInterval "75.2", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "40", "Automatic", "False" 
End With
With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With
With IESolver
     .SetFMMFFCalcStopLevel "2" 
     .SetFMMFFCalcNumInterpPoints "4" 
     .UseFMMFarfieldCalc "False" 
End With

'@ set tetrahedral mesh type

Mesh.MeshType "Tetrahedral"

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "25" 
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
     .MaxCPUs "2" 
     .CalculateExcitationsInParallel "True" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "True" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .HexMORSettings "76", "1001" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "True" 
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
     .AddSampleInterval "77", "", "1", "Equidistant", "True" 
     .AddSampleInterval "75.2", "", "1", "Equidistant", "True" 
     .AddSampleInterval "", "", "50", "Automatic", "False" 
End With
With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With
With IESolver
     .SetFMMFFCalcStopLevel "2" 
     .SetFMMFFCalcNumInterpPoints "4" 
     .UseFMMFarfieldCalc "False" 
End With

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "HighFrequencyTet" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "3" 
    .MaxPasses "50" 
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


