function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Beta_Alpha_Alpha__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)

if ~isempty(Edges)
    Position_relative_buttom_group = [0;-1;-1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Mid(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

Step = [Step, -1, -1, -1, 1];
Axis = [Axis,  2,  3,  1, 2];

Moving_Log_Mid(3,1) = true;
Moving_Log_Buttom(3,1) = true;

Moving_Log_Top(4,1) = true;
Moving_Log_Mid(4,1) = true;

Moving_Log_Top(5,2) = true;

Moving_Log_Top(5,1:2) = true;
Moving_Log_Mid(6,1) = true;
Moving_Log_Buttom(6,1) = true;

end