'# MWS Version: Version 2009.6 - Apr 29 2009 - 04:03:23

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 3 fmax = 7


'@ use template: Antenna (in Free Space, planar)

' Template for Antenna in Free Space
' ==================================
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
' set boundary conditions to open
With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
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

'@ define brick: PEC:Board

With Brick
     .Reset 
     .Name "Board" 
     .Component "PEC" 
     .Material "PEC" 
     .Xrange "-b/2", "b/2" 
     .Yrange "-thick/2", "thick/2" 
     .Zrange "0", "d" 
     .Create
End With

'@ activate local coordinates

WCS.ActivateWCS "local"

'@ set wcs properties

With WCS
     .SetNormal "0", "0", "1"
     .SetOrigin "0", "0", "0"
     .SetUVector "1", "0", "0"
End With

'@ move wcs

WCS.MoveWCS "local", "0.0", "-Lg-12.33", "0.0"

'@ set wcs properties

With WCS
     .SetNormal "0", "0", "1"
     .SetOrigin "0", "0", "0"
     .SetUVector "1", "0", "0"
End With

'@ activate global coordinates

WCS.ActivateWCS "global"

'@ define brick: Vacuum:slot

With Brick
     .Reset 
     .Name "slot" 
     .Component "Vacuum" 
     .Material "Vacuum" 
     .Xrange "-Ws/2", "Ws/2" 
     .Yrange "-thick/2", "thick/2" 
     .Zrange "12.33-2", "d" 
     .Create
End With

'@ boolean subtract shapes: PEC:Board, Vacuum:slot

Solid.Subtract "PEC:Board", "Vacuum:slot"

'@ define units

With Units 
     .Geometry "mm" 
     .Frequency "ghz" 
     .Time "ns" 
End With

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
     .ZmaxSpace "0.0" 
End With

'@ define automesh state

Mesh.Automesh "True"

'@ define frequency range

Solver.FrequencyRange "0.5", "20"

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
End With

'@ define farfield monitor: farfield (f=10)

With Monitor 
     .Reset 
     .Name "farfield (f=10)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "10" 
     .Create 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-30" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StimulationType "Gaussian" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
End With

'@ execute macro: Construct / Create 2D-Curve analytical (xy-uv)

On Error GoTo Curve_Exists
	Curve.NewCurve "2D-Analytical"
Curve_Exists:
On Error GoTo 0
Dim sCurveName As String
sCurveName = "spline_1"
With Spline 
  .Reset 
  .Name sCurveName 
  .Curve "2D-Analytical"
' ======================================
' !!! Do not change ABOVE this line !!!
' ======================================
' -----------------------------------------------------------
' adjust x-range as for-loop parameters (xmin,max,stepsize)
' enter y-Function-statement within for-loop
' fixed parameters a,b,c have to be declared via Dim-Statement
' -----------------------------------------------------------
' NOTE: available MWS-Parameters can be used without 
'       declaration at any place (loop-dimensions, ...)
'       (for parametric curves during parameter-sweeps and optimisation !)
' -------------------------------------------
  Dim xxx As Double, yyy As Double
  
 Dim start as Double
Dim finish as Double
start=0
finish=253
  For xxx = start  To  finish  STEP  0.5
	yyy = C2*exp(Ra*xxx) - C2
		
	.LineTo xxx , yyy 
  Next xxx
' ======================================
' !!! Do not change BELOW this line !!!
' ======================================
  .Create 
End With 
SelectTreeItem("Curves\2D-Analytical\"+sCurveName)

'@ clear picks

Pick.ClearAllPicks

'@ transform curve: rotate 2D-Analytical:spline_1

With Transform 
     .Reset 
     .Name "2D-Analytical:spline_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "-90", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .RotateCurve 
End With

'@ transform curve: rotate 2D-Analytical:spline_1

With Transform 
     .Reset 
     .Name "2D-Analytical:spline_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "-90" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .RotateCurve 
End With

'@ transform curve: translate 2D-Analytical:spline_1

With Transform 
     .Reset 
     .Name "2D-Analytical:spline_1" 
     .Vector "150", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateCurve 
End With

'@ store picked point: 1

Pick.NextPickToDatabase "1" 
Pick.PickCurveEndpointFromId "2D-Analytical:spline_1", "1"

'@ activate local coordinates

WCS.ActivateWCS "local"

'@ move wcs

WCS.MoveWCS "local", "150", "0.0", "0.0"

'@ rotate wcs

WCS.RotateWCS "u", "90"

'@ define curve line: 2D-Analytical:line1

With Line
     .Reset 
     .Name "line1" 
     .Curve "2D-Analytical" 
     .X1 "0" 
     .Y1 "0" 
     .X2 "0" 
     .Y2 "300" 
     .Create
End With

'@ store picked point: 2

Pick.NextPickToDatabase "2" 
Pick.PickCurveEndpointFromId "2D-Analytical:spline_1", "2"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ define curve line: 2D-Analytical:line2

With Line
     .Reset 
     .Name "line2" 
     .Curve "2D-Analytical" 
     .X1 "xp(2)" 
     .Y1 "yp(2)" 
     .X2 "-40" 
     .Y2 "yp(2)" 
     .Create
End With

'@ trim curves: 2D-Analytical:line1 with: 2D-Analytical:line2

With TrimCurves 
  .Reset 
  .Curve "2D-Analytical" 
  .CurveItem1 "line1" 
  .CurveItem2 "line2" 
  .DeleteEdges1 "2" 
  .DeleteEdges2 "2" 
  .Trim 
End With

'@ define extrudeprofile: Vacuum:solid1

With ExtrudeCurve
     .Reset 
     .Name "solid1" 
     .Layer "Vacuum" 
     .Thickness "50" 
     .Twistangle "0.0" 
     .Taperangle "0.0" 
     .Curve "2D-Analytical:spline_1" 
     .Create
End With

'@ change layer: Vacuum:solid1 to: PEC:solid1

Solid.ChangeLayer "Vacuum:solid1", "PEC"

'@ transform: translate PEC:solid1

With Transform 
     .Reset 
     .Name "PEC:solid1" 
     .Vector "100", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .Destination "PEC" 
     .TranslateAdvanced 
End With

'@ transform: translate PEC:solid1

With Transform 
     .Reset 
     .Name "PEC:solid1" 
     .Vector "0", "0", "-25" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ activate global coordinates

WCS.ActivateWCS "global"

'@ transform: translate PEC:solid1

With Transform 
     .Reset 
     .Name "PEC:solid1" 
     .Vector "-150", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ transform: translate PEC:solid1

With Transform 
     .Reset 
     .Name "PEC:solid1" 
     .Vector "Ws/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ transform: translate PEC:solid1

With Transform 
     .Reset 
     .Name "PEC:solid1" 
     .Vector "0", "0", "Lg+12.33+Ls" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ boolean subtract shapes: PEC:Board, PEC:solid1

Solid.Subtract "PEC:Board", "PEC:solid1"

'@ transform: translate PEC:solid1_1

With Transform 
     .Reset 
     .Name "PEC:solid1_1" 
     .Vector "-250", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ transform: mirror PEC:solid1_1

With Transform 
     .Reset 
     .Name "PEC:solid1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "1", "0", "0" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MirrorAdvanced 
End With

'@ transform: translate PEC:solid1_1

With Transform 
     .Reset 
     .Name "PEC:solid1_1" 
     .Vector "-Ws/2", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ transform: translate PEC:solid1_1

With Transform 
     .Reset 
     .Name "PEC:solid1_1" 
     .Vector "0", "0", "Lg+12.33+Ls" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ transform: translate PEC:solid1_1

With Transform 
     .Reset 
     .Name "PEC:solid1_1" 
     .Vector "0", "25", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .TranslateAdvanced 
End With

'@ boolean subtract shapes: PEC:Board, PEC:solid1_1

Solid.Subtract "PEC:Board", "PEC:solid1_1"

''@ move wcs
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'WCS.MoveWCS "local", "0.0", "0.0", "15"
'
''@ move wcs
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'WCS.MoveWCS "local", "0.0", "20", "0.0"
'
''@ move wcs
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'WCS.MoveWCS "local", "0.0", "0.0", "-2"
'
'@ activate global coordinates

WCS.ActivateWCS "global"

'@ set 3d mesh adaptation results

With Mesh
    .LinesPerWavelength "15" 
    .MinimumLineNumber "15" 
End With

'@ new curve: curve1

Curve.NewCurve "curve1"

'@ activate local coordinates

WCS.ActivateWCS "local"

'@ move wcs

WCS.MoveWCS "local", "0.0", "0.0", "0.0"

'@ align wcs with global plane

With WCS
     .SetNormal "0", "0", "1"
     .SetOrigin "0", "0", "62"
     .SetUVector "1", "0", "0"
     .ActivateWCS "local" 
End With

'@ rotate wcs

WCS.RotateWCS "u", "90"

'@ set wcs properties

With WCS
     .SetNormal "0", "-1", "0"
     .SetOrigin "0", "0", "0"
     .SetUVector "1", "0", "0"
End With

'@ define curve line: curve1:line1

With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "0" 
     .Y1 "0" 
     .X2 "9.848" 
     .Y2 "0" 
     .Create
End With

'@ transform curve: translate curve1:line1

With Transform 
     .Reset 
     .Name "curve1:line1" 
     .Vector "0", "0", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .Destination "curve1" 
     .TranslateCurve 
End With

'@ transform curve: rotate curve1:line1_1

With Transform 
     .Reset 
     .Name "curve1:line1_1" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .Angle "0", "0", "80" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .RotateCurve 
End With

'@ define curve circle: curve1:circle1

With Circle
     .Reset 
     .Name "circle1" 
     .Curve "curve1" 
     .Radius "9.848" 
     .Xcenter "0" 
     .Ycenter "0" 
     .Create
End With

'@ new curve: curve2

Curve.NewCurve "curve2"

'@ move curve item: curve1:circle1 to curve: curve2

Curve.MoveCurveItem "circle1", "curve1", "curve2"

'@ move curve item: curve2:circle1 to curve: curve1

Curve.MoveCurveItem "circle1", "curve2", "curve1"

'@ trim curves: curve1:line1_1 with: curve1:circle1

With TrimCurves 
  .Reset 
  .Curve "curve1" 
  .CurveItem1 "line1_1" 
  .CurveItem2 "circle1" 
  .DeleteEdges1 "" 
  .DeleteEdges2 "" 
  .Trim 
End With

'@ delete curve: curve1

Curve.DeleteCurve "curve1"

'@ delete curve: curve2

Curve.DeleteCurve "curve2"

'@ execute macro: Construct / Curves / Create 2D-Curve analytical (xy-uv)

On Error GoTo Curve_Exists
	Curve.NewCurve "2D-Analytical"
Curve_Exists:
On Error GoTo 0
Dim sCurveName As String
sCurveName = "spline_1"
With Spline 
  .Reset 
  .Name sCurveName 
  .Curve "2D-Analytical"
' ======================================
' !!! Do not change ABOVE this line !!!
' ======================================
' -----------------------------------------------------------
' adjust x-range as for-loop parameters (xmin,max,stepsize)
' enter y-Function-statement within for-loop
' fixed parameters a,b,c have to be declared via Dim-Statement
' -----------------------------------------------------------
' NOTE: available MWS-Parameters can be used without 
'       declaration at any place (loop-dimensions, ...)
'       (for parametric curves during parameter-sweeps and optimisation !)
' -------------------------------------------
  Dim xxx As Double, yyy As Double
  
  Dim aaa As Double  ' not necessary if aaa is model parameter
  aaa = 1.23456/Atn(0.5)
  For xxx = 1.5  To  10  STEP  0.5
	yyy = 3*aaa/xxx + Sin(xxx^2)
		
	.LineTo xxx , yyy 
  Next xxx
' ======================================
' !!! Do not change BELOW this line !!!
' ======================================
  .Create 
End With 
SelectTreeItem("Curves\2D-Analytical\"+sCurveName)

'@ define material colour: PEC

With Material 
     .Name "PEC" 
     .Colour "0", "0", "1" 
     .Wireframe "False" 
     .Transparency "0" 
     .ChangeColour 
End With

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "27"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "24"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "27"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "26"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "29"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "26"

'@ snap point to drawplane

Pick.SnapLastPointToDrawplane

'@ clear picks

Pick.ClearAllPicks

'@ activate global coordinates

WCS.ActivateWCS "global"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "29"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "26"

'@ define cylinder: PEC:solid1

With Cylinder 
     .Reset 
     .Name "solid1" 
     .Component "PEC" 
     .Material "PEC" 
     .OuterRadius "rcyl" 
     .InnerRadius "0" 
     .Axis "y" 
     .Yrange "-thick/2", "thick/2" 
     .Xcenter "0" 
     .Zcenter "zc" 
     .Segments "0" 
     .Create 
End With

'@ rename block: PEC:solid1 to: PEC:Cavity

Solid.Rename "PEC:solid1", "Cavity"

'@ boolean subtract shapes: PEC:Board, PEC:Cavity

Solid.Subtract "PEC:Board", "PEC:Cavity"

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "43"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "40"

'@ switch working plane

Plot.DrawWorkplane "false"

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "47"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "46"

'@ define discrete port: 1

With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Impedance "50.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .Point1 "-0.35", "0.25", "36.996047883251" 
     .Point2 "0.35", "0.25", "36.996047883251" 
     .UsePickedPoints "True" 
     .LocalCoordinates "False" 
     .Monitor "False" 
     .Create 
End With

'@ define frequency range

Solver.FrequencyRange "0.1", "2"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-30" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ define farfield monitor: farfield (f=1)

With Monitor 
     .Delete "farfield (f=10)" 
End With 
With Monitor 
     .Reset 
     .Name "farfield (f=1)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "1" 
     .Create 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define frequency range

Solver.FrequencyRange "2", "7"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ define farfield monitor: farfield (f=5)

With Monitor 
     .Delete "farfield (f=1)" 
End With 
With Monitor 
     .Reset 
     .Name "farfield (f=5)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "5" 
     .Create 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ farfield plot options

With FarfieldPlot 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .SetTheta360 "False" 
     .CartSymRange "False" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define farfield monitor: farfield (f=4.5)

With Monitor 
     .Reset 
     .Name "farfield (f=4.5)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "4.5" 
     .Create 
End With

'@ define farfield monitor: farfield (f=6)

With Monitor 
     .Reset 
     .Name "farfield (f=6)" 
     .Domain "Frequency" 
     .FieldType "Farfield" 
     .Frequency "6" 
     .Create 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ delete curve item: 2D-Analytical:spline_1

Curve.DeleteCurveItem "2D-Analytical", "spline_1"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "27"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "24"

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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ transform port: translate port1

With Transform 
     .Reset 
     .Name "port1" 
     .Vector "0", "0", "vec" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .TranslatePort 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "46"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "38"

'@ farfield plot options

With FarfieldPlot 
     .SetColorByValue "True" 
     .DrawStepLines "False" 
     .DrawIsoLongitudeLatitudeLines "False" 
     .SetTheta360 "False" 
     .CartSymRange "False" 
     .SetPlotMode "Directivity" 
     .Distance "1" 
     .UseFarfieldApproximation "True" 
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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "48"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "45"

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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ define frequency range

Solver.FrequencyRange "3", "8"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "46"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "38"

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "50" 
     .LinesPerWavelength "25" 
     .MinimumLineNumber "25" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "50" 
     .LinesPerWavelength "15" 
     .MinimumLineNumber "15" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "none" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "none" 
     .Ysymmetry "none" 
     .Zsymmetry "none" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
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
     .RatioLimit "50" 
     .LinesPerWavelength "20" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set parametersweep options

With ParameterSweep
    .SetSimulationType "Transient" 
End With

'@ add parsweep sequence: Sequence 1

With ParameterSweep
     .AddSequence "Sequence 1" 
End With

'@ add parsweep parameter: Sequence 1:rcyl

With ParameterSweep
     .AddParameter "Sequence 1", "rcyl", "True", "4.8", "5.2", "5" 
End With

'@ add watch: |S1,1|

With ParameterSweep
     .AddSparameterWatch "magLin", "1", "0", "1", "0" 
End With

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "46"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ add watch: |S1,1| in dB

With ParameterSweep
     .AddSparameterWatch "magdB", "1", "0", "1", "0" 
End With

'@ delete watch: |S1,1|

With ParameterSweep
     .DeleteWatch "|S1,1|" 
End With

'@ edit parsweep parameter: Sequence 1:rcyl

With ParameterSweep
     .DeleteParameter "Sequence 1", "rcyl" 
     .AddParameter "Sequence 1", "rcyl", "True", "5.1", "5.5", "3" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ delete parsweep parameter: Sequence 1:rcyl

With ParameterSweep
     .DeleteParameter "Sequence 1", "rcyl" 
End With

'@ add parsweep parameter: Sequence 1:Ws

With ParameterSweep
     .AddParameter "Sequence 1", "Ws", "True", "0.18", "0.22", "3" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "50" 
     .LinesPerWavelength "30" 
     .MinimumLineNumber "30" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ edit parsweep parameter: Sequence 1:Ws

With ParameterSweep
     .DeleteParameter "Sequence 1", "Ws" 
     .AddParameter "Sequence 1", "Ws", "True", "0.17", "0.19", "3" 
End With

'@ add parsweep parameter: Sequence 1:rcyl

With ParameterSweep
     .AddParameter "Sequence 1", "rcyl", "True", "5.3", "5.7", "3" 
End With

'@ delete parsweep parameter: Sequence 1:rcyl

With ParameterSweep
     .DeleteParameter "Sequence 1", "rcyl" 
End With

'@ add parsweep sequence: Sequence 2

With ParameterSweep
     .AddSequence "Sequence 2" 
End With

'@ add parsweep parameter: Sequence 2:rcyl

With ParameterSweep
     .AddParameter "Sequence 2", "rcyl", "True", "5.3", "5.7", "5" 
End With

'@ add parsweep sequence: Sequence 3

With ParameterSweep
     .AddSequence "Sequence 3" 
End With

'@ add parsweep parameter: Sequence 3:zc

With ParameterSweep
     .AddParameter "Sequence 3", "zc", "True", "10.2", "11", "9" 
End With

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "50" 
     .LinesPerWavelength "20" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "41"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "46"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "42"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "25"

'@ define frequency range

Solver.FrequencyRange "3", "7"

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "50" 
     .LinesPerWavelength "36" 
     .MinimumLineNumber "36" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "Time" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "2" 
    .MaxPasses "5" 
    .MeshIncrement "4" 
    .MaxDeltaS "0.02" 
    .SetFrequencyRange "True", "0", "0" 
End With

'@ define special solver parameters

With Solver 
     .TimeBetweenUpdates "1200" 
     .NumberOfPulseWidths "40" 
     .EnergyBalanceLimit "0.03" 
     .UseArfilter "False" 
     .ArMaxEnergyDeviation "0.1" 
     .ArPulseSkip "1" 
     .WaveguideBroadband "False" 
     .SetBBPSamples "5" 
     .SetSamplesFullDeembedding "20" 
     .MatrixDump "False" 
     .TimestepReduction "0.45" 
     .NumberOfSubcycles "4" 
     .SubcycleFillLimit "70" 
     .UseParallelization "True" 
     .MaximumNumberOfProcessors "2" 
     .TimeStepStabilityFactor "1.0" 
     .UseOpenBoundaryForHigherModes "True" 
     .SetModeFreqFactor "0.5" 
     .SurfaceImpedanceOrder "10" 
     .SetPortShielding "False" 
     .SetTimeStepMethod "Automatic" 
     .FrequencySamples "1001" 
     .ConsiderTwoPortReciprocity "True" 
     .UseTSTAtPort "True" 
     .SubGridTimeCycling "True" 
     .SParaAdjustment "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "True" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "40" 
    .MinimumLineNumber "40" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "38"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "37"

'@ delete port: port1

Port.Delete "1"

'@ clear picks

Pick.ClearAllPicks

'@ pick mid point

Pick.PickMidpointFromId "PEC:Board", "69"

'@ pick mid point

Pick.PickMidpointFromId "PEC:Board", "67"

'@ define discrete port: 1

With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Impedance "50.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .Point1 "-0.09", "0", "16.099263587063" 
     .Point2 "0.09", "0", "16.099263587063" 
     .UsePickedPoints "True" 
     .LocalCoordinates "False" 
     .Monitor "False" 
     .Create 
End With

'@ transform port: translate port1

With Transform 
     .Reset 
     .Name "port1" 
     .Vector "0", "0", "vec" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .TranslatePort 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "48"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "47"

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "none" 
End With

'@ define frequency range

Solver.FrequencyRange "2.8", "3.6"

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "20" 
     .LinesPerWavelength "20" 
     .MinimumLineNumber "20" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define special solver parameters

With Solver 
     .TimeBetweenUpdates "1200" 
     .NumberOfPulseWidths "20" 
     .EnergyBalanceLimit "0.03" 
     .UseArfilter "False" 
     .ArMaxEnergyDeviation "0.1" 
     .ArPulseSkip "1" 
     .WaveguideBroadband "False" 
     .SetBBPSamples "5" 
     .SetSamplesFullDeembedding "20" 
     .MatrixDump "False" 
     .TimestepReduction "0.45" 
     .NumberOfSubcycles "4" 
     .SubcycleFillLimit "70" 
     .UseParallelization "True" 
     .MaximumNumberOfProcessors "2" 
     .TimeStepStabilityFactor "1.0" 
     .UseOpenBoundaryForHigherModes "True" 
     .SetModeFreqFactor "0.5" 
     .SurfaceImpedanceOrder "10" 
     .SetPortShielding "False" 
     .SetTimeStepMethod "Automatic" 
     .FrequencySamples "1001" 
     .ConsiderTwoPortReciprocity "True" 
     .UseTSTAtPort "True" 
     .SubGridTimeCycling "False" 
     .SParaAdjustment "True" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ define frequency range

Solver.FrequencyRange "4.", "5.5"

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "False" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "Time" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "2" 
    .MaxPasses "5" 
    .MeshIncrement "5" 
    .MaxDeltaS "0.02" 
    .SetFrequencyRange "True", "0", "0" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "True" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "40" 
    .MinimumLineNumber "40" 
End With

'@ set 3d mesh adaptation properties

With MeshAdaption3D
    .SetType "Time" 
    .SetAdaptionStrategy "ExpertSystem" 
    .MinPasses "2" 
    .MaxPasses "3" 
    .MeshIncrement "5" 
    .MaxDeltaS "0.02" 
    .SetFrequencyRange "True", "0", "0" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "True" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "45" 
    .MinimumLineNumber "45" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "38"

'@ pick end point

Pick.PickEndpointFromId "PEC:Board", "46"

'@ delete port: port1

Port.Delete "1"

'@ pick face

Pick.PickFaceFromId "PEC:Board", "31"

'@ define extrude: PEC:solid1

With Extrude 
     .Reset 
     .Name "solid1" 
     .Component "PEC" 
     .Material "PEC" 
     .Mode "Picks" 
     .Height "0" 
     .Twist "0.0" 
     .Taper "0.0" 
     .UsePicksForHeight "True" 
     .DeleteBaseFaceSolid "False" 
     .ClearPickedFace "True" 
     .Create 
End With

'@ delete shape: PEC:Board

Solid.Delete "PEC:Board"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "47"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "46"

'@ define discrete port: 1

With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Impedance "50.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .Point1 "-0.09", "6", "16.599324962027" 
     .Point2 "0.09", "6", "16.599324962027" 
     .UsePickedPoints "True" 
     .LocalCoordinates "False" 
     .Monitor "False" 
     .Create 
End With

'@ transform port: translate port1

With Transform 
     .Reset 
     .Name "port1" 
     .Vector "0", "0", "vec" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .TranslatePort 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "6" 
     .MinimumStepNumberTet "20" 
     .MeshType "Tetrahedral" 
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
     .FDSolverStimulation "All", "1" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ define frequency range

Solver.FrequencyRange "3.8", "4.8"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "12" 
     .MinimumStepNumberTet "30" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ define frequency range

Solver.FrequencyRange "3.5", "6.5"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "47"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "41"

'@ define frequency range

Solver.FrequencyRange "3.", "7"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "46"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "38"

'@ define frequency range

Solver.FrequencyRange "5", "7"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "25"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "42"

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "10" 
     .MinimumStepNumberTet "20" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ define frequency range

Solver.FrequencyRange "3", "7"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "38"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "46"

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
     .SetPhaseCenterPlane "H-plane" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "12" 
     .MinimumStepNumberTet "20" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ set parametersweep options

With ParameterSweep
    .SetSimulationType "Frequency" 
End With

'@ delete parsweep sequence: Sequence 2

With ParameterSweep
     .DeleteSequence "Sequence 2" 
End With

'@ delete parsweep sequence: Sequence 3

With ParameterSweep
     .DeleteSequence "Sequence 3" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "none" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ delete parsweep parameter: Sequence 1:Ws

With ParameterSweep
     .DeleteParameter "Sequence 1", "Ws" 
End With

'@ add parsweep parameter: Sequence 1:b

With ParameterSweep
     .AddParameter "Sequence 1", "b", "True", "50", "100", "11" 
End With

'@ add watch: userdefined

With ParameterSweep
     .AddUserdefinedWatch
End With

'@ delete watch: Userdefined

With ParameterSweep
     .DeleteWatch "Userdefined" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "10" 
     .MinimumStepNumberTet "20" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "41"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "47"

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ delete parsweep parameter: Sequence 1:b

With ParameterSweep
     .DeleteParameter "Sequence 1", "b" 
End With

'@ add parsweep parameter: Sequence 1:C2

With ParameterSweep
     .AddParameter "Sequence 1", "C2", "True", "1.03", "1.38", "8" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "10" 
     .MinimumStepNumberTet "20" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "12" 
     .MinimumStepNumberTet "20" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "12" 
     .MinimumStepNumberTet "24" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-40" 
     .MeshAdaption "True" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseNetworkComputing "False" 
End With

'@ set pba mesh type

Mesh.MeshType "PBA"

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "45" 
    .MinimumLineNumber "45" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "12" 
     .MinimumStepNumberTet "24" 
     .MeshType "Tetrahedral" 
End With

'@ define frequency domain solver parameters

With Solver
     .CalculationType "FD-S" 
     .FDSolverReset 
     .FDSolverMethod "Tetrahedral Mesh" 
     .FDSolverOrder "Second" 
     .FDSolverStimulation "All", "1" 
     .FDSolverResetExcitationList 
     .FDSolverAutoNormImpedance "False" 
     .FDSolverNormingImpedance "50" 
     .FDSolverModesOnly "False" 
     .FDSolverAccuracyHex "1e-6" 
     .FDSolverAccuracyTet "1e-5" 
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
     .FDSolverAddFrequencyIntervall "", "", "1", "Adaptation" 
     .FDSolverAddFrequencyIntervall "", "", "", "Automatic" 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "16" 
     .MinimumStepNumberTet "30" 
     .MeshType "Tetrahedral" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ pick mid point

Pick.PickMidpointFromId "PEC:solid1", "40"

'@ align wcs with point

WCS.AlignWCSWithSelectedPoint

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "47"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "38"

'@ define frequency range

Solver.FrequencyRange "4", "6"

'@ clear picks

Pick.ClearAllPicks

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "47"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "46"

'@ store picked point: 3

Pick.NextPickToDatabase "3" 
Pick.PickEndpointFromId "PEC:solid1", "47"

'@ store picked point: 4

Pick.NextPickToDatabase "4" 
Pick.PickEndpointFromId "PEC:solid1", "46"

'@ define brick: PEC:solid2

With Brick
     .Reset 
     .Name "solid2" 
     .Component "PEC" 
     .Material "Vacuum" 
     .Xrange "xp(3)", "xp(4)" 
     .Yrange "yp(3) - 0.5*(0.20300030006001)", "yp(3) + 0.5*(0.20300030006001)" 
     .Zrange "0", "0" 
     .Create
End With

'@ pick face

Pick.PickFaceFromId "PEC:solid1", "11"

'@ align wcs with face

WCS.AlignWCSWithSelectedFace 
Pick.PickCenterpointFromId "PEC:solid1", "11" 
WCS.AlignWCSWithSelectedPoint

'@ delete shape: PEC:solid2

Solid.Delete "PEC:solid2"

'@ store picked point: 5

Pick.NextPickToDatabase "5" 
Pick.PickEndpointFromId "PEC:solid1", "47"

'@ store picked point: 6

Pick.NextPickToDatabase "6" 
Pick.PickEndpointFromId "PEC:solid1", "46"

'@ define brick: PEC:solid2

With Brick
     .Reset 
     .Name "solid2" 
     .Component "PEC" 
     .Material "Vacuum" 
     .Xrange "xp(5)", "xp(6)" 
     .Yrange "yp(5) - 0.5*(0.17473341853)", "yp(5) + 0.5*(0.17473341853)" 
     .Zrange "0", "0" 
     .Create
End With

'@ transform: translate PEC:solid2

With Transform 
     .Reset 
     .Name "PEC:solid2" 
     .Vector "0", "-vec", "0" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .TranslateAdvanced 
End With

'@ pick edge

Pick.PickEdgeFromId "PEC:solid2", "3", "3"

'@ pick edge

Pick.PickEdgeFromId "PEC:solid2", "1", "1"

'@ define discrete face port: 2

With DiscreteFacePort 
     .Reset 
     .PortNumber "2" 
     .Type "SParameter" 
     .Impedance "50.0" 
     .VoltageAmplitude "1.0" 
     .VoltagePhase "0.0" 
     .Point1 "-0.149997037392", "25.187366709265", "0" 
     .Point2 "0.150002962608", "25.187366709265", "0" 
     .LocalCoordinates "True" 
     .SwapDirection "False" 
     .CenterEdge "True" 
     .Create 
End With

'@ delete port: port1

Port.Delete "1"

'@ rename port: 2 to: 1

Port.Rename "2", "1"

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthSrf "4" 
     .MinimumStepNumberSrf "2" 
     .MeshType "Surface" 
     .MaterialRefinementTet "True" 
End With

'@ define frequency range

Solver.FrequencyRange "3", "7"

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthSrf "mesh_r" 
     .MinimumStepNumberSrf "2" 
     .MeshType "Surface" 
     .MaterialRefinementTet "True" 
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Surface Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .SweepErrorThreshold "True", "0.001" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ delete parsweep parameter: Sequence 1:C2

With ParameterSweep
     .DeleteParameter "Sequence 1", "C2" 
End With

'@ add parsweep sequence: Sequence 2

With ParameterSweep
     .AddSequence "Sequence 2" 
End With

'@ delete parsweep sequence: Sequence 2

With ParameterSweep
     .DeleteSequence "Sequence 2" 
End With

'@ add parsweep parameter: Sequence 1:mesh_r

With ParameterSweep
     .AddParameter "Sequence 1", "mesh_r", "True", "3", "5", "3" 
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Surface Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "2" 
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
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
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
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ new curve: curve1

Curve.NewCurve "curve1"

'@ store picked point: 7

Pick.NextPickToDatabase "7" 
Pick.PickMidpointFromId "PEC:solid2", "3"

'@ define curve arc: curve1:arc1

With Arc
     .Reset 
     .Name "arc1" 
     .Curve "curve1" 
     .Orientation "Clockwise" 
     .XCenter "xp(7)" 
     .YCenter "yp(7)" 
     .X1 "-0.2" 
     .Y1 "25" 
     .X2 "-0.2" 
     .Y2 "25.4" 
     .Segments "0" 
     .Create
End With

'@ pick end point

Pick.PickCurveEndpointFromId "curve1:arc1", "1"

'@ store picked point: 8

Pick.NextPickToDatabase "8" 
Pick.PickCurveEndpointFromId "curve1:arc1", "1"

'@ store picked point: 9

Pick.NextPickToDatabase "9" 
Pick.PickCurveEndpointFromId "curve1:arc1", "2"

'@ define curve line: curve1:line1

With Line
     .Reset 
     .Name "line1" 
     .Curve "curve1" 
     .X1 "xp(8)" 
     .Y1 "yp(8)" 
     .X2 "xp(9)" 
     .Y2 "yp(9)" 
     .Create
End With

'@ delete curves

Curve.DeleteCurve "2D-Analytical" 
Curve.DeleteCurve "curve1"

'@ clear picks

Pick.ClearAllPicks

'@ pick face

Pick.PickFaceFromId "PEC:solid2", "1"

'@ align wcs with face

WCS.AlignWCSWithSelectedFace 
Pick.PickCenterpointFromId "PEC:solid2", "1" 
WCS.AlignWCSWithSelectedPoint

'@ store picked point: 10

Pick.NextPickToDatabase "10" 
Pick.PickMidpointFromId "PEC:solid2", "3"

'@ define cylinder: PEC:solid3

With Cylinder 
     .Reset 
     .Name "solid3" 
     .Component "PEC" 
     .Material "Vacuum" 
     .OuterRadius "0.2" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "0" 
     .Xcenter "xp(10)" 
     .Ycenter "yp(10)" 
     .Segments "0" 
     .Create 
End With

'@ store picked point: 11

Pick.NextPickToDatabase "11" 
Pick.PickMidpointFromId "PEC:solid2", "1"

'@ define cylinder: PEC:solid4

With Cylinder 
     .Reset 
     .Name "solid4" 
     .Component "PEC" 
     .Material "PEC" 
     .OuterRadius "0.2" 
     .InnerRadius "0" 
     .Axis "z" 
     .Zrange "0", "0" 
     .Xcenter "xp(11)" 
     .Ycenter "yp(11)" 
     .Segments "0" 
     .Create 
End With

'@ change material: PEC:solid3 to: PEC

Solid.ChangeMaterial "PEC:solid3", "PEC"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid2", "4"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid2", "3"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid2", "1"

'@ align wcs with three points

WCS.AlignWCSWithThreeSelectedPoints

'@ rotate wcs

WCS.RotateWCS "u", "90"

'@ slice shape: PEC:solid3

Solid.SliceShape "solid3", "PEC"

'@ delete shape: PEC:solid3_1

Solid.Delete "PEC:solid3_1"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid2", "1"

'@ align wcs with point

WCS.AlignWCSWithSelectedPoint

'@ slice shape: PEC:solid4

Solid.SliceShape "solid4", "PEC"

'@ delete shape: PEC:solid4

Solid.Delete "PEC:solid4"

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
     .MergeThinPECLayerFixpoints "True" 
     .EquilibrateMesh "False" 
     .EquilibrateMeshRatio "1.19" 
     .UseCellAspectRatio "False" 
     .CellAspectRatio "50.0" 
     .UsePecEdgeModel "True" 
     .MeshType "Surface" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "1000" 
     .CurvatureRefinementFactor "0.05" 
     .SmallFeatureSize "0.0" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .VolumeMeshMethod "Delaunay" 
     .DelaunayOptimizationLevel "2" 
     .DelaunayPropagationFactor "1.050000" 
     .DensityTransitions "0.5" 
     .MeshAllRegions "False" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAvoidNonRegUnite "False" 
     .DetectSmallSolidPEC "False" 
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .AlwaysExcludePec "False" 
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Surface Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "2" 
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
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
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
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ delete shape: PEC:solid2

Solid.Delete "PEC:solid2"

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Surface Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "2" 
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
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
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
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ edit parsweep parameter: Sequence 1:mesh_r

With ParameterSweep
     .DeleteParameter "Sequence 1", "mesh_r" 
     .AddParameter "Sequence 1", "mesh_r", "True", "3", "7", "5" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
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

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "20" 
     .LinesPerWavelength "45" 
     .MinimumLineNumber "45" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define pml specials

With Boundary
     .Layer "4" 
     .Reflection "0.0001" 
     .Progression "parabolic" 
     .MinimumLinesDistance "5" 
     .MinimumDistancePerWavelength "4" 
     .ActivePMLFactor "1.0" 
     .FrequencyForMinimumDistance "3" 
     .MinimumDistanceAtCenterFrequency "False" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
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

'@ define automesh for: PEC:solid3

Solid.SetMeshProperties "PEC:solid3", "PBA", "True" 
Solid.SetAutomeshParameters "PEC:solid3", "0", "True" 
Solid.SetAutomeshStepwidth "PEC:solid3", "0", "0", "0" 
Solid.SetAutomeshExtendwidth "PEC:solid3", "0", "0", "0" 
Solid.SetAutomeshRefinement "PEC:solid3", "False", "1.0", "True", "5" 
Solid.SetUseThinSheetMeshForShape "PEC:solid3", "False" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshProperties "PEC:solid4_1", "PBA", "True" 
Solid.SetAutomeshParameters "PEC:solid4_1", "0", "True" 
Solid.SetAutomeshStepwidth "PEC:solid4_1", "0", "0", "0" 
Solid.SetAutomeshExtendwidth "PEC:solid4_1", "0", "0", "0" 
Solid.SetAutomeshRefinement "PEC:solid4_1", "False", "1.0", "True", "5" 
Solid.SetUseThinSheetMeshForShape "PEC:solid4_1", "False" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ define automesh for: PEC:solid3

Solid.SetMeshProperties "PEC:solid3", "PBA", "True" 
Solid.SetAutomeshParameters "PEC:solid3", "0", "True" 
Solid.SetAutomeshStepwidth "PEC:solid3", "0", "0", "0" 
Solid.SetAutomeshExtendwidth "PEC:solid3", "0", "0", "0" 
Solid.SetAutomeshRefinement "PEC:solid3", "True", "5", "True", "11" 
Solid.SetUseThinSheetMeshForShape "PEC:solid3", "False" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshProperties "PEC:solid4_1", "PBA", "True" 
Solid.SetAutomeshParameters "PEC:solid4_1", "0", "True" 
Solid.SetAutomeshStepwidth "PEC:solid4_1", "0", "0", "0" 
Solid.SetAutomeshExtendwidth "PEC:solid4_1", "0", "0", "0" 
Solid.SetAutomeshRefinement "PEC:solid4_1", "True", "5", "True", "11" 
Solid.SetUseThinSheetMeshForShape "PEC:solid4_1", "False" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "47"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid1", "46"

'@ define automesh for: PEC:solid3

Solid.SetMeshProperties "PEC:solid3", "PBA", "True" 
Solid.SetAutomeshParameters "PEC:solid3", "0", "True" 
Solid.SetAutomeshStepwidth "PEC:solid3", "0.3/5", "0.3/5", "0" 
Solid.SetAutomeshExtendwidth "PEC:solid3", "0.3", "0.3", "0" 
Solid.SetAutomeshRefinement "PEC:solid3", "True", "5", "True", "11" 
Solid.SetUseThinSheetMeshForShape "PEC:solid3", "False" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshProperties "PEC:solid4_1", "PBA", "True" 
Solid.SetAutomeshParameters "PEC:solid4_1", "0", "True" 
Solid.SetAutomeshStepwidth "PEC:solid4_1", "0.3/5", "0.3/5", "0" 
Solid.SetAutomeshExtendwidth "PEC:solid4_1", "0.3", "0.3", "0" 
Solid.SetAutomeshRefinement "PEC:solid4_1", "True", "5", "True", "11" 
Solid.SetUseThinSheetMeshForShape "PEC:solid4_1", "False" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ set mesh properties

With Mesh 
     .UseRatioLimit "True" 
     .RatioLimit "25" 
     .LinesPerWavelength "45" 
     .MinimumLineNumber "45" 
     .Automesh "True" 
     .MeshType "PBA" 
End With

'@ define solver parameters

With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "True" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseDistributedComputing "False" 
End With

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "45" 
    .MinimumLineNumber "45" 
End With

'@ define pml specials

With Boundary
     .Layer "4" 
     .Reflection "0.0001" 
     .Progression "parabolic" 
     .MinimumLinesDistance "5" 
     .MinimumDistancePerWavelength "1" 
     .ActivePMLFactor "1.0" 
     .FrequencyForMinimumDistance "3" 
     .MinimumDistanceAtCenterFrequency "False" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "none" 
     .XminThermal "isothermal" 
     .XmaxThermal "isothermal" 
     .YminThermal "isothermal" 
     .YmaxThermal "isothermal" 
     .ZminThermal "isothermal" 
     .ZmaxThermal "isothermal" 
     .XsymmetryThermal "isothermal" 
     .YsymmetryThermal "adiabatic" 
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

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "5" 
     .MinimumStepNumberTet "30" 
     .MeshType "Tetrahedral" 
     .MeshAllRegions "False" 
     .MaterialRefinementTet "True" 
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Tetrahedral Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "2" 
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
     .ExtrudeOpenBC "False" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
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
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ pick edge

Pick.PickEdgeFromId "PEC:solid3", "2", "2"

'@ define automesh for: PEC:solid3

Solid.SetAutomeshStepwidthTet "PEC:solid3", "0.5" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetAutomeshStepwidthTet "PEC:solid4_1", "0.5" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthSrf "mesh_r" 
     .MinimumStepNumberSrf "2" 
     .MeshType "Surface" 
     .MaterialRefinementTet "True" 
End With

'@ define automesh for: PEC:solid3

Solid.SetAutomeshStepwidthSrf "PEC:solid3", "000.5" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetAutomeshStepwidthSrf "PEC:solid4_1", "000.5" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ define automesh for: PEC:solid3

Solid.SetAutomeshStepwidthSrf "PEC:solid3", "000.1" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetAutomeshStepwidthSrf "PEC:solid4_1", "000.1" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ define automesh for: PEC:solid3

Solid.SetAutomeshStepwidthSrf "PEC:solid3", "000.2" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetAutomeshStepwidthSrf "PEC:solid4_1", "000.2" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ set tetrahedral mesh type

Mesh.MeshType "Tetrahedral"

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthSrf "mesh_r" 
     .MinimumStepNumberSrf "2" 
     .MeshType "Surface" 
     .MaterialRefinementTet "True" 
End With

'@ define frequency domain solver parameters

With FDSolver
     .Reset 
     .Method "Surface Mesh" 
     .OrderTet "Second" 
     .OrderSrf "Second" 
     .UseDistributedComputing "False" 
     .NetworkComputingStrategy "RunRemote" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "2" 
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
     .ExtrudeOpenBC "False" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
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
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ clear picks

Pick.ClearAllPicks

'@ delete port: port1

Port.Delete "1"

'@ pick mid point

Pick.PickMidpointFromId "PEC:solid1", "65"

'@ pick mid point

Pick.PickMidpointFromId "PEC:solid3", "1"

'@ pick mid point

Pick.PickMidpointFromId "PEC:solid4_1", "1"

'@ define discrete port: 1

With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Impedance "50.0" 
     .Voltage "1.0" 
     .Current "1.0" 
     .Point1 "0.087366709265002", "0", "0.3" 
     .Point2 "0.087366709265002", "0", "0" 
     .UsePickedPoints "True" 
     .LocalCoordinates "True" 
     .Monitor "False" 
     .Create 
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
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .ImproveBadElementQuality "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .ManualThetaRef "False" 
    .MultipleEdgeRef "False" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .LimitCPUs "False" 
     .MaxCPUs "2" 
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
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .AddMonitorSamples "True" 
     .SParameterSweep "True" 
     .CalcStatBField "False" 
     .UseDoublePrecision "False" 
     .MixedOrder "False" 
     .UsePreconditionerIntEq "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "2.5e-3" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "true" 
     .UseFastRCSSweepIntEq "true" 
     .SetRCSSweepProperties "0.0", "0.0", "0", "0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.001" 
     .SweepErrorChecks "2" 
     .SweepMinimumSamples "3" 
     .SweepConsiderAll "True" 
     .SweepConsiderReset 
     .InterpolationSamples "1001" 
     .SweepWeightEvanescent "1.0" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
End With

'@ RunAdaptivityTestsuite

StoreGlobalDataValue("RunAdaptivityTestsuite" , "1")

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
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .ErrorEstimatorType        "Error indicator 2" 
    .RefinementType            "Quality enhancement + multiple edge refinement" 
    .ImproveBadElementQuality "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .ManualThetaRef "False" 
    .MultipleEdgeRef "False" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .Type "Direct" 
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
     .MLFMMAccuracy "2.5e-3" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "true" 
     .UseFastRCSSweepIntEq "true" 
     .SetRCSSweepProperties "0.0", "0.0", "0", "0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.001" 
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
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With

'@ set tetrahedral mesh type

Mesh.MeshType "Tetrahedral"

'@ define automesh for: PEC:solid3

Solid.SetMeshStepwidthTet "PEC:solid3", "0" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshStepwidthTet "PEC:solid4_1", "0" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "4" 
     .MinimumStepNumberTet "10" 
     .MeshType "Tetrahedral" 
     .MeshAllRegions "False" 
     .MaterialRefinementTet "True" 
End With

'@ define pml specials

With Boundary
     .SetPMLType "ConvPML" 
     .Layer "4" 
     .Reflection "0.0001" 
     .Progression "parabolic" 
     .MinimumLinesDistance "5" 
     .MinimumDistancePerWavelength "2" 
     .ActivePMLFactor "1.0" 
     .FrequencyForMinimumDistance "3" 
     .MinimumDistanceAtCenterFrequency "False" 
     .SetConvPMLKMax "5.0" 
     .SetConvPMLExponentM "3" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .Type "Iterative" 
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
     .MLFMMAccuracy "2.5e-3" 
     .MinMLFMMBoxSize "0.20" 
     .UseCFIEForCPECIntEq "true" 
     .UseFastRCSSweepIntEq "true" 
     .SetRCSSweepProperties "0.0", "0.0", "0", "0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.001" 
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
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
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
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .ErrorEstimatorType        "Error indicator 2" 
    .RefinementType            "Quality enhancement + multiple edge refinement" 
    .ImproveBadElementQuality "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .ManualThetaRef "False" 
    .MultipleEdgeRef "False" 
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
     .SetAutomeshRefineDielectricsType "Generalized" 
     .MergeThinPECLayerFixpoints "True" 
     .EquilibrateMesh "False" 
     .EquilibrateMeshRatio "1.19" 
     .UseCellAspectRatio "False" 
     .CellAspectRatio "50.0" 
     .UsePecEdgeModel "True" 
     .MeshType "Tetrahedral" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "100" 
     .CurvatureRefinementFactor "0.05" 
     .AnisotropicCurvatureRefinement "False" 
     .SmallFeatureSize "0.0" 
     .SurfaceTolerance "0.0" 
     .SurfaceToleranceType "Relative" 
     .NormalTolerance "22.5" 
     .AnisotropicCurvatureRefinementFSM "False" 
     .SurfaceMeshEnrichment "0" 
     .DensityTransitionsFSM "0.5" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .VolumeMeshMethod "Delaunay" 
     .SurfaceMeshMethod "General" 
     .SurfaceMeshGeometryAccuracy "1.0e-6" 
     .DelaunayOptimizationLevel "2" 
     .DelaunayPropagationFactor "1.050000" 
     .DensityTransitions "0.5" 
     .MeshAllRegions "False" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAvoidNonRegUnite "False" 
     .DetectSmallSolidPEC "False" 
     .ConsiderSpaceForLowerMeshLimit "True" 
     .RatioLimitGovernsLocalRefinement "True" 
     .FastPBAGapDetection "False" 
     .FPBAGapTolerance "0.001" 
     .SetMaxParallelThreads "8"
     .SetParallelMode "Maximum"
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .AlwaysExcludePec "False" 
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
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .ErrorEstimatorType        "Error indicator 2" 
    .RefinementType            "Quality enhancement + multiple edge refinement" 
    .ImproveBadElementQuality "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .ManualThetaRef "False" 
    .MultipleEdgeRef "False" 
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
     .SetAutomeshRefineDielectricsType "Generalized" 
     .MergeThinPECLayerFixpoints "True" 
     .EquilibrateMesh "False" 
     .EquilibrateMeshRatio "1.19" 
     .UseCellAspectRatio "False" 
     .CellAspectRatio "50.0" 
     .UsePecEdgeModel "True" 
     .MeshType "Tetrahedral" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "3" 
     .MinimumCurvatureRefinement "500" 
     .CurvatureRefinementFactor "0.05" 
     .AnisotropicCurvatureRefinement "False" 
     .SmallFeatureSize "0.0" 
     .SurfaceTolerance "0.0" 
     .SurfaceToleranceType "Relative" 
     .NormalTolerance "22.5" 
     .AnisotropicCurvatureRefinementFSM "False" 
     .SurfaceMeshEnrichment "0" 
     .DensityTransitionsFSM "0.5" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .VolumeMeshMethod "Delaunay" 
     .SurfaceMeshMethod "General" 
     .SurfaceMeshGeometryAccuracy "1.0e-6" 
     .DelaunayOptimizationLevel "2" 
     .DelaunayPropagationFactor "1.050000" 
     .DensityTransitions "0.5" 
     .MeshAllRegions "False" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAvoidNonRegUnite "False" 
     .DetectSmallSolidPEC "False" 
     .ConsiderSpaceForLowerMeshLimit "True" 
     .RatioLimitGovernsLocalRefinement "True" 
     .FastPBAGapDetection "False" 
     .FPBAGapTolerance "0.001" 
     .SetMaxParallelThreads "8"
     .SetParallelMode "Maximum"
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .AlwaysExcludePec "False" 
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
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .ErrorEstimatorType        "Error indicator 2" 
    .RefinementType            "Bisection + quality enhancement" 
    .ImproveBadElementQuality "True" 
    .SubsequentChecksOnlyOnce "False" 
    .WavelengthBasedRefinement "True" 
    .ManualThetaRef "False" 
    .MultipleEdgeRef "False" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .Type "Iterative" 
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
     .SetRCSSweepProperties "0.0", "0.0", "0", "0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.001" 
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
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With
With IESolver
     .SetFMMFFCalcStopLevel "2" 
     .SetFMMFFCalcNumInterpPoints "4" 
     .UseFMMFarfieldCalc "False" 
End With

'@ delete port: port1

Port.Delete "1"

'@ pick edge

Pick.PickEdgeFromId "PEC:solid3", "1", "1"

'@ pick edge

Pick.PickEdgeFromId "PEC:solid4_1", "1", "1"

'@ define discrete face port: 1

With DiscreteFacePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter" 
     .Impedance "50.0" 
     .VoltageAmplitude "1.0" 
     .Point1 "0.087366709265002", "0", "0.3" 
     .Point2 "0.087366709265002", "0", "0" 
     .LocalCoordinates "True" 
     .SwapDirection "False" 
     .CenterEdge "True" 
     .Monitor "False" 
     .Create 
End With

'@ set mesh properties

With Mesh 
     .StepsPerWavelengthTet "4" 
     .MinimumStepNumberTet "10" 
     .MeshType "Tetrahedral" 
     .MeshAllRegions "False" 
     .MaterialRefinementTet "True" 
End With

'@ define solver parameters

Mesh.SetCreator "High Frequency" 
With Solver 
     .CalculationType "TD-S" 
     .StimulationPort "All" 
     .StimulationMode "All" 
     .SteadyStateLimit "-50" 
     .MeshAdaption "True" 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .CalculateModesOnly "False" 
     .SParaSymmetry "False" 
     .StoreTDResultsInCache "False" 
     .FullDeembedding "False" 
     .UseDistributedComputing "False" 
     .DistributeMatrixCalculation "False" 
     .MPIParallelization "False" 
     .SuperimposePLWExcitation "False" 
End With

'@ set pba mesh type

Mesh.MeshType "PBA"

'@ set 3d mesh adaptation results

With Mesh 
    .LinesPerWavelength "45" 
    .MinimumLineNumber "45" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .Type "Iterative" 
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
     .SetRCSSweepProperties "0.0", "0.0", "0", "0.0", "0.0", "0", "0" 
     .SweepErrorThreshold "True", "0.001" 
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
    .MaxPasses "20" 
    .MeshIncrement "5" 
    .MaxDeltaS "0.01" 
    .NumberOfDeltaSChecks "2" 
    .PropagationConstantAccuracy "0.005" 
    .NumberOfPropConstChecks   "2" 
    .MinimumAcceptedCellGrowth "0.5" 
    .RefThetaFactor            "30" 
    .SetMinimumMeshCellGrowth  "5" 
    .ErrorEstimatorType        "Error indicator 2" 
    .RefinementType            "Bisection + quality enhancement" 
    .ImproveBadElementQuality  "True" 
    .SubsequentChecksOnlyOnce  "False" 
    .WavelengthBasedRefinement "True" 
    .ManualThetaRef  "False" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .SweepErrorThreshold "True", "0.001" 
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
    .MaxPasses "20" 
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

'@ define automesh for: PEC:solid3

Solid.SetMeshStepwidthTet "PEC:solid3", "1" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshStepwidthTet "PEC:solid4_1", "1" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ define automesh for: PEC:solid3

Solid.SetMeshStepwidthTet "PEC:solid3", "0.25" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshStepwidthTet "PEC:solid4_1", "0.25" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ define automesh parameters

With Mesh 
     .AutomeshStraightLines "True" 
     .AutomeshEllipticalLines "True" 
     .AutomeshRefineAtPecLines "True", "4" 
     .AutomeshRefinePecAlongAxesOnly "False" 
     .AutomeshAtEllipseBounds "True", "10" 
     .AutomeshAtWireEndPoints "True" 
     .AutomeshAtProbePoints "True" 
     .SetAutomeshRefineDielectricsType "Generalized" 
     .MergeThinPECLayerFixpoints "True" 
     .EquilibrateMesh "False" 
     .EquilibrateMeshRatio "1.19" 
     .UseCellAspectRatio "False" 
     .CellAspectRatio "50.0" 
     .UsePecEdgeModel "True" 
     .MeshType "Tetrahedral" 
     .AutoMeshLimitShapeFaces "True" 
     .AutoMeshNumberOfShapeFaces "1000" 
     .PointAccEnhancement "0" 
     .SurfaceOptimization "True" 
     .SurfaceSmoothing "6" 
     .MinimumCurvatureRefinement "500" 
     .CurvatureRefinementFactor "0.05" 
     .AnisotropicCurvatureRefinement "False" 
     .SmallFeatureSize "0.0" 
     .SurfaceTolerance "0.0" 
     .SurfaceToleranceType "Relative" 
     .NormalTolerance "22.5" 
     .AnisotropicCurvatureRefinementFSM "False" 
     .SurfaceMeshEnrichment "0" 
     .DensityTransitionsFSM "0.5" 
     .VolumeOptimization "True" 
     .VolumeSmoothing "True" 
     .VolumeMeshMethod "Delaunay" 
     .SurfaceMeshMethod "General" 
     .SurfaceMeshGeometryAccuracy "1.0e-6" 
     .DelaunayOptimizationLevel "2" 
     .DelaunayPropagationFactor "1.050000" 
     .DensityTransitions "1" 
     .MeshAllRegions "False" 
     .ConvertGeometryDataAfterMeshing "True" 
     .AutomeshFixpointsForBackground "True" 
     .PBAType "Fast PBA" 
     .AutomaticPBAType "True" 
     .FPBAAvoidNonRegUnite "False" 
     .DetectSmallSolidPEC "False" 
     .ConsiderSpaceForLowerMeshLimit "True" 
     .RatioLimitGovernsLocalRefinement "True" 
     .GapDetection "False" 
     .FPBAGapTolerance "0.001" 
     .MaxParallelThreads "8"
     .SetParallelMode "Maximum"
End With 
With Solver 
     .UseSplitComponents "True" 
     .PBAFillLimit "99" 
     .EnableSubgridding "False" 
     .AlwaysExcludePec "False" 
End With

'@ define boundaries

With Boundary
     .Xmin "expanded open" 
     .Xmax "expanded open" 
     .Ymin "expanded open" 
     .Ymax "expanded open" 
     .Zmin "expanded open" 
     .Zmax "expanded open" 
     .Xsymmetry "electric" 
     .Ysymmetry "magnetic" 
     .Zsymmetry "none" 
     .XminThermal "isothermal" 
     .XmaxThermal "isothermal" 
     .YminThermal "isothermal" 
     .YmaxThermal "isothermal" 
     .ZminThermal "isothermal" 
     .ZmaxThermal "isothermal" 
     .XsymmetryThermal "isothermal" 
     .YsymmetryThermal "adiabatic" 
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

'@ define automesh for: PEC:solid1

Solid.SetMeshStepwidthTet "PEC:solid1", "0" 
Solid.SetUseForSimulation "PEC:solid1", "True" 
Solid.SetUseForBoundingBox "PEC:solid1", "True"

'@ define automesh for: PEC:solid3

Solid.SetMeshStepwidthTet "PEC:solid3", "0" 
Solid.SetUseForSimulation "PEC:solid3", "True" 
Solid.SetUseForBoundingBox "PEC:solid3", "True"

'@ define automesh for: PEC:solid4_1

Solid.SetMeshStepwidthTet "PEC:solid4_1", "0" 
Solid.SetUseForSimulation "PEC:solid4_1", "True" 
Solid.SetUseForBoundingBox "PEC:solid4_1", "True"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid4_1", "1"

'@ pick end point

Pick.PickEndpointFromId "PEC:solid3", "2"

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
     .XminSpace "20" 
     .XmaxSpace "20" 
     .YminSpace "20" 
     .YmaxSpace "20" 
     .ZminSpace "20" 
     .ZmaxSpace "20" 
     .ApplyInAllDirections "True" 
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
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-5" 
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
     .SweepErrorThreshold "True", "0.001" 
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
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .PreconditionerType "Auto" 
End With
With IESolver
     .SetFMMFFCalcStopLevel "2" 
     .SetFMMFFCalcNumInterpPoints "4" 
     .UseFMMFarfieldCalc "False" 
End With

'@ activate global coordinates

WCS.ActivateWCS "global"


'@ clear picks

Pick.ClearAllPicks 


