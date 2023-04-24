function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Beta_Alpha_Beta__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection)

if ~isempty(Edges)
    Position_relative_buttom_group = [0;-2;0];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
    
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end


Step = [Step, -1, -1];
Axis = [Axis,  3, 1];

Moving_Log_Top(4,1) = true;

Moving_Log_Top(5,2) = true;

Moving_Log_Top(6,1:2) = true;
Moving_Log_Mid(6,1) = true;

end