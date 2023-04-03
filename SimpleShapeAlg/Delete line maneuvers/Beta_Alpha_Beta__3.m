function [Axis, Step, Moving_Log] = Beta_Alpha_Beta__3(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)
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
        Step = [Step, 1, -1];
        Axis = [Axis, 2, 3];
        Moving_Log(3,4) = true;
        Moving_Log(3,[1:3,5]) = true;


    case "Right"
        Step = [Step, -1, 1];
        Axis = [Axis, 3, 2];
        
        Moving_Log(3,Top_Group_num+Mid_Group_num) = true;  
        Moving_Log(3,[1:3,Top_Group_num+Mid_Group_num-1]) = true;

end


end