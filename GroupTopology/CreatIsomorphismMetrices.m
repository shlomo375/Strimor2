function [IsomorphismMetrices,IsomorphismStr,IsomorpSizes] = CreatIsomorphismMetrices(ConfigMat,ConfigType,RotationMatrices)
IsomorpSizes = zeros(3,2);
IsomorphismStr = ["","",""];
if nargin < 3
    WSConfig = WorkSpace(size(ConfigMat),"RRT*");

    RotationMatrices = {WSConfig.R1, WSConfig.R2, WSConfig.R3};
end
IsomorphismMetrices = cell(1,3);

[IsomorphismMetrices{1},GroupIndexes] = ConfigGroupSizes(ConfigMat,ConfigType);
IsomorpSizes(1,1:2) = size(IsomorphismMetrices{1});

IsomorphismMetrices{1}(:,:,2) = CreatGroupZoneMatrix(IsomorphismMetrices{1},GroupIndexes);


IsomorphismStr(1) = join(string(IsomorphismMetrices{1}(:))',"");
for Axis = 2:3
    Temp = GetConfigProjection(ConfigMat,RotationMatrices,Axis); 
    TempType = GetConfigProjection(ConfigType,RotationMatrices,Axis); 
    [IsomorphismMetrices{Axis},GroupIndexes] = ConfigGroupSizes(Temp,TempType);
    
    IsomorpSizes(Axis,1:2) = size(IsomorphismMetrices{Axis});
    IsomorphismMetrices{Axis}(:,:,2) = CreatGroupZoneMatrix(IsomorphismMetrices{Axis},GroupIndexes);
    IsomorphismStr(Axis) = join(string(IsomorphismMetrices{Axis}(:))',"");
    
end

 



end