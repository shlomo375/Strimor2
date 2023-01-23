function [WS,tree, ParentInd] =  GroupsUnification(WS, tree, ParentInd)
try
% GroupsSizes1 = tree.Data{ParentInd,"IsomorphismMatrices1"}(:,:,1);

RotationMatrices = {WS.R1,WS.R2,WS.R3};
ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);

ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);

[GroupsSizes1,GroupIndexes1, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
[GroupsSizes2,GroupIndexes2, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
[GroupsSizes3,GroupIndexes3, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);

 EndAlpha = EndIsAlpha(GroupsSizes1(2:end,:));
 FirstAlpha = FirstIsAlpha(GroupsSizes1(2:end,:));

NC_Alpha_VS_Beta_NC = EndAlpha & ~FirstAlpha;


ScannedAgent = ~WS.Space.Status;
ScannedAgent(GroupInd1{1}{1}) = true;
GroupPairNum = 1;
while true
    
    %%
    if EndAlpha(GroupPairNum) && ~FirstAlpha(GroupPairNum+1)
        Axis = 2;
        [OK, WS,tree,ParentInd] = Unify_NC_AlphaOrBeta_VS_AlphaOrBeta_NC(WS,tree,ParentInd, GroupPairNum,Axis, GroupIndexes1', GroupInd1, ScannedAgent);
    end
    %%
    if EndAlpha(GroupPairNum) && FirstAlpha(GroupPairNum+1)
        GroupsEdges = [FirstAlpha(GroupPairNum), EndAlpha(GroupPairNum+1)];
        [OK, WS,tree,ParentInd] = Unify_NC_Alpha_VS_Alpha_NC(WS,tree,ParentInd, GroupPairNum, GroupsEdges,Axis, GroupIndexes1, GroupInd1, ScannedAgent);
    end
    %%
    if ~EndAlpha(GroupPairNum) && ~FirstAlpha(GroupPairNum+1)
        GroupsEdges = [FirstAlpha(GroupPairNum), EndAlpha(GroupPairNum+1)];
        if any(GroupsEdges)
            
            [OK, WS,tree,ParentInd] = Unify_NC_Beta_VS_Beta_NC(WS,tree,ParentInd, GroupPairNum, GroupsEdges,Axis, GroupIndexes1, GroupInd1, ScannedAgent);
        end
    end

    GroupPairNum = GroupPairNum+1;
    if OK
        GroupPairNum = GroupPairNum+1;
    end
    
    if GroupPairNum >= length(FirstAlpha)
        break
    end
end

catch me1
    me1
end
end
