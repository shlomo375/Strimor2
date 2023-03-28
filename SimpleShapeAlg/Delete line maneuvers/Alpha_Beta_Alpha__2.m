function [Axis, Step, Moving_Log] = Alpha_Beta_Alpha__2(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)
arguments
    Top_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Mid_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Buttom_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    MovmentDirection (1,1) {matches(MovmentDirection,["Right","Left"])}
    Edges = [];
end

if ~isempty(Edges) % cansel
    Position_relative_buttom_group = [0;0;0];
    Step = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
end

end