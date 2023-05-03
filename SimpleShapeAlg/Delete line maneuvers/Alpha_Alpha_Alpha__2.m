function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Alpha_Alpha__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx)
Step = [];
Axis = [];
Task = [];

if ~isempty(Edges)
    Position_relative_buttom_group = [1;-1;1];

    GroupSizeRequired = [2,3,2];
    [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end

    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end


Step = [Step, -1];
Axis = [Axis,  3];

Moving_Log_Top(4,:) = true;
Moving_Log_Mid(4,1:2) = true;



end