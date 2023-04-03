function [Axis, Step, Moving_Log] = Beta_Alpha_Beta__2(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)
arguments
    Top_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Mid_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Buttom_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    MovmentDirection (1,1) {matches(MovmentDirection,["Right","Left"])}
    Edges = [];
end

Top_Group_num = numel(Top_GroupInd);
Mid_Group_num = numel(Mid_GroupInd);
Buttom_Group_num = numel(Buttom_GroupInd);

All_Module_Ind = [Top_Group_num,Mid_Group_num,Buttom_Group_num];
Moving_Log = false(4,numel(All_Module_Ind));

if ~isempty(Edges)
    Position_relative_buttom_group = [0;-2;-2];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Mid(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

switch MovmentDirection
    case "Left"
        Step = [Step, -1, -1];
        Axis = [Axis,  3, 1];
        Moving_Log(3,1) = true;
        Moving_Log(3,2) = true;

        Mid_GroupInd = [Top_GroupInd(1) ,Mid_GroupInd];
        Top_GroupInd(1) = [];

    case "Right"
        Step = [Step, 1, 1];
        Axis = [Axis, 2, 1];
        
        Moving_Log(3,2) = true;  
        Moving_Log(3,1) = true;

        Mid_GroupInd = [Mid_GroupInd, Top_GroupInd(2)];
        Top_GroupInd(2) = [];
end

[Axis1, Step1, Moving_Log1] = Beta_Alpha_Beta__2(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection);

Axis = [Axis, Axis1];
Step = [Step, Step1];
Moving_Log = [Moving_Log; Moving_Log1];

end