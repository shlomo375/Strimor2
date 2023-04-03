function [Axis, Step, Moving_Log] = Beta_Beta_Beta__3(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)
%% spatial ettention
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

end