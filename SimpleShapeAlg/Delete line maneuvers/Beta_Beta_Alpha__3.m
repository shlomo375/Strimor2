function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Beta_Beta_Alpha__3(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)

if ~isempty(Edges)
    Position_relative_buttom_group = [inf;0;-1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end


Step = [Step, -1];
Axis = [Axis,  3];

Moving_Log_Top(4,1:3) = true;
Moving_Log_Mid(4,1) = true;

end