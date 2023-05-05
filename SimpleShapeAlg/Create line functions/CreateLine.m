function [WS,Tree, ParentInd, ConfigShift,Task_Queue] = CreateLine(WS,Tree, ParentInd,ConfigShift,Task_Queue,Plot)
arguments
    WS
    Tree
    ParentInd
    ConfigShift
    Task_Queue
    Plot = false;
end
Task = Task_Queue(end,:);
try

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),Task.Downwards);


Line = Task.Current_Line;
TargetGroup = Tree.EndConfig_IsomorphismMetrices{1}(Line,:,1);

Edges = Get_GroupEdges(GroupsSizes(Line+(1:2)),GroupIndexes(Line+(1:2)),GroupsInds(Line+(1:2)));

    
[Decision, Direction] = CheapCreateManeuver(Edges,TargetGroup);


try
% if matches(func2str(Decision),["Alpha_Alpha_Alpha__1","Beta_Beta_Beta__3"])
%     Task_Queue(end+1,:) = Decision(WS,GroupsSizes,Tree.EndConfig.IsomorphismMatrices1{:,:,1},ConfigShift,Task.Downwards, Line);
%     return
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%until here
fprintf("until here");
pause
Top_GroupInd = GroupsInds{Line+2}{1};
Mid_GroupInd = [];
Buttom_GroupInd = GroupsInds{Line+1}{1};

[Step, Axis, AllModuleInd, Moving_Log, NewTask] = ComputeManuver(Decision, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction,Task,Tree);

if size(NewTask,1)
    Task_Queue(end+1,:) = NewTask;
    return
end

[WS, Tree, ParentInd , OK] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);

if OK
    if Task.Downwards
        ConfigShift(2,1) = ConfigShift(1,1) - 1;

    else
        ConfigShift(1,1) = ConfigShift(2,1) - 1;
        
    end
%     if Task.Downwards
%         Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},[0;1]);
%     else
%         Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},[1;0]);
%     end
    Task_Queue(end,:) = [];
else
    error("bad manuvers");
end
catch eer
    eer
end

% ModuleTransitionData_Table = FinishTask(ModuleTransitionData_Table);
% Finish = CheckFinished(ModuleTransitionData_Table,Line-Downwards+(~Downwards), numel(Top_GroupInd), GroupsSizes, TargetGroupSize);
% ModuleTransitionData_Table = CreatTaskAllocationTable([],"Current_Line",Line-Downwards+(~Downwards),"Module_Num",numel(Top_GroupInd),"Side",Direction,"Downwards",Downwards,"Finish",Finish);
catch Remove_e
    Remove_e
end
    

end


function [ManeuverRequired, Direction] = CheapCreateManeuver(Three_Line_Edges,TargetGroup)
if TargetGroup > 0
    LeftEdge = "Alpha";
else
    LeftEdge = "Beta";
end
if abs(TargetGroup) == 1
    RightEdge = [];
else
    if EndIsAlpha(TargetGroup)
        RightEdge = "Alpha";
    else
        RightEdge = "Beta";
    end
end


Maneuver_Cost = struct("Alpha_Alpha_to_Alpha_Beta",2,...
                       "Alpha_Alpha_to_Alpha",4,...
                       ...
                       "Alpha_Beta_to_Alpha_Beta",2,... 
                       "Alpha_Beta_to_Alpha",1,...
                       ...
                       "Beta_Alpha_to_Beta_Beta",1,...
                        ...
                       "Beta_Beta_to_Beta_Alpha",1);

LineEdgesLeft = join(string([Three_Line_Edges(3,1,2), ...
                                 Three_Line_Edges(3,1,1)]),"_");
LineEdgesRight = join(string([Three_Line_Edges(3,2,2), ...
                             Three_Line_Edges(3,2,1)]),"_");
Right = join([LineEdgesRight.replace("-1","Beta").replace("1","Alpha"),join([RightEdge,LeftEdge],"_")],"_to_");
Left = join([LineEdgesLeft.replace("-1","Beta").replace("1","Alpha"),join([LeftEdge,RightEdge],"_")],"_to_");
if ~isfield(Maneuver_Cost,Right) && ~ isfield(Maneuver_Cost,Left)
    Field = fieldnames(Maneuver_Cost);
    RightField = Field(contains(extractBefore(Field,"_to_"),extractBefore(Right,"_to_")));
    Right = RightField{1};
    LeftField = Field(contains(extractBefore(Field,"_to_"),extractBefore(Left,"_to_")));
    Left = LeftField{1};
end
if Maneuver_Cost.(Right) < Maneuver_Cost.(Left)
    ManeuverRequired = str2func(Right);
    Direction = "Right";
else
    ManeuverRequired = str2func(Left);
    Direction = "Left";
end

end

























% function ModuleTransitionData = NextMove(ModuleTransitionData,Direction)
% 
% if ModuleTransitionData.Module_Num <= 1
%     ModuleTransitionData.NextDirection = Direction;
% else
%     ModuleTransitionData.NextDirection = "Both";
% end
% 
% end

% function Finish = CheckFinished(ModuleTransitionData,ReduceToLine, ReducedModuleNum, GroupsSizes, TargetGroupSize)
%     if ModuleTransitionData.DestenationLine
%         Finish = ModuleTransitionData.DestenationLine == ReduceToLine;
%     else
%         Finish = abs(TargetGroupSize(ReduceToLine)) - (abs(GroupsSizes(ReduceToLine))+ReducedModuleNum) >= 0;
%     end
%     
% 
% end






% function [Axis, Step, All_Moving_Module_Logical] = StepSeqence(LineSteps,MovmentDirection,Top_and_Mid_Edges,Num_Removed_Module,Num_Top_Group,Num_Mid_Group)
% 
% % group movment to the edges
% Axis = [1,1];
% Step = LineSteps;
% 
% 
% All_Moving_Module_Logical = false(3,Num_Top_Group+Num_Mid_Group);
% All_Moving_Module_Logical(1,1:Num_Top_Group) = true;
% All_Moving_Module_Logical(2,:) = true;%~All_Moving_Module_Logical(1,:);
% 
% 
% 
% switch MovmentDirection
%     case "Right"
%         EdgeCase = 10*Top_and_Mid_Edges{2}(3,2) + Top_and_Mid_Edges{1}(3,2);
%         switch EdgeCase
%             case 11 % Top-Alpha, Mid-Alpha
%                 Axis = [Axis,2];
%                 Step = [Step,1];
% 
%                 All_Moving_Module_Logical(3,[Num_Top_Group-1,Num_Top_Group]) = true;
%             case -11 % Top-Beta, Mid-Beta
%                 Axis = [Axis,3];
%                 Step = [Step,-1];
%                 
%                 All_Moving_Module_Logical(3,[Num_Top_Group-1,Num_Top_Group]) = true;
% 
%                 fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                     pause
%             case 9 % Top-Alpha, Mid-Beta
%                 if Num_Removed_Module == 1
%                     Axis = [Axis,3];
%                     Step = [Step,-1];
%                     
%                     All_Moving_Module_Logical(3,Num_Top_Group) = true;
% 
%                     All_Moving_Module_Logical(2,:) = [];
% 
%                     fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                     pause
%                 else
%                     Axis = [Axis(1),3,2];
%                     Step = [Step(1),-1,1];
% 
%                     All_Moving_Module_Logical(3,Num_Top_Group) = true;
%                     All_Moving_Module_Logical(4,:) = false;
%                     All_Moving_Module_Logical(4,Num_Top_Group-1) = true;
%                     All_Moving_Module_Logical(2,:) = [];  
% 
%                     fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                     pause
%                     
%                 end
%             case -9 % Top-Beta, Mid-Alpha
%                 Axis = [Axis(1),2];
%                 Step = [Step(1),1];
% 
%                 All_Moving_Module_Logical(3,Num_Top_Group) = true;
%                 All_Moving_Module_Logical(2,:) = [];
% 
%                 fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                     pause
%         end
%     case "Left"
%         EdgeCase = 10*Top_and_Mid_Edges{2}(3,1) + Top_and_Mid_Edges{1}(3,1);
%         switch EdgeCase
%             case -11 % Top-Beta, Mid-Beta
%                 Axis = [Axis,2];
%                 Step = [Step,1];
% 
%                 All_Moving_Module_Logical(3,1:2) = true;
% 
%                 fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                     pause
%             case 11 % Top-Alpha, Mid-Alpha
%                 Axis = [Axis,3];
%                 Step = [Step,-1];
% 
%                 All_Moving_Module_Logical(3,1:2) = true;
%                
%             case -9 % Top-Beta, Mid-Alpha
%                 Axis = [Axis(1),3];
%                 Step = [Step(1),-1];
% 
%                 All_Moving_Module_Logical(3,1) = true;
% 
%                 All_Moving_Module_Logical(2,:) = [];
% 
%                 fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                 pause
%             case 9 % Top-Alpha, Mid-Beta
%                 
%                 if Num_Removed_Module == 1
%                     Axis = [Axis,2];
%                     Step = [Step,1];
% 
%                     All_Moving_Module_Logical(3,1) = true;
% 
%                     fprintf("not tested yet: RemoveModule_StepSeqence function, case %d, Dir: %s",EdgeCase,MovmentDirection);
%                     pause
%                 else
%                     Axis = [Axis,2,3];
%                     Step = [Step,1,-1];
% 
%                     All_Moving_Module_Logical(3,1) = true;
%                     All_Moving_Module_Logical(4,:) = false;
%                     All_Moving_Module_Logical(4,2) = true;
% 
%                 end
%         end
% 
%         
% end
% 
% if any(~Step)
%     Axis(~Step) = [];
%     All_Moving_Module_Logical(~Step,:) = [];
%     Step(~Step) = [];
% end
% 
% 
% end
