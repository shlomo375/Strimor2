function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Alpha_Alpha_Alpha__1(ManuverHandle, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Right_Left,Up_Down)
%% spacual ettentions
arguments
    Top_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Mid_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Buttom_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    MovmentDirection (1,1) {matches(MovmentDirection,["Right","Left"])}
    Edges = [];
end

if ~isempty(Edges)
    Position_relative_buttom_group = []
    Step = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
end


end