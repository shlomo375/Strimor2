function [Axis, Step, Moving_Log] = Beta_Alpha_Alpha__3(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)
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
    Position_relative_buttom_group = [0;-1;-1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Mid(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

switch MovmentDirection
    case "Left"
        Step = [Step, -1];
        Axis = [Axis,  3];
        Moving_Log(3,1:5) = true;

    case "Right"
        Step = [Step, 1];
        Axis = [Axis, 2];
        
        Moving_Log(3,[1:3,Top_Group_num+Mid_Group_num-0:2]) = true;  
end

end