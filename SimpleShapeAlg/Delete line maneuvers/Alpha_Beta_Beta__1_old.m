function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Beta_Beta__1(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx,Module_Num)
Step = [];
Axis = [];
Task = [];

if ~isempty(Edges)

    GroupSizeRequired = [-1,-4,1];
    [OK, Task] = PeripheralModuleExist(Tree,MovmentDirection,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end

    Position_relative_buttom_group = [0;-3;0];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end


Step = [Step, 1];
Axis = [Axis, 2];

Moving_Log_Top(4,1) = true;
Moving_Log_Mid(4,1:2) = true;


end