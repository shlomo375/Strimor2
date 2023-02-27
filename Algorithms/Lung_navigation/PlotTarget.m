function [Volume,ScannedSpace] = PlotTarget(Volume,ScannedSpace,Coord,Range)
Param = CreatParamStruct();

Sub = [Coord(2),Coord(1),Coord(3)];
ScannedSpace(Sub(1)-Range:Sub(1)+Range,Sub(2)-Range:Sub(2)+Range,Sub(3)-Range:Sub(3)+Range) = Param.TargetValue;

Volume = ShowValume(ScannedSpace,Volume);
end
