function [WS,Tree, ParentInd, ConfigShift,ModuleTransitionData] = RemoveModules(WS,Tree, ParentInd,ConfigShift,Line,Downwards,ModuleTransitionData)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),ModuleTransitionData.Downwards);
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};

if abs(GroupsSizes(Line)) - abs(TargetGroupSize(Line)) > 1 || ModuleTransitionData.DestenationLine

    if Line < numel(GroupsInds) && GroupsSizes(Line+1)
        Edges = Get_GroupEdges(GroupsSizes(Line-2:Line+1),GroupIndexes(Line-2:Line+1),GroupsInds(Line-2:Line+1));
    else
        Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));
        Edges{4} = [];
    end
    
    [Decision, Direction] = RemoveModule_ActionSelection(GroupsSizes(Line), Edges);
    
    %% all moving modules
    % Top_GroupInd
    if numel(Decision) == 2 % Reduce module
        
        if Line == numel(GroupsInds) || ~GroupsSizes(Line+1)
            Top_GroupInd = [];
        else
            Top_GroupInd = GroupsInds{Line+1}{1};
        end
        Mid_GroupInd = GroupsInds{Line}{1};
        Buttom_GroupInd = GroupsInds{Line-1}{1};
    
        
        switch ModuleTransitionData.Side
            case "Left" % Moving one specific module from a certain side
                [Step, Axis, AllModuleInd, Moving_Log,ReducedModuleNum] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),ModuleTransitionData.Downwards);
                Direction = ModuleTransitionData.Side;
            case "Right"
                [Step, Axis, AllModuleInd, Moving_Log,ReducedModuleNum] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),ModuleTransitionData.Downwards);
                Direction = ModuleTransitionData.Side;
            otherwise
                [Step{2}, Axis{2}, AllModuleInd{2}, Moving_Log{2}] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),ModuleTransitionData.Downwards);
                [Step{1}, Axis{1}, AllModuleInd{1}, Moving_Log{1}] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),ModuleTransitionData.Downwards);
                
                [Step, Axis,AllModuleInd, Moving_Log,Direction, ReducedModuleNum] = DirectionCostSelection(Step, Axis,AllModuleInd, Moving_Log,Direction);
        end
        
        
        [Moving_Log,AllModuleInd] = AddAboveModule(Line+1,AllModuleInd,GroupsInds,Step,Axis, Moving_Log, Downwards);
        PlotStep = false;
        [WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);
        
    
        
        Finish = CheckFinished(ModuleTransitionData,Line-Downwards+(~Downwards), ReducedModuleNum, GroupsSizes, TargetGroupSize);
        
    
        if ReducedModuleNum == 1 && ~ModuleTransitionData.Sequence && ~ModuleTransitionData.DestenationLine
            ModuleTransitionData = CreatTaskAllocationTable(ModuleTransitionData,"Current_Line",Line,"Side",Direction,"Downwards",Downwards,"Module_Num",ReducedModuleNum,"Finish",Finish,"Sequence",true);
        else
            ModuleTransitionData = CreatTaskAllocationTable(ModuleTransitionData,"Current_Line",Line-Downwards+(~Downwards),"Side",Direction,"Module_Num",ReducedModuleNum,"Finish",Finish);
        end
    %         ModuleTransitionData = NextMove(ModuleTransitionData,Direction);
    
    else % Remove line
        try
        if matches(func2str(Decision),["Alpha_Alpha_Alpha__1","Beta_Beta_Beta__3"])
            ModuleTransitionData = Decision(WS, ConfigShift(:,1),Line,Downwards);
            return
        end
        
        Top_GroupInd = GroupsInds{Line}{1};
        Mid_GroupInd = GroupsInds{Line-1}{1};
        Buttom_GroupInd = GroupsInds{Line-2}{1};
    
        [Step, Axis, AllModuleInd, Moving_Log] = ComputeManuver(Decision, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction,Downwards);
        
        [WS, Tree, ParentInd , OK] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);
            
        if OK
            if Downwards
                ConfigShift(2,1) = ConfigShift(2,1) + 1;
    
            else
                ConfigShift(1,1) = ConfigShift(1,1) + 1;
                
            end
            Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},ConfigShift(:,1));
        end
        
        Finish = CheckFinished(ModuleTransitionData,Line-Downwards+(~Downwards), numel(Top_GroupInd), GroupsSizes, TargetGroupSize);
        ModuleTransitionData = CreatTaskAllocationTable([],"Current_Line",Line-Downwards+(~Downwards),"Module_Num",numel(Top_GroupInd),"Side",Direction,"Downwards",Downwards,"Finish",Finish);
        catch Remove_e
            Remove_e
        end
    end
    
        
    
    % end
else
    
end

end

function ModuleTransitionData = NextMove(ModuleTransitionData,Direction)

if ModuleTransitionData.Module_Num <= 1
    ModuleTransitionData.NextDirection = Direction;
else
    ModuleTransitionData.NextDirection = "Both";
end

end

function Finish = CheckFinished(ModuleTransitionData,ReduceToLine, ReducedModuleNum, GroupsSizes, TargetGroupSize)
    if ModuleTransitionData.DestenationLine
        Finish = ModuleTransitionData.DestenationLine == ReduceToLine;
    else
        Finish = abs(TargetGroupSize(ReduceToLine)) - (abs(GroupsSizes(ReduceToLine))+ReducedModuleNum) >= 0;
    end
    

end






function [Axis, Step, All_Moving_Module_Logical] = StepSeqence(LineSteps,MovmentDirection,Top_and_Mid_Edges,Num_Removed_Module,Num_Top_Group,Num_Mid_Group)

% group movment to the edges
Axis = [1,1];
Step = LineSteps;


All_Moving_Module_Logical = false(3,Num_Top_Group+Num_Mid_Group);
All_Moving_Module_Logical(1,1:Num_Top_Group) = true;
All_Moving_Module_Logical(2,:) = true;%~All_Moving_Module_Logical(1,:);



switch MovmentDirection
    case "Right"
        EdgeCase = 10*Top_and_Mid_Edges{2}(3,2) + Top_and_Mid_Edges{1}(3,2);
        switch EdgeCase
            case 11 % Top-Alpha, Mid-Alpha
                Axis = [Axis,2];
                Step = [Step,1];

                All_Moving_Module_Logical(3,[Num_Top_Group-1,Num_Top_Group]) = true;
            case -11 % Top-Beta, Mid-Beta
                Axis = [Axis,3];
                Step = [Step,-1];
                
                All_Moving_Module_Logical(3,[Num_Top_Group-1,Num_Top_Group]) = true;

                fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                    pause
            case 9 % Top-Alpha, Mid-Beta
                if Num_Removed_Module == 1
                    Axis = [Axis,3];
                    Step = [Step,-1];
                    
                    All_Moving_Module_Logical(3,Num_Top_Group) = true;

                    All_Moving_Module_Logical(2,:) = [];

                    fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                    pause
                else
                    Axis = [Axis(1),3,2];
                    Step = [Step(1),-1,1];

                    All_Moving_Module_Logical(3,Num_Top_Group) = true;
                    All_Moving_Module_Logical(4,:) = false;
                    All_Moving_Module_Logical(4,Num_Top_Group-1) = true;
                    All_Moving_Module_Logical(2,:) = [];  

                    fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                    pause
                    
                end
            case -9 % Top-Beta, Mid-Alpha
                Axis = [Axis(1),2];
                Step = [Step(1),1];

                All_Moving_Module_Logical(3,Num_Top_Group) = true;
                All_Moving_Module_Logical(2,:) = [];

                fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                    pause
        end
    case "Left"
        EdgeCase = 10*Top_and_Mid_Edges{2}(3,1) + Top_and_Mid_Edges{1}(3,1);
        switch EdgeCase
            case -11 % Top-Beta, Mid-Beta
                Axis = [Axis,2];
                Step = [Step,1];

                All_Moving_Module_Logical(3,1:2) = true;

                fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                    pause
            case 11 % Top-Alpha, Mid-Alpha
                Axis = [Axis,3];
                Step = [Step,-1];

                All_Moving_Module_Logical(3,1:2) = true;
               
            case -9 % Top-Beta, Mid-Alpha
                Axis = [Axis(1),3];
                Step = [Step(1),-1];

                All_Moving_Module_Logical(3,1) = true;

                All_Moving_Module_Logical(2,:) = [];

                fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                pause
            case 9 % Top-Alpha, Mid-Beta
                
                if Num_Removed_Module == 1
                    Axis = [Axis,2];
                    Step = [Step,1];

                    All_Moving_Module_Logical(3,1) = true;

                    fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
                    pause
                else
                    Axis = [Axis,2,3];
                    Step = [Step,1,-1];

                    All_Moving_Module_Logical(3,1) = true;
                    All_Moving_Module_Logical(4,:) = false;
                    All_Moving_Module_Logical(4,2) = true;

                end
        end

        
end

if any(~Step)
    Axis(~Step) = [];
    All_Moving_Module_Logical(~Step,:) = [];
    Step(~Step) = [];
end


end
