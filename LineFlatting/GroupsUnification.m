function [WS,tree, ParentInd] =  GroupsUnification(WS, tree, ParentInd)
GroupConnected = true;
while GroupConnected
    GroupConnected = false;
%     try
    if size(tree.Data{ParentInd,"IsomorphismMatrices1"}{1},2) < 2
        return
    end
    % load("GroupsUnificatin.mat");
    [GroupsSizes,GroupIndexes, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
    
    RotationMatrices = {WS.R1,WS.R2,WS.R3};

    ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
    ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);

    [GroupsSizes2,~, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);

    ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
    ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);

    [GroupsSizes3,~, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);
    
%     [GroupsSizes2,GroupIndexes2, GroupInd2] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R2);
%     [GroupsSizes3,GroupIndexes3, GroupInd3] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R3);
    
    EndAlpha = EndIsAlpha(GroupsSizes(2,:));
    FirstAlpha = FirstIsAlpha(GroupsSizes(2,:));
    
    ItsOnlyAlphaGroup = all(FirstAlpha(1,:)) && all(EndAlpha(1,:));
    % NC_Alpha_VS_Beta_NC = EndAlpha & ~FirstAlpha;
    
    
    ScannedAgent = ~WS.Space.Status;
    ScannedAgent(GroupInd{1}{1}) = true;
    GroupPairNum = 1;
    while true
        if any(isnan(FirstAlpha(GroupPairNum:GroupPairNum+1)))
            GroupPairNum = GroupPairNum +1;
            if GroupPairNum >= length(FirstAlpha)
                break
            end
            continue
        end
        %% Only Alpha vs Alpha Case, without Beta in any of the groups
        if ItsOnlyAlphaGroup
            [OK, WS,tree,ParentInd] = Unify_Only_Alpha_VS_Alpha_group(WS,tree,ParentInd, GroupPairNum, GroupIndexes, GroupInd);
        else
            %%
            if EndAlpha(GroupPairNum) && ~FirstAlpha(GroupPairNum+1)
                Axis = 2; %%%
                [OK, WS,tree,ParentInd] = Unify_NC_AlphaOrBeta_VS_AlphaOrBeta_NC(WS,tree,ParentInd, GroupPairNum,Axis, GroupIndexes', GroupInd,GroupInd2,GroupInd3, ScannedAgent);
            end
    
            if ~EndAlpha(GroupPairNum) && FirstAlpha(GroupPairNum+1)
                Axis = 3; %%%
                [OK, WS,tree,ParentInd] = Unify_NC_AlphaOrBeta_VS_AlphaOrBeta_NC(WS,tree,ParentInd, GroupPairNum,Axis, GroupIndexes', GroupInd,GroupInd2,GroupInd3, ScannedAgent);
            end
            %%
            if EndAlpha(GroupPairNum) && FirstAlpha(GroupPairNum+1)
                    GroupsEdges = [FirstAlpha(GroupPairNum), EndAlpha(GroupPairNum+1)];
                    if all(~isnan(GroupsEdges))
                        [OK, WS,tree,ParentInd] = Unify_NC_Alpha_VS_Alpha_NC(WS,tree,ParentInd, GroupPairNum, GroupsEdges,GroupIndexes, GroupInd, ScannedAgent);
                    end
            end
            %%
            if ~EndAlpha(GroupPairNum) && ~FirstAlpha(GroupPairNum+1)
                GroupsEdges = [FirstAlpha(GroupPairNum), EndAlpha(GroupPairNum+1)];
                if any(GroupsEdges) && all(~isnan(GroupsEdges))
                    
                    [OK, WS,tree,ParentInd] = Unify_NC_Beta_VS_Beta_NC(WS,tree,ParentInd, GroupPairNum, GroupsEdges,[], GroupIndexes, GroupInd, ScannedAgent);
                end
            end
        end
        GroupPairNum = GroupPairNum+1;
        if OK
            GroupPairNum = GroupPairNum+1;
            GroupConnected = true;
        end
        
        if GroupPairNum >= length(FirstAlpha)
            break
        end
    end
    
%     catch me1
%         me1
%     end
end
end
