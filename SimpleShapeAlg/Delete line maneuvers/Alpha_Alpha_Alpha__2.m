function [Axis, Step, Moving_Log] = Alpha_Alpha_Alpha__2(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)

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
Moving_Log = false(7,numel(All_Module_Ind));

if ~isempty(Edges)
    Position_relative_buttom_group = [0;-1;0];
    Step = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
    Axis = ones(size(Step));
    
    Moving_Log(1,1:(Top_Group_num+Mid_Group_num)) = true;
    Moving_Log(2,1:Top_Group_num) = true;
end

switch MovmentDirection
    case "Left"
        Step = [Step, -1];
        Axis = [Axis,  3];
        Moving_Log(3,[1:2,(1:2)+Top_Group_num]) = true;

    case "Right"
        Step = [Step, 1];
        Axis = [Axis,  2];
        Moving_Log(3,[1:2,Top_Group_num+(Mid_Group_num-1:Mid_Group_num)]) = true;
end


end