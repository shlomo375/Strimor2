function [IsomorphismMetrices,IsomorphismStr,IsomorpSizes] = CreatIsomorphismMetrices(ConfigMat,ConfigType,RotationMatrices,P)
arguments
    ConfigMat
    ConfigType
    RotationMatrices = [];
    P.ZoneMatrix {mustBeNumericOrLogical} = true;
end

DeleteFirstLine = false;
IsomorpSizes = zeros(3,2);
IsomorphismStr = ["","",""];
if isempty(RotationMatrices)
    if mod(find(ConfigMat,1),2) && ConfigType(find(ConfigMat,1)) == 1
        ConfigMat = [zeros(1,size(ConfigMat,2)); ConfigMat];
        ConfigType = [zeros(1,size(ConfigMat,2)); ConfigType];
        DeleteFirstLine = true;

    end
    WSConfig = WorkSpace(size(ConfigMat),"RRT*");

    RotationMatrices = {WSConfig.R1, WSConfig.R2, WSConfig.R3};
end
IsomorphismMetrices = cell(1,3);

[IsomorphismMetrices{1},GroupIndexes] = ConfigGroupSizes(ConfigMat,ConfigType);
IsomorpSizes(1,1:2) = size(IsomorphismMetrices{1});

if P.ZoneMatrix
    IsomorphismMetrices{1}(:,:,2:3) = CreatGroupZoneMatrix2(IsomorphismMetrices{1},ConfigMat,ConfigType,GroupIndexes);
end
if DeleteFirstLine
    ConfigMat(1,:) = [];
    IsomorphismMetrices{1}(1,:,:) = [];
end

IsoMetrices = IsomorphismMetrices{1}(:,:,1);
IsomorphismStr(1) = join(string(IsoMetrices(:))',"");
for Axis = 2:3
    Temp = GetConfigProjection(ConfigMat,RotationMatrices,Axis); 
    TempType = -1*GetConfigProjection(ConfigType,RotationMatrices,Axis); 
    [IsomorphismMetrices{Axis},GroupIndexes] = ConfigGroupSizes(Temp,TempType);
    
    IsomorpSizes(Axis,1:2) = size(IsomorphismMetrices{Axis});
    if P.ZoneMatrix 
        IsomorphismMetrices{Axis}(:,:,2:3) = CreatGroupZoneMatrix2(IsomorphismMetrices{Axis},Temp,TempType,GroupIndexes);
    end
    IsoMetrices = IsomorphismMetrices{Axis}(:,:,1);
    IsomorphismStr(Axis) = join(string(IsoMetrices(:))',"");
    
end

% ~any(IsomorphismMetrices{1}(:,:,1))

end