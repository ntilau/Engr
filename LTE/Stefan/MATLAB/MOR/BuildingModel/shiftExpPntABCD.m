function ModelShifted = shiftExpPntABCD(Model, expPnt)

ModelShifted.A = shiftExpPoint(Model.A, Model.permutMat, expPnt);
ModelShifted.B = shiftExpPoint(Model.B, Model.permutMat, expPnt);
ModelShifted.C = shiftExpPoint(Model.C, Model.permutMat, expPnt);
ModelShifted.permutMat = Model.permutMat;
