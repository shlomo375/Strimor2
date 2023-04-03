function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Alpha_Alpha_Beta__1(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges)
arguments
    Moving_Log_Top
    Moving_Log_Mid
    Moving_Log_Buttom
    Edges = [];
end


if ~isempty(Edges)
    Position_relative_buttom_group = [0;2;3];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Mid(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

Step = [Step, 1,1,1,-1,1,1,-1];
Axis = [Axis, 3,3,1,3,2,3,2];
Moving_Log_Buttom(3,1) = true;
Moving_Log_Buttom(4,1) = true;
Moving_Log_Buttom(5,2:end) = true;

Moving_Log_Top(6,1) = true;
Moving_Log_Mid(6,1:2) = true;
Moving_Log_Buttom(6,1) = true;

Moving_Log_Top(7,1) = true;
Moving_Log_Mid(7,1:2) = true;
Moving_Log_Buttom(7,1) = true;

Moving_Log_Buttom(8,1) = true;

Moving_Log_Mid(9,1:2) = true;
Moving_Log_Buttom(9,1) = true;


end