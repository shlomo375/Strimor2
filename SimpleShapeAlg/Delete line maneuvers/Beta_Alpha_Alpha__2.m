function [Axis, Step, Moving_Log] = Beta_Alpha_Alpha__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)
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
        Step = [Step, -1, 1, 1,-1];
        Axis = [Axis,  3, 2, 3, 2];
        Moving_Log(3,1:4) = true;
        Moving_Log(4,[1:4,end-(Buttom_Group_num-1)]) = true;
        Moving_Log(5,1) = true;
        Moving_Log(6,[2:4,end-(Buttom_Group_num-1)]) = true;


    case "Right"
        Step = [Step, 1, -1, 1, -1, -1, 1];
        Axis = [Axis, 2,  3, 3,  2,  2, 3];
        
        Moving_Log(3,[1:2,Top_Group_num+Mid_Group_num-[0,1]]) = true;
        Moving_Log(4,[1:2,Top_Group_num+Mid_Group_num-[0,1],end]) = true;
        Moving_Log(5,2) = true;
        Moving_Log(6,[1,Top_Group_num+Mid_Group_num-[0,1],end]) = true;
end

end