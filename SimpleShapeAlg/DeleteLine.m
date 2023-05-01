function [WS,Tree, ParentInd, ConfigShift,Task_Queue] = DeleteLine(WS,Tree, ParentInd,ConfigShift,Task_Queue,Plot)
arguments
    WS
    Tree
    ParentInd
    ConfigShift
    Task_Queue
    Plot = false;
end
Task = Task_Queue(end,:);

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1),Task.Downwards);
% TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};

Line = Task.Current_Line;

Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));

    
[Decision, Direction] = CheapRemoveManeuver(Edges,abs(GroupsSizes(Line)));


try
if matches(func2str(Decision),["Alpha_Alpha_Alpha__1","Beta_Beta_Beta__3"])
    Task_Queue(end+1,:) = Decision(WS,GroupsSizes,Tree.EndConfig.IsomorphismMatrices1{:,:,1},ConfigShift,Task.Downwards, Line);
    return
end

Top_GroupInd = GroupsInds{Line}{1};
Mid_GroupInd = GroupsInds{Line-1}{1};
Buttom_GroupInd = GroupsInds{Line-2}{1};

[Step, Axis, AllModuleInd, Moving_Log] = ComputeManuver(Decision, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Direction,Task.Downwards);

[WS, Tree, ParentInd , OK] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);
    
if OK
    if Task.Downwards
        ConfigShift(2,1) = ConfigShift(2,1) + 1;

    else
        ConfigShift(1,1) = ConfigShift(1,1) + 1;
        
    end
    if Task.Downwards
        Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},[0;1]);
    else
        Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},[1;0]);
    end
    Task_Queue(end,:) = [];
else
    error("bad manuvers");
end

% ModuleTransitionData_Table = FinishTask(ModuleTransitionData_Table);
% Finish = CheckFinished(ModuleTransitionData_Table,Line-Downwards+(~Downwards), numel(Top_GroupInd), GroupsSizes, TargetGroupSize);
% ModuleTransitionData_Table = CreatTaskAllocationTable([],"Current_Line",Line-Downwards+(~Downwards),"Module_Num",numel(Top_GroupInd),"Side",Direction,"Downwards",Downwards,"Finish",Finish);
catch Remove_e
    Remove_e
end
    

end


function [ManeuverRequired, Direction] = CheapRemoveManeuver(Three_Line_Edges,NumModule_TopLine)

Maneuver_Cost = struct("Alpha_Alpha_Alpha__1",100,...
                       "Alpha_Alpha_Alpha__2",2,...
                       ...
                       "Alpha_Alpha_Beta__1",7,...
                       "Alpha_Alpha_Beta__2",2,...
                       ...
                       "Alpha_Beta_Alpha__1",6,...
                       "Alpha_Beta_Alpha__2",1,...
                        ...
                       "Alpha_Beta_Beta__1",1,...
                       "Alpha_Beta_Beta__2",3,...
                        ...
                        ...
                        ...
                       "Beta_Alpha_Alpha__2",4,...
                       "Beta_Alpha_Alpha__3",1,...
                       ...
                       "Beta_Alpha_Beta__2",3,...
                       "Beta_Alpha_Beta__3",2,...
                       ...
                       "Beta_Beta_Alpha__2",4,...
                       "Beta_Beta_Alpha__3",1,...
                       ...
                       "Beta_Beta_Beta__2",1,...
                       "Beta_Beta_Beta__3",100);

LineEdgesLeft = join(string([Three_Line_Edges(3,1,3), ...
                                 Three_Line_Edges(3,1,2), ...
                                 Three_Line_Edges(3,1,1)]),"_");
LineEdgesRight = join(string([Three_Line_Edges(3,2,3), ...
                             Three_Line_Edges(3,2,2), ...
                             Three_Line_Edges(3,2,1)]),"_");
Right = join([LineEdgesRight.replace("-1","Beta").replace("1","Alpha"),string(abs(NumModule_TopLine))],"__");
Left = join([LineEdgesLeft.replace("-1","Beta").replace("1","Alpha"),string(abs(NumModule_TopLine))],"__");

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
