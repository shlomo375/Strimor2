function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Alpha_Alpha_Beta__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)



if ~isempty(Edges)
    Position_relative_buttom_group = [0;-2;-1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Mid(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end


Step = [Step, 1, -1];
Axis = [Axis, 2, 3];
Moving_Log_Mid(3,1) = true;

Moving_Log_Mid(4,2) = true;
Moving_Log_Top(4,:) = true;



end