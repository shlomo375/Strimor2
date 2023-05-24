function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Create_Beta_Beta(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,CurrentLine,varargin)
Step = [];
Axis = [];
Task = [];


if ~isempty(Edges)
    NotTested("Not Tested: Create_Beta_Beta")
    
    GroupSizeRequired = [4,3]; % article [-3,-4]
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,CurrentLine,Edges,GroupSizeRequired,"Create");
    if ~OK
        return
    end

    Position_relative_buttom_group = [inf;1;2]; %article [-2;-1] %%[inf;1;>2]
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1:2,:) = true;
    Moving_Log_Top(2,:) = true;
end

Step = [Step, 1,-1, -1];
Axis = [Axis, 2, 3,  2];

Moving_Log_Buttom(3,1:3) = true;
Moving_Log_Top(3,1) = true;

Moving_Log_Top(3,2) = true;

Moving_Log_Buttom(3,1) = true;

end