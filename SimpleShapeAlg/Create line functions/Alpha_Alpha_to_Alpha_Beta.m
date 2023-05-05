function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Alpha_to_Alpha_Beta(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx)
Step = [];
Axis = [];
Task = [];


if ~isempty(Edges)
    NotTested("Not Tested: Alpha_Alpha_to_Alpha_Beta")
    
    GroupSizeRequired = [-3,-4];
    [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end

    Position_relative_buttom_group = [-1;1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1:2,:) = true;
    Moving_Log_Top(2,:) = true;
end

Step = [Step, 1];
Axis = [Axis, 2];

Moving_Log_Buttom(3,1:2) = true;
Moving_Log_Top(3,1:2) = true;



end