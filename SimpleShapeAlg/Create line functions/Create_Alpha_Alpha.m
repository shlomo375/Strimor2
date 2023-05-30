function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Create_Alpha_Alpha(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx,varargin)
Step = [];
Axis = [];
Task = [];


if ~isempty(Edges)
    % NotTested("Not Tested: Create_Alpha_Alpha")
    
    GroupSizeRequired = [4,3]; % articl
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edges,GroupSizeRequired,"Create");
    if ~OK
        return
    end

    Position_relative_buttom_group =  [-1,1,-inf]; % articl:[-1;3]
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Position_relative_buttom_group,"Create");
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

Step = [Step, 1];
Axis = [Axis, 3];

Moving_Log_Buttom(3,1:2) = true;
Moving_Log_Top(3,1:2) = true;



end