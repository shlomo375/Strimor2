function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Beta_Beta_Alpha__2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx,Module_Num)
Step = [];
Axis = [];
Task = [];
NotTested
if ~isempty(Edges)

    GroupSizeRequired = [2,-2,-2];
    [OK, Task] = PeripheralModuleExist(Tree,MovmentDirection,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end

    Position_relative_buttom_group = [-1;0;-1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end



Step = [Step, -1, -1, -1, 1];
Axis = [Axis,  2,  3,  1, 2];

Moving_Log_Buttom(4,1) = true;

Moving_Log_Top(5,1) = true;

Moving_Log_Top(6,2) = true;

Moving_Log_Top(7,1:2) = true;
Moving_Log_Mid(7,1) = true;


end