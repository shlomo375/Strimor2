function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Alpha_Alpha_Alpha__1(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection)
%% spacual ettentions


if ~isempty(Edges)
    Position_relative_buttom_group = []
    Step = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
end


end