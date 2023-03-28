function [WS,Tree, ParentInd] = RemoveModules(WS,Tree, ParentInd,ConfigShift,Line)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1));
TargetGroupSize = Tree.EndConfig_IsomorphismMetrices{1};
% GroupMatrix = GetGroupMatrixFromTree(Tree,ParentInd);
GroupsInLine = GroupsSizes(Line,GroupsSizes(Line,:)>0);
for GroupNum = 1:length(GroupsInLine)
    
    TopGroupInd = GroupsInds{Line}{GroupNum};
    [BaseGroupNum_1st, Mid_Group_Ind] = GetBasedGroup(WS,GroupsInds{Line-1},TopGroupInd);
    [BaseGroupNum_2nd, BaseGroupInd_2nd] = GetBasedGroup(WS,GroupsInds{Line-2},GroupsInds{Line-1}{BaseGroupNum_1st});

    
    Edges = Get_GroupEdges(GroupsSizes(Line-2:Line),GroupIndexes(Line-2:Line),GroupsInds(Line-2:Line));
    
    [Decision, Parameter] = RemoveModule_ActionSelection(GroupsSizes(Line-2:Line), TargetGroupSize(Line-2:Line), Edges,GroupNum);
    
    switch Decision
        case "Remove Module"
            Num_Removed_Module = Parameter{1}; %needed function
            [LineSteps, MovmentDirection] = Get_Step_To_Remove_Module(Edges,GroupNum,BaseGroupNum_1st,BaseGroupNum_2nd,"Left");
    
            %% all moving modules
            % TopGroupInd
            % Mid_Group_Ind
            AllModuleInd = [TopGroupInd, Mid_Group_Ind];
            
            
            [Axis, Step, Moving_Log] = StepSeqence(LineSteps,MovmentDirection,Edges(2:3),Num_Removed_Module,numel(TopGroupInd),numel(Mid_Group_Ind));
        
            %% movment process
        
            [WS, tree, ParentInd] = Sequence_of_Maneuvers(WS,tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step);
    end

    

end

end








function [Axis, Step, All_Moving_Module_Logical] = StepSeqence(LineSteps,MovmentDirection,Top_and_Mid_Edges,Num_Removed_Module,Num_Top_Group,Num_Mid_Group)

% group movment to the edges
Axis = [1,1];
Step = LineSteps;


All_Moving_Module_Logical = false(3,Num_Top_Group+Num_Mid_Group);
All_Moving_Module_Logical(1,1:Num_Top_Group) = true;
All_Moving_Module_Logical(2,:) = ~All_Moving_Module_Logical(1,:);


EdgeCase = 10*Top_and_Mid_Edges{2}(3,1) + Top_and_Mid_Edges{1}(1,1);
switch MovmentDirection
    case "Right"
        switch EdgeCase
            case 11 % Top-Alpha, Mid-Alpha
                Axis = [Axis,2];
                Step = [Step,1];

                All_Moving_Module_Logical(3,[Num_Top_Group-1,Num_Top_Group]) = true;
            case -11 % Top-Beta, Mid-Beta
                Axis = [Axis,3];
                Step = [Step,-1];
                
                All_Moving_Module_Logical(3,[Num_Top_Group-1,Num_Top_Group]) = true;
            case 9 % Top-Alpha, Mid-Beta
                if Num_Removed_Module == 1
                    Axis = [Axis,3];
                    Step = [Step,-1];
                    
                    All_Moving_Module_Logical(3,Num_Top_Group) = true;

                    All_Moving_Module_Logical(2,:) = [];
                else
                    Axis = [Axis(1),3,2];
                    Step = [Step(1),-1,1];

                    All_Moving_Module_Logical(3,Num_Top_Group) = true;
                    All_Moving_Module_Logical(4,:) = false;
                    All_Moving_Module_Logical(4,Num_Top_Group-1) = true;
                    All_Moving_Module_Logical(2,:) = [];   
                    
                end
            case -9 % Top-Beta, Mid-Alpha
                Axis = [Axis(1),2];
                Step = [Step(1),1];

                All_Moving_Module_Logical(3,Num_Top_Group) = true;
                All_Moving_Module_Logical(2,:) = [];
        end
    case "Left"
        switch EdgeCase
            case -11 % Top-Beta, Mid-Beta
                Axis = [Axis,2];
                Step = [Step,1];

                All_Moving_Module_Logical(3,1:2) = true;
            case 11 % Top-Alpha, Mid-Alpha
                Axis = [Axis,3];
                Step = [Step,-1];

                All_Moving_Module_Logical(3,1:2) = true;
            case -9 % Top-Beta, Mid-Alpha
                Axis = [Axis(1),3];
                Step = [Step(1),-1];

                All_Moving_Module_Logical(3,1) = true;

                All_Moving_Module_Logical(2,:) = [];
            case 9 % Top-Alpha, Mid-Beta
                
                if Num_Removed_Module == 1
                    Axis = [Axis,2];
                    Step = [Step,1];

                    All_Moving_Module_Logical(3,1) = true;
                else
                    Axis = [Axis,2,3];
                    Step = [Step,1,-1];

                    All_Moving_Module_Logical(3,1) = true;
                    All_Moving_Module_Logical(4,:) = false;
                    All_Moving_Module_Logical(4,2) = true;
                end
        end
end




end
