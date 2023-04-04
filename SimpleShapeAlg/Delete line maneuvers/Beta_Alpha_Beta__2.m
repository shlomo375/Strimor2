function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Beta_Alpha_Beta__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)

if ~isempty(Edges)
    Position_relative_buttom_group = [0;-2;-2];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Mid(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end


Step = [Step, -1, -1];
Axis = [Axis,  3, 1];

Moving_Log_Top(3,1) = true;

Moving_Log_Top(4,2) = true;

Moving_Log_Top(5,1:2) = true;
Moving_Log_Mid(5,1) = true;

end