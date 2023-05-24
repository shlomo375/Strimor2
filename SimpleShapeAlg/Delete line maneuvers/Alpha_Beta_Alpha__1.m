function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Beta_Alpha__1(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx,Module_Num)
Step = [];
Axis = [];
Task = [];


if ~isempty(Edges)
    Position_relative_buttom_group = [-3,0,2];

    GroupSizeRequired = [5,-4,1];
    [OK, Task] = PeripheralModuleExist(Tree,MovmentDirection,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end

    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step, 1, 1, -1, -1, -1, 1];
Axis = [Axis, 3, 1,  2,  3,  1, 2];

Moving_Log_Mid(4,1) = true;

Moving_Log_Buttom(5,:) = true;

Moving_Log_Mid(6,2) = true;
Moving_Log_Buttom(6,1) = true;

Moving_Log_Mid(7,1:2) = true;

Moving_Log_Top(8,1) = true;

Moving_Log_Top(9,1) = true;
Moving_Log_Mid(9,1:2) = true;
Moving_Log_Buttom(9,1) = true;

end