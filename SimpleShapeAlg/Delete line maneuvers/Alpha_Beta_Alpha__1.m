function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = Alpha_Beta_Alpha__1(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Right_Left,Up_Down)


Position_relative_buttom_group = [0;0;2];
if matches(Up_Down,"Down")
    Position_relative_buttom_group = flip(Position_relative_buttom_group);
end
[Step, Axis] = ArangeGroupLocations(Right_Left,Edges,Position_relative_buttom_group);

Moving_Log_Mid(1,:) = true;
Moving_Log_Top(1:2,:) = true;


Step = [Step, 1, 1, -1, -1, -1, 1];
Axis = [Axis, 3, 1,  2,  3,  1, 2];

Moving_Log_Mid(3,1) = true;

Moving_Log_Buttom(4,:) = true;

Moving_Log_Mid(5,2) = true;
Moving_Log_Buttom(5,1) = true;

Moving_Log_Mid(6,1:2) = true;

Moving_Log_Top(7,1) = true;

Moving_Log_Top(8,1) = true;
Moving_Log_Mid(8,1:2) = true;
Moving_Log_Buttom(8,1) = true;

end