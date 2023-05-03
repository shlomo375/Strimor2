function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Alpha_Beta__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx)
Step = [];
Axis = [];
Task = [];



if ~isempty(Edges)

    GroupSizeRequired = [-1,3,2];
    [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end

    Position_relative_buttom_group = [0;-2;1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end


Step = [Step, 1, -1];
Axis = [Axis, 2, 3];
Moving_Log_Mid(4,1) = true;

Moving_Log_Mid(5,2) = true;
Moving_Log_Top(5,:) = true;



end