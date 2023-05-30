function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Create_Alpha_Beta_2(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx)
Step = [];
Axis = [];
Task = [];


if ~isempty(Edges)
    NotTested("Not Tested: Create_Alpha_Beta_2")
    
    GroupSizeRequired = [-3,3];
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edges,GroupSizeRequired,"Create");
    if ~OK
        return
    end

    Position_relative_buttom_group = [inf;0;2]; %article: [0;0;-inf]
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1:2,:) = true;
    Moving_Log_Top(2,:) = true;
end

Step = [Step, 1];
Axis = [Axis, 2];

Moving_Log_Buttom(3,1:2) = true;
Moving_Log_Top(3,1) = true;



end