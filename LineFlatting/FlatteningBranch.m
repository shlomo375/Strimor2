function [OK ,WS, tree, ParentInd] = FlatteningBranch(WS,tree,ParentInd,ModulesInd,StraightLineModulesInd,Version)
AllModuleInStraightLineInd = unique([StraightLineModulesInd(:);ModulesInd(:)]);
First4ModulesLogical = ismember(AllModuleInStraightLineInd,ModulesInd(1:4));
% RestOfModulesInd = ismember(AllModuleInStraightLineInd, First4ModulesInd);

switch Version
    case "Simple"
        % Simple mode:
        % A) Lowering the entire branch one step down
        Axis = 3;
        Step = -1;
        
        % SecAxis = 1;
        % SecStep = 1;
        [OK, WS, tree, ParentInd, AllModuleInStraightLineInd] =...
            ManeuverStepProcess(WS,tree,ParentInd,AllModuleInStraightLineInd, Axis, Step);
        
        if ~ OK
            return
        end
        
        % B) moving the all lineModules but the first 4 against the spreading direction of the shape.
        Axis = 1;
        Step = -1;
        
        [OK, WS, tree, ParentInd, AllModuleInStraightLineInd(~First4ModulesLogical)] =...
            ManeuverStepProcess(WS,tree,ParentInd,AllModuleInStraightLineInd(~First4ModulesLogical), Axis, Step);
        if ~OK
            return
        end
        
        % C) returning the 4 modules that were lowered earlier
        Axis = 3;
        Step = 1;
        
        [OK, WS, tree, ParentInd, AllModuleInStraightLineInd(First4ModulesLogical)] =...
            ManeuverStepProcess(WS,tree,ParentInd,AllModuleInStraightLineInd(First4ModulesLogical), Axis, Step);
        if ~OK
            return
        end
    case "Complex"
        
        %% Complex mode:
        % A) Raising the line of the entire part before the edge attack of the branch.
%         [MovingModuleInd,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(WS.R3,ModuleInd,AllModuleInd,Axis,AboveModule)
        ScannedAgent = ~WS.Space.Status;
        ScannedAgent(AllModuleInStraightLineInd(First4ModulesLogical)) = true;
        if WS.Space.Type(StraightLineModulesInd(1)) == 1
            StartModule = UpdateLinearIndex(WS.SpaceSize,StraightLineModulesInd(1),1,1);
        else
            StartModule = UpdateLinearIndex(WS.SpaceSize,StraightLineModulesInd(1),1,0.5);
        end
        [~, FrontPartModulesInd] = ScanningAgents(WS, ScannedAgent, StartModule, []); % for Left line i need to take the first module
        
        Axis = 3;
        Step = 1;
        
        [OK, WS, tree, ParentInd, FrontPartModulesInd] =...
            ManeuverStepProcess(WS,tree,ParentInd,FrontPartModulesInd, Axis, Step);
        if ~OK
            return
        end

        % b) Moving the branch 2 steps in the direction of the attack rim.

        ScannedAgent = ~WS.Space.Status;
        ScannedAgent(StraightLineModulesInd) = true;
        StartModule = ModulesInd(5);
        [~, ShiftBranchPartModulesInd] = ScanningAgents(WS, ScannedAgent, StartModule, []); % for Left line i need to take the first module
        
        Axis = 1;
        Step = 2;
        
        [OK, WS, tree, ParentInd, ShiftBranchPartModulesInd] =...
            ManeuverStepProcess(WS,tree,ParentInd,ShiftBranchPartModulesInd, Axis, Step);
        if ~OK
            return
        end
        % C) Lowering the entire part of section A in addition to the new modules added to it
        
        Axis = 3;
        Step = 1;
        
        [OK, WS, tree, ParentInd, FrontPartModulesInd] =...
            ManeuverStepProcess(WS,tree,ParentInd,[FrontPartModulesInd,ShiftBranchPartModulesInd], Axis, Step);
        if ~OK
            return
        end

end





end
