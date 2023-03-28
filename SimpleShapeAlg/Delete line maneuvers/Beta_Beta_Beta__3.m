function [Axis, Step, Moving_Log] = Beta_Beta_Beta__3(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)
%% spatial ettention
arguments
    Top_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Mid_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    Buttom_GroupInd {mustBeVector,mustBeInteger,mustBePositive}
    MovmentDirection (1,1) {matches(MovmentDirection,["Right","Left"])}
    Edges = [];
end

end