function [WS,tree,ParentInd] = FlatteningSpecialLines(WS,tree,ParentInd)
RotationMatrices = {WS.R1,WS.R2,WS.R3};
ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);

ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);


[GroupsSizes1,~, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
[GroupsSizes2,~, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
[GroupsSizes3,~, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);


if size(GroupsSizes1,1)>2
    %% Straight line detection
    StraightLineToRightLoc = find(abs(GroupsSizes3(:,1)) >= 5 | GroupsSizes3(:,1) == 4);

    StraightLineToLeftLoc = find(abs(GroupsSizes2(:,1)) >= 5 | GroupsSizes2(:,1) == -4);
    
    %% axis 3
    for StraightLine_idx = 1:numel(StraightLineToRightLoc) % axis 3

        GroupSize = GroupsSizes3(StraightLineToRightLoc(StraightLine_idx));

        [AllModuleBranchInd, ModuleLogForEachStep] = Get_ModuleLogForEachStep(WS,3,GroupInd3,GroupInd1,StraightLineToRightLoc(StraightLine_idx),GroupSize);
        
        
        
        %         try
%         ModulesInd = GroupInd3{StraightLineToRightLoc(StraightLine_idx)}{1};
%         catch ee2e
%             ee2e
%         end
%         ScannedAgent = ~WS.Space.Status;
%         ScannedAgent(GroupInd1{1}{1}) = true;
% %         StraightLineModulesInd = ScanningAgents(WS, ScannedAgent, ModulesInd(3), []); % for Left line i need to take the first module
% %         try
%         [~, StraightLineModulesInd] = ScanningAgentsFast(WS, ScannedAgent, ModulesInd(3),true);
%         
% %         catch ee
% %             ee
% %         end
% %         if ~isequal(sort(StraightLineModulesInd),sort(StraightLineModulesInd1))
% %             d=5
% %         end
% 
%         AllModuleBranchInd = unique([StraightLineModulesInd;ModulesInd]);
%         if GroupsSizes3(StraightLineToRightLoc(StraightLine_idx))<0
%             RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(3:4));
%             RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1:2));
%             
%         else
%             RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(2:3));
%             RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1));
%         end
        
        [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,AllModuleBranchInd,ModuleLogForEachStep,3,"Simple");
        
        % An attempt to move the branch
        if ~OK
            Axis = 1;
            Step = 1;
        
%             [RepairOK, WS, tree, ParentInd, AllModuleBranchInd] =...
%             ManeuverStepProcess(WS,tree,ParentInd,AllModuleBranchInd(~RowModuleLogical(:,1)), Axis, Step);
            
        end
        

    end

    %% axis 2
    for StraightLine_idx = 1:numel(StraightLineToLeftLoc) % axis 2
        
        GroupSize = GroupsSizes2(StraightLineToLeftLoc(StraightLine_idx));

        [AllModuleBranchInd, ModuleLogForEachStep] = Get_ModuleLogForEachStep(WS,2,GroupInd2,GroupInd1,StraightLineToLeftLoc(StraightLine_idx),GroupSize);
        
%         try
%         ModulesInd = GroupInd2{StraightLineToLeftLoc(StraightLine_idx)}{1};
%         catch rrr
%             rrr
%         end
%         ScannedAgent = ~WS.Space.Status;
%         ScannedAgent(GroupInd1{1}{1}) = true;
% %         [~, StraightLineModulesInd] = ScanningAgents(WS, ScannedAgent, ModulesInd(3), []); % for Left line i need to take the first module
%         [~, StraightLineModulesInd] = ScanningAgentsFast(WS, ScannedAgent, ModulesInd(3),true);
% 
%         AllModuleBranchInd = unique([StraightLineModulesInd;ModulesInd]);
%         
%         if ~EndIsAlpha(GroupSize)
%             RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(3:4));
%             RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1:2));
%             
%         else
%             RowModuleLogical(:,2) = ismember(AllModuleBranchInd,ModulesInd(2:3));
%             RowModuleLogical(:,1) = ismember(AllModuleBranchInd,ModulesInd(1));
%         end
%         צריך לכתוב מחדש את מציאת המודולים עבור הפונקציה הזאת
        [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,AllModuleBranchInd,ModuleLogForEachStep,2,"Simple");
        
        % An attempt to move the branch
        if ~OK
            Axis = 1;
            Step = 1;
        
%             [RepairOK, WS, tree, ParentInd, AllModuleBranchInd] =...
%             ManeuverStepProcess(WS,tree,ParentInd,AllModuleBranchInd(RowModuleLogical(:,1)), Axis, Step);
            
        end
        

    end

end

end



function [AllModuleBranchInd,ModuleLogForEachStep] = Get_ModuleLogForEachStep(WS,Axis,AxisGroupInd,GroupInd1,StraightLineLoc,GroupSize)

try
ModulesInd = AxisGroupInd{StraightLineLoc}{1};
catch rrr
    rrr
end
ScannedAgent = ~WS.Space.Status;
ScannedAgent(GroupInd1{1}{1}) = true;
[~, StraightLineModulesInd] = ScanningAgentsFast(WS, ScannedAgent, ModulesInd(3),true);

AllModuleBranchInd = unique([StraightLineModulesInd;ModulesInd]);

ModuleLogForEachStep = false(length(AllModuleBranchInd),1);

% Module on the side of the straight line, from inside

if Axis==2
    ModuleLogForEachStep(:,2) = ~ismember(AllModuleBranchInd,AxisGroupInd{StraightLineLoc}{end}((end-3+EndIsAlpha(GroupSize)):end));

else
    ModuleLogForEachStep(:,2) = ~ismember(AllModuleBranchInd,AxisGroupInd{StraightLineLoc}{1}(1:(4-FirstIsAlpha(GroupSize))));
end

try
    if Axis == 2
        InsideModuleExist = abs(AxisGroupInd{StraightLineLoc+1}{end-1} - AxisGroupInd{StraightLineLoc+1}{end}) <= 3;
    else
        InsideModuleExist = abs(AxisGroupInd{StraightLineLoc-1}{2} - AxisGroupInd{StraightLineLoc-1}{1}) <= 3;
    end
catch
    InsideModuleExist = false;
end

if ~InsideModuleExist
    ModuleLogForEachStep(:,1) = true;
else
    ModuleLogForEachStep(:,1) = ismember(AllModuleBranchInd,ModulesInd);
    try
        TestThisOption
    catch Test
        Test
        fprintf("FlatteningSpecialLines")
        pause
    end
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
    case 3
        Axis = [3;1;3];
        Step = [-1;-1;1];
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


