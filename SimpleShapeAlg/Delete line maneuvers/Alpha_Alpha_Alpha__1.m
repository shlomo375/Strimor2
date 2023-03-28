function [Axis, Step, Moving_Log] = Alpha_Alpha_Alpha__1(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)
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