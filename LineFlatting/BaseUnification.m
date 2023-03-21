function [WS,Tree, ParentInd] = BaseUnification(WS, Tree, ParentInd)

if numel(nonzeros(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(1,:,1))) <= 1
    return
end
% [GroupsSizes,GroupIndexes, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);

RotationMatrices = {WS.R1,WS.R2,WS.R3};

%% Axis 3
ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);

[GroupsSizes3,~, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);


FirstAlphaGroup = FirstIsAlpha(GroupsSizes3(:,1));
FirstAlphaGroup(end) = 0;
GroupLines3 = find(FirstAlphaGroup);

Flag = false;
for idx = 1:numel(GroupLines3)

MovingModule = FindModuleBranch(WS,GroupInd3{GroupLines3(idx)}{1}(1),GroupInd3{GroupLines3(idx)}{1}(2:end));
MovingModule = [MovingModule(:); GroupInd3{GroupLines3(idx)}{1}(2:end)];

Axis = 3;
Step = -1;
[OK, WS, Tree, ParentInd, MovingModule] =...
    ManeuverStepProcess(WS,Tree,ParentInd,MovingModule, Axis, Step);

    if ~OK
        %% axis 2
        if ~Flag
            ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
            ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);
            
            [GroupsSizes2,~, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
            
            
            EndAlphaGroup = EndIsAlpha(GroupsSizes2);
            EndAlphaGroup(~GroupsSizes2) = 0;
            LastGroupLoc = logical(diff([logical(GroupsSizes2),false(size(GroupsSizes2,1),1)],1,2));
            
            [GroupLines2,~] = find(LastGroupLoc & EndAlphaGroup);
            Flag = true;
        end

        MovingModule = FindModuleBranch(WS,GroupInd2{GroupLines2(idx)}{end}(end),GroupInd2{GroupLines2(idx)}{end}(1:end-1));
        MovingModule = [MovingModule(:); GroupInd2{GroupLines2(idx)}{end}(1:end-1)];
        
        Axis = 2;
        Step = 1;
        [OK, WS, Tree, ParentInd, MovingModule] =...
            ManeuverStepProcess(WS,Tree,ParentInd,MovingModule, Axis, Step);
        if OK
            break
        end
    else
        break
    end

end
end