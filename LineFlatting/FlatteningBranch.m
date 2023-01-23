function [OK ,NewWS, Newtree, NewParentInd] = FlatteningBranch(OldWS,Oldtree,OldParentInd,AllModuleBranchInd,RowModuleLogical,BranchAxis,Version)
NewWS = OldWS;
Newtree = Oldtree;
NewParentInd = OldParentInd;

% AllModuleBranchInd = unique([StraightLineModulesInd(:);ModulesInd(:)]);
% First4ModulesLogical = ismember(AllModuleBranchInd,ModulesInd(1:4));
% RestOfModulesInd = ismember(AllModuleInStraightLineInd, First4ModulesInd);
switch BranchAxis
    case 2
        %% NOT TESTED !!!!!!!!!!!!!!!!!!!!!!!
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
        ModuleInSecondRow = AllModuleBranchInd(RowModuleLogical(:,2));
        RearModuleInd = UpdateLinearIndex(OldWS.SpaceSize,ModuleInSecondRow(2),1,-1);
        [~,RearModuleLogicalNot] = setdiff(AllModuleBranchInd,RearModuleInd);
        %

        [OK, OldWS, Oldtree, OldParentInd, AllModuleBranchInd(RearModuleLogicalNot)] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,AllModuleBranchInd(RearModuleLogicalNot), Axis(1), Step(1));
        
        if ~ OK
            return
        end
        
        % B) moving the all lineModules but the first 4 against the spreading direction of the shape.
%         Axis = 1;
%         Step = -1;
        
        [OK, OldWS, Oldtree, OldParentInd, AllModuleBranchInd(~any(RowModuleLogical,2))] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,AllModuleBranchInd(~any(RowModuleLogical,2)), Axis(2), Step(2));
        if ~OK
            return
        end
        
        % C) returning the 4 modules that were lowered earlier
%         Axis = 3;
%         Step = 1;
        
        [OK, OldWS, Oldtree, OldParentInd, AllModuleBranchInd(any(RowModuleLogical,2))] =...
            ManeuverStepProcess(OldWS,Oldtree,OldParentInd,AllModuleBranchInd(any(RowModuleLogical,2)), Axis(3), Step(3));
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
        [~, FrontPartModulesInd] = ScanningAgentsFast(OldWS, ScannedAgent, StartModule);
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
        [~, ShiftBranchPartModulesInd] = ScanningAgentsFast(OldWS, ScannedAgent, StartModule);
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
