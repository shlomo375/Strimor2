function [WS,Tree, ParentInd, ConfigShift,ModuleTransitionData] = RemoveModules(WS,Tree, ParentInd,ConfigShift,Line,Downwards,ModuleTransitionData)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1));
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};
% GroupMatrix = GetGroupMatrixFromTree(Tree,ParentInd);
GroupsInLine = GroupsSizes(Line,GroupsSizes(Line,:)~=0);
for GroupNum = 1:length(GroupsInLine)
    
    Top_GroupInd = GroupsInds{Line}{GroupNum};
    [BaseGroupNum_1st, BaseGroupInd_1st] = GetBasedGroup(WS,GroupsInds{Line-1},Top_GroupInd);
    [BaseGroupNum_2nd, BaseGroupInd_2nd] = GetBasedGroup(WS,GroupsInds{Line-2},GroupsInds{Line-1}{BaseGroupNum_1st});

    
    Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));
    
    [Decision, Parameter, Get_to_Destination_Line] = RemoveModule_ActionSelection(GroupsSizes(Line-2:Line), TargetGroupSize(Line-2:Line), Edges,GroupNum);
    
    %% all moving modules
    % Top_GroupInd
    Mid_GroupInd = GroupsInds{Line-1}{BaseGroupNum_1st};
    Buttom_GroupInd = GroupsInds{Line-2}{BaseGroupNum_2nd};

    if ~isa(Decision,"function_handle")
        switch Decision
            case "Remove Module"
                Num_Removed_Module = Parameter(1); %needed function
                
                if ~isempty(ModuleTransitionData)
                    MovmentDirection = ModuleTransitionData.Side;
                else
                    MovmentDirection = "Both";
                end
                [LineSteps, MovmentDirection] = Get_Step_To_Remove_Module(Edges,GroupNum,BaseGroupNum_1st,BaseGroupNum_2nd,MovmentDirection);
        
                
                AllModuleInd = [Top_GroupInd, Mid_GroupInd]';
                
                
                [Axis, Step, Moving_Log] = StepSeqence(LineSteps,MovmentDirection,Edges(2:3),Num_Removed_Module,numel(Top_GroupInd),numel(Mid_GroupInd));
                
                [Moving_Log,AllModuleInd] = AddAboveModule(Line,AllModuleInd,GroupsInds,LineSteps, Moving_Log, Downwards);
                %% movment process
            
                [WS, Tree, ParentInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);
                
                ModuleTransitionData = CreatTaskAllocationTable("Current_Line",Line-Downwards+(~Downwards),"Module_Num",Num_Removed_Module,"Side",MovmentDirection,"Downwards",Downwards,"Finish",Get_to_Destination_Line);
        end
    else
        [Step, Axis, AllModuleInd, Moving_Log] = ComputeManuver(Decision, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Parameter,Downwards);
        
        [WS, Tree, ParentInd , OK] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true);
            
        if OK
            if Downwards
                ConfigShift(1,1) = ConfigShift(1,1) + 1;

            else
                ConfigShift(2,1) = ConfigShift(2,1) + 1;
                
            end
            Tree.Data{ParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Tree.Data{ParentInd,"IsomorphismMatrices1"}{1},ConfigShift(:,1));
        end

        ModuleTransitionData = CreatTaskAllocationTable("Current_Line",Line-Downwards+(~Downwards),"Module_Num",numel(Top_GroupInd),"Side",Parameter,"Downwards",Downwards,"Finish",Get_to_Destination_Line);
    end

    

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
