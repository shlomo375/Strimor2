function [WS,tree,ParentInd] = FlatteningSpecialLines(WS,tree,ParentInd)
RotationMatrices = {WS.R1,WS.R2,WS.R3};


ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);


[GroupsSizes1,~, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
[GroupsSizes3,~, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);


if size(GroupsSizes1,1)>2
    %% Straight line detection
    StraightLineToRightLoc = find(abs(GroupsSizes3(:,1)) >= 5 | GroupsSizes3(:,1) == 4);
    
    %% axis 3
    for StraightLine_idx = 1:numel(StraightLineToRightLoc) % axis 3

        GroupSize = GroupsSizes3(StraightLineToRightLoc(StraightLine_idx));

        [AllMovingModuleInd, ModuleLogForEachStep,OnlyBranchModulesInd,OnlyEdgeOfAttaceModulesInd] = Get_ModuleLogForEachStep(WS,3,GroupInd3,GroupInd1,StraightLineToRightLoc(StraightLine_idx),GroupSize);
        
%         AttaceDir = Get_EdgeOfAttaceDir(OnlyEdgeOfAttaceModulesInd,OnlyBranchModulesInd);
        
        OK = false;
        while ~OK
            [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,AllMovingModuleInd,ModuleLogForEachStep,3,"Simple");
%             
%             % An attempt to move the branch
            if ~OK
                Axis = 1;
                Step = 1;
                
                [Repair_OK, WS, tree, ParentInd, OnlyBranchModulesInd] =...
                    ManeuverStepProcess(WS,tree,ParentInd,OnlyBranchModulesInd, Axis, Step);
                if ~Repair_OK
                    break
                else
                    ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
                    ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);
                    
                    
                    [GroupsSizes1,~, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
                    [GroupsSizes3,~, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);
%                     AllMovingModuleInd = UpdateLinearIndex(WS.SpaceSize,AllMovingModuleInd,Axis,Step);
                    StraightLineToRightLoc = find(abs(GroupsSizes3(:,1)) >= 5 | GroupsSizes3(:,1) == 4);
                    
                    if isempty(StraightLineToRightLoc)
                        break
                    end
                    GroupSize = GroupsSizes3(StraightLineToRightLoc(StraightLine_idx));

                    [AllMovingModuleInd, ModuleLogForEachStep,OnlyBranchModulesInd,OnlyEdgeOfAttaceModulesInd] = Get_ModuleLogForEachStep(WS,3,GroupInd3,GroupInd1,StraightLineToRightLoc(StraightLine_idx),GroupSize);
        
                
                end
            else
                return
            end
        end
        

    end
    
    ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
    ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);
    [~,~, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
    [GroupsSizes2,~, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
    StraightLineToLeftLog = abs(GroupsSizes2) >= 5 | GroupsSizes2 == -4;
    StraightLineToLeftLoc = find(StraightLineToLeftLog & ~[GroupsSizes2(:,2:end),zeros(size(GroupsSizes2,1),1)]);
    %% axis 2
    for StraightLine_idx = 1:numel(StraightLineToLeftLoc) % axis 2
        
        GroupSize = GroupsSizes2(StraightLineToLeftLoc(StraightLine_idx));
        try
        [AllMovingModuleInd, ModuleLogForEachStep,OnlyBranchModulesInd,OnlyEdgeOfAttaceModulesInd] = Get_ModuleLogForEachStep(WS,2,GroupInd2,GroupInd1,StraightLineToLeftLoc(StraightLine_idx),GroupSize);
        catch ME1
            ME1
        end
%         AttaceDir = Get_EdgeOfAttaceDir(OnlyEdgeOfAttaceModulesInd,OnlyBranchModulesInd);
        OK = false;
        while ~OK
             [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,AllMovingModuleInd,ModuleLogForEachStep,2,"Simple");
            
            % An attempt to move the branch
            if ~OK
                Axis = 1;
                Step = -1;
                
                [Repair_OK, WS, tree, ParentInd, OnlyBranchModulesInd] =...
                    ManeuverStepProcess(WS,tree,ParentInd,OnlyBranchModulesInd, Axis, Step);
                if ~Repair_OK
                    break
                else
%                     AllMovingModuleInd = UpdateLinearIndex(WS.SpaceSize,AllMovingModuleInd,Axis,Step);
                    ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
                    ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);
                    
                    
                    [~,~, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
                    [GroupsSizes2,~, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
                    StraightLineToLeftLog = abs(GroupsSizes2) >= 5 | GroupsSizes2 == -4;
                    StraightLineToLeftLoc = find(StraightLineToLeftLog & ~[GroupsSizes2(:,2:end),zeros(size(GroupsSizes2,1),1)]);
                    if isempty(StraightLineToLeftLoc)
                        break
                    end
                    GroupSize = GroupsSizes2(StraightLineToLeftLoc(StraightLine_idx));
                    [AllMovingModuleInd, ModuleLogForEachStep,OnlyBranchModulesInd,OnlyEdgeOfAttaceModulesInd] = Get_ModuleLogForEachStep(WS,2,GroupInd2,GroupInd1,StraightLineToLeftLoc(StraightLine_idx),GroupSize);
                end
            else
                return
            end
        end
        

    end

end

end

function AttaceDir = Get_EdgeOfAttaceDir(ModulesGroupInd,StraightLineModuleInd)

EdgeOfAttaceLog = ismember(StraightLineModuleInd,ModulesGroupInd);
EdgeOfAttace = StraightLineModuleInd(EdgeOfAttaceLog);
RestOfModule = StraightLineModuleInd(~EdgeOfAttaceLog);

if min(EdgeOfAttace) < min(RestOfModule)
    AttaceDir = "Left";
else
    AttaceDir = "Right";
end
end


function [AllModuleBranchInd,ModuleLogForEachStep,StraightLineModulesInd,ModulesGroupInd] = Get_ModuleLogForEachStep(WS,Axis,AxisGroupInd,GroupInd1,StraightLineLoc,GroupSize)

try
ModulesGroupInd = AxisGroupInd{StraightLineLoc}{1};
catch rrr
    rrr
end
ScannedAgent = ~WS.Space.Status;
ScannedAgent(GroupInd1{1}{1}) = true;
[~, StraightLineModulesInd] = ScanningAgentsFast(WS, ScannedAgent, ModulesGroupInd(3),true);

AllModuleBranchInd = unique([StraightLineModulesInd;ModulesGroupInd]);

ModuleLogForEachStep = false(length(AllModuleBranchInd),1);

% Module on the side of the straight line, from inside

if Axis==2
    ModuleLogForEachStep(:,2) = ~ismember(AllModuleBranchInd,AxisGroupInd{StraightLineLoc}{end}((end-3+EndIsAlpha(GroupSize)):end));

else
    ModuleLogForEachStep(:,2) = ~ismember(AllModuleBranchInd,AxisGroupInd{StraightLineLoc}{1}(1:(4-FirstIsAlpha(GroupSize))));
end

try
    if Axis == 2
        [~,Col_Branch] = find(WS.R2==AxisGroupInd{StraightLineLoc+1}{end-1}(end));
        [~,Col_Base]   = find(WS.R2 == AxisGroupInd{StraightLineLoc+1}{end}(1));
        InsideModuleExist = abs(Col_Branch - Col_Base) <= 3;
    else
        [~,Col_Branch] = find(WS.R3==AxisGroupInd{StraightLineLoc+1}{2}(1));
        [~,Col_Base]   = find(WS.R3 == AxisGroupInd{StraightLineLoc+1}{1}(end));
        InsideModuleExist = abs(Col_Branch - Col_Base) <= 3;
    end
catch e4
    InsideModuleExist = false;
end

if ~InsideModuleExist
    ModuleLogForEachStep(:,1) = true;
else
    ModuleLogForEachStep(:,1) = ismember(AllModuleBranchInd,ModulesGroupInd);
%     try
%         TestThisOption
%     catch Test
%         Test
%         fprintf("FlatteningSpecialLines")
%         pause
%     end
end

end

function [OK ,NewWS, Newtree, NewParentInd] = FlatteningBranch(OldWS,Oldtree,OldParentInd,AllModuleBranchInd,RowModuleLogical,BranchAxis,Version)
NewWS = OldWS;
Newtree = Oldtree;
NewParentInd = OldParentInd;

% AllModuleBranchInd = unique([StraightLineModulesInd(:);ModulesInd(:)]);
% First4ModulesLogical = ismember(AllModuleBranchInd,ModulesInd(1:4));
% RestOfModulesInd = ismember(AllModuleInStraightLineInd, First4ModulesInd);
switch BranchAxis
    case 2
        Axis = [2;1;2];
        Step = [1;1;-1];
%         if matches(AttaceDirection,"Left")
%             Step(2) = -1;
%         end
    case 3
        Axis = [3;1;3];
        Step = [-1;-1;1];
%         if matches(AttaceDirection,"Right")
%             Step(2) = 1;
%         end
end

switch Version
    case "Simple"
        % Simple mode:
        % A) Lowering the entire branch one step down
        
%         Axis = 3;
%         Step = -1;

        %   Finding the rear module in the second row.
        %   If it exists, it will cause a movement failure,
        %   so we don't want to move it with the rest of the branch.
        %   If it doesn't exist there is no harm.
%         ModuleInSecondRow = AllModuleBranchInd(RowModuleLogical(:,2));
%         RearModuleInd = UpdateLinearIndex(OldWS.SpaceSize,ModuleInSecondRow(2),1,-1);
%         [~,RearModuleLogicalNot] = setdiff(AllModuleBranchInd,RearModuleInd);
        %

        [OK, OldWS, Oldtree, OldParentInd, AllModuleBranchInd(RowModuleLogical(:,1))] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,AllModuleBranchInd(RowModuleLogical(:,1)), Axis(1), Step(1));
        
        if ~ OK
            return
        end
        
        % B) moving the all lineModules but the first 4 against the spreading direction of the shape.
%         Axis = 1;
%         Step = -1;
        
        [OK, OldWS, Oldtree, OldParentInd, AllModuleBranchInd(RowModuleLogical(:,2))] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,AllModuleBranchInd(RowModuleLogical(:,2)), Axis(2), Step(2));
        if ~OK
            return
        end
        
        % C) returning the 4 modules that were lowered earlier
%         Axis = 3;
%         Step = 1;
        
        [OK, OldWS, Oldtree, OldParentInd, AllModuleBranchInd(~RowModuleLogical(:,2))] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,AllModuleBranchInd(~RowModuleLogical(:,2)), Axis(3), Step(3));
        if ~OK
            return
        end
    case "Complex"
        %% NOT TESTED !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        %% Complex mode:
        % A) Raising the line of the entire part before the edge attack of the branch.
%         [MovingModuleInd,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(WS.R3,ModuleInd,AllModuleInd,Axis,AboveModule)
        ScannedAgent = ~OldWS.Space.Status;
        ScannedAgent(AllModuleBranchInd(any(RowModuleLogical,2))) = true;
        
        StartModule = AllModuleBranchInd(RowModuleLogical);
        if sum(RowModuleLogical(:,1)) == 2 
            StartModule = UpdateLinearIndex(OldWS.SpaceSize,StartModule(1),1,1);
        else
            StartModule = UpdateLinearIndex(OldWS.SpaceSize,StartModule(1),1,0.5);
        end

%         [~, FrontPartModulesInd] = ScanningAgents(OldWS, ScannedAgent, StartModule, []); % for Left line i need to take the first module
        [~, FrontPartModulesInd] = ScanningAgentsFast(OldWS, ScannedAgent, StartModule,true);
        Axis = 3;
        Step = 1;
        
        [OK, OldWS, Oldtree, OldParentInd, FrontPartModulesInd] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,FrontPartModulesInd, Axis, Step);
        if ~OK
            return
        end

        % b) Moving the branch 2 steps in the direction of the attack rim.

        ScannedAgent = ~OldWS.Space.Status;
        ScannedAgent(StraightLineModulesInd) = true; % ????? mistake?
        StartModule = ModulesInd(5);
%         [~, ShiftBranchPartModulesInd] = ScanningAgents(OldWS, ScannedAgent, StartModule, []); % for Left line i need to take the first module
        [~, ShiftBranchPartModulesInd] = ScanningAgentsFast(OldWS, ScannedAgent, StartModule,true);
        Axis = 1;
        Step = 2;
        
        [OK, OldWS, Oldtree, OldParentInd, ShiftBranchPartModulesInd] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,ShiftBranchPartModulesInd, Axis, Step);
        if ~OK
            return
        end
        % C) Lowering the entire part of section A in addition to the new modules added to it
        
        Axis = 3;
        Step = 1;
        
        [OK, OldWS, Oldtree, OldParentInd, FrontPartModulesInd] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,[FrontPartModulesInd,ShiftBranchPartModulesInd], Axis, Step);
        if ~OK
            return
        end

end

NewWS = OldWS;
Newtree = Oldtree;
NewParentInd = OldParentInd;
end


