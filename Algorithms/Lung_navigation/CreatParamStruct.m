function Param = CreatParamStruct()

%% Tree table
Param.Sub = [1,2,3];
Param.Ind = 4;
Param.UnitVec = [5,6,7];
Param.Diameter = 8;
Param.VecMagnitude = 9;
Param.PathLength = 10;
Param.TargetDis = 11;
Param.Cost = 12;
Param.PerentInd = 13;
Param.MatrixSize = [1,13];

%% Algorithm parameters
Param.TargetSize = 3;
Param.TargetValue = true%3;
Param.MinDistanceRequiredFromTarget = 5;
Param.CostRatio = 2;
Param.LineLength = 100;
Param.LineDensity = 70;
Param.ExpendDensity = 5;
Param.SaveEachPointInLine = 5;
Param.SpaceThreshold = 0.02;
Param.PathValue = true%2;
Param.SapceSize = [];

Param.VecMagnitudeRatio = 1.5;
Param.DiameterRatio = 2;
Param.DeleteScanedPointZone = 4;
end
