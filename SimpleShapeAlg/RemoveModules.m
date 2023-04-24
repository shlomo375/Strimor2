function [WS,Tree, ParentInd, ConfigShift,ModuleTransitionData] = RemoveModules(WS,Tree, ParentInd,ConfigShift,Line,Downwards,ModuleTransitionData)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1));
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};
% GroupMatrix = GetGroupMatrixFromTree(Tree,ParentInd);
GroupsInLine = GroupsSizes(Line,GroupsSizes(Line,:)~=0);
for GroupNum = 1:length(GroupsInLine)
    
    
%     [BaseGroupNum_1st, BaseGroupInd_1st] = GetBasedGroup(WS,GroupsInds{Line-1},Top_GroupInd);
%     [BaseGroupNum_2nd, BaseGroupInd_2nd] = GetBasedGroup(WS,GroupsInds{Line-2},GroupsInds{Line-1}{BaseGroupNum_1st});
    if Downwards
        if Line < numel(GroupsInds) && GroupsSizes(Line+1)
            Edges = Get_GroupEdges(GroupsSizes(Line-2:Line+1),GroupIndexes(Line-2:Line+1),GroupsInds(Line-2:Line+1));
        else
            Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));
            Edges{4} = [];
        end
    else
        % It is necessary to change the creation of the edges when the move is from bottom to top.
        % The type of modules changes from an alpha module to a beta,
        % so the type of operation required will also change. It should also be checked by deleting a line
        Edges = flip(Get_GroupEdges(GroupsSizes(Line-1:Line+2),GroupIndexes(Line-1:Line+2),GroupsInds(Line-1:Line+2)));
    end
%     [Decision, Parameter, Get_to_Destination_Line] = RemoveModule_ActionSelection(GroupsSizes(Line-2:Line), TargetGroupSize(Line-2:Line), Edges,GroupNum);
    [Decision, Direction] = RemoveModule_ActionSelection(GroupsSizes(Line), Edges,GroupNum);

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


        [Step{2}, Axis{2}, AllModuleInd{2}, Moving_Log{2}] = ComputeManuver(Decision{2}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(2),Downwards);
        [Step{1}, Axis{1}, AllModuleInd{1}, Moving_Log{1}] = ComputeManuver(Decision{1}, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction(1),Downwards);
        
        [Step, Axis,AllModuleInd, Moving_Log,Direction, ReducedModuleNum] = DirectionCostSelection(Step, Axis,AllModuleInd, Moving_Log,Direction);
        
        [Moving_Log,AllModuleInd] = AddAboveModule(Line+1,AllModuleInd,GroupsInds,Step,Axis, Moving_Log, Downwards);

        [WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);
        


        Finish = CheckFinished(Line-Downwards+(~Downwards), ReducedModuleNum, GroupsSizes, TargetGroupSize);
        

        if ReducedModuleNum == 1 && ~ModuleTransitionData.Sequence
            ModuleTransitionData = CreatTaskAllocationTable("Current_Line",Line,"Side",Direction,"Downwards",Downwards,"Module_Num",ReducedModuleNum,"finish",Finish,"Sequence",true);
        else
            ModuleTransitionData = CreatTaskAllocationTable("Current_Line",Line-Downwards+(~Downwards),"Side",Direction,"Downwards",Downwards,"Module_Num",ReducedModuleNum,"finish",Finish);
        end
%         ModuleTransitionData = NextMove(ModuleTransitionData,Direction);

    else % Remove line
        Top_GroupInd = GroupsInds{Line}{1};
        Mid_GroupInd = GroupsInds{Line-1}{1};
        Buttom_GroupInd = GroupsInds{Line-2}{1};
    

%     if ~isa(Decision,"function_handle")
%         switch Decision
%             case "Remove Module"
%                 Num_Removed_Module = Direction(1); %needed function
%                 
%                 if ~isempty(ModuleTransitionData)
%                     MovmentDirection = ModuleTransitionData.Side;
%                 else
%                     MovmentDirection = "Both";
%                 end
% 
% %                 [Step, Axis] = ArangeGroupLocations(Direction,Edges,Position_relative_buttom_group,GroupsNum)
% %                 [LineSteps, MovmentDirection] = Get_Step_To_Remove_Module(Edges,GroupNum,BaseGroupNum_1st,BaseGroupNum_2nd,MovmentDirection);
%                 [Step, Axis, MovmentDirection] = ArangeLinePostion_For_ReduceModule(MovmentDirection, Edges);
% 
%                 
%                 AllModuleInd = [Top_GroupInd, Mid_GroupInd]';
%                 
%                 
%                 [Axis, Step, Moving_Log] = StepSeqence(LineSteps,MovmentDirection,Edges(2:3),Num_Removed_Module,numel(Top_GroupInd),numel(Mid_GroupInd));
%                 
%                 [Moving_Log,AllModuleInd] = AddAboveModule(Line,AllModuleInd,GroupsInds,LineSteps, Moving_Log, Downwards);
%                 %% movment process
%             
%                 [WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);
%                 
%                 ModuleTransitionData = CreatTaskAllocationTable("Current_Line",Line-Downwards+(~Downwards),"Module_Num",Num_Removed_Module,"Side",MovmentDirection,"Downwards",Downwards,"Finish",Get_to_Destination_Line);
%         % end
%     else
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
        
        Finish = CheckFinished(Line-Downwards+(~Downwards), numel(Top_GroupInd), GroupsSizes, TargetGroupSize);
        ModuleTransitionData = CreatTaskAllocationTable("Current_Line",Line-Downwards+(~Downwards),"Module_Num",numel(Top_GroupInd),"Side",Direction,"Downwards",Downwards,"Finish",Finish);
    end

    

end

end

function ModuleTransitionData = NextMove(ModuleTransitionData,Direction)

if ModuleTransitionData.Module_Num <= 1
    ModuleTransitionData.NextDirection = Direction;
else
    ModuleTransitionData.NextDirection = "Both";
end

end

function Finish = CheckFinished(ReduceToLine, ReducedModuleNum, GroupsSizes, TargetGroupSize)

    Finish = abs(TargetGroupSize(ReduceToLine)) - (abs(GroupsSizes(ReduceToLine))+ReducedModuleNum) >= 0;

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
