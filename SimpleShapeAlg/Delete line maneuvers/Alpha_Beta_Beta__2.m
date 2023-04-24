function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Alpha_Beta_Beta__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection)

if ~isempty(Edges)
    Position_relative_buttom_group = [0;-3;2];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step, 1, 1,-1];
Axis = [Axis, 3, 2, 3];

Moving_Log_Mid(4,1) = true;

Moving_Log_Mid(5,2) = true;


Moving_Log_Top(6,1:2) = true;
Moving_Log_Mid(6,[1,3]) = true;

end