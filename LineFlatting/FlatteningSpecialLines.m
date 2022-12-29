function FlatteningSpecialLines(WS,tree,FlatAxis,ParentInd)
RotationMatrices = {WS.R1,WS.R2,WS.R3};
ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);

ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);


[GroupsSizes1,GroupIndexes1, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
[GroupsSizes2,GroupIndexes2, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
[GroupsSizes3,GroupIndexes3, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);


if size(GroupsSizes1,1)>2
    %% Straight line detection
    StraightLineToRightLoc = find(abs(GroupsSizes3) >= 5 | GroupsSizes3 == 4);

    StraightLineToLeftLoc = find(abs(GroupsSizes2) >= 5 | GroupsSizes2 == -4);
    
    %% axis 3
    for StraightLine_idx = 1:numel(StraightLineToRightLoc) % axis 3
        ModulesInd = GroupInd3{StraightLineToRightLoc(StraightLine_idx)}{1};
        
        ScannedAgent = ~WS.Space.Status;
        ScannedAgent(GroupInd1{1}{1}) = true;
        [~, StraightLineModulesInd] = ScanningAgents(WS, ScannedAgent, ModulesInd(3), []); % for Left line i need to take the first module
        
        AllModuleBranchInd = unique([StraightLineModulesInd;ModulesInd]);
        if GroupsSizes3(StraightLineToRightLoc(StraightLine_idx))<0
            RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(3:4));
            RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1:2));
            
        else
            RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(2:3));
            RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1));
        end
        
        [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,AllModuleBranchInd,RowModuleLogical,"Simple");
        
        % An attempt to move the branch
        if ~OK
            Axis = 1;
            Step = 1;
        
            [RepairOK, WS, tree, ParentInd, AllModuleBranchInd] =...
            ManeuverStepProcess(WS,tree,ParentInd,AllModuleBranchInd(~RowModuleLogical(:,1)), Axis, Step);
            
        end
        

    end

    %% axis 2
    for StraightLine_idx = 1:numel(StraightLineToLeftLoc) % axis 2
        ModulesInd = GroupInd2{StraightLineToLeftLoc(StraightLine_idx)}{1};
        
        ScannedAgent = ~WS.Space.Status;
        ScannedAgent(GroupInd1{1}{1}) = true;
        [~, StraightLineModulesInd] = ScanningAgents(WS, ScannedAgent, ModulesInd(3), []); % for Left line i need to take the first module
        
        AllModuleBranchInd = unique([StraightLineModulesInd;ModulesInd]);
        GroupSize = GroupsSizes2(StraightLineToLeftLoc(StraightLine_idx));
        if ~xor(sign(GroupSize)<0,mod(abs(GroupSize),2))
            RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(3:4));
            RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1:2));
            
        else
            RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(2:3));
            RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1));
        end
        
        [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,AllModuleBranchInd,RowModuleLogical,"Simple");
        
        % An attempt to move the branch
        if ~OK
            Axis = 1;
            Step = 1;
        
            [RepairOK, WS, tree, ParentInd, AllModuleBranchInd] =...
            ManeuverStepProcess(WS,tree,ParentInd,AllModuleBranchInd(~RowModuleLogical(:,1)), Axis, Step);
            
        end
        

    end

end

end
