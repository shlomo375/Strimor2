function [StaticMatrix,MovingMatrix] = GetGroupsMatrix(Config,Config_RotationMatrices,Target,Target_RotationMatrices,Axis)
    if Axis ~= 1
        Config = GetConfigProjection(Config,Config_RotationMatrices,Axis);
        Target = GetConfigProjection(Target,Target_RotationMatrices,Axis);
    end

    ConfigInGroups = ConfigGroupSizes(Config);
    TargetInGroups = ConfigGroupSizes(Target);
    SizeDifferences = size(TargetInGroups)-size(ConfigInGroups);
    
    if SizeDifferences(2) >= 0
        ConfigInGroups(:,end+1:end+SizeDifferences(2)) = 0;
    else
        TargetInGroups(:,end+1:end+abs(SizeDifferences(2))) = 0;
    end

    StaticMatrix = zeros(size(ConfigInGroups)+[size(TargetInGroups,1)*2-2,0]);
    StaticMatrix(size(TargetInGroups,1):end-size(TargetInGroups,1)+1,:) = ConfigInGroups;
    MovingMatrix = TargetInGroups;
    
    
end
