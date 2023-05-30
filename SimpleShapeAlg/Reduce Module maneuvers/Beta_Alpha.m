function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Beta_Alpha(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx,A)
arguments
    Moving_Log_Top
    Moving_Log_Mid
    Moving_Log_Buttom
    Edges
    Direction
    Downwards
    Tree
    TopLineIdx
    A.Module_Num = [];
    A.Task = [];
end


Task = [];
Step = [];
Axis = [];

if ~isempty(Edges)
    if Edges(1,1,4)
        % NotTested("not fully tested")
        GroupSizeRequired = [2,-3];
    else
        GroupSizeRequired = [2,-2];
    end
    
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end


    Reletive_Position = [inf;0;1];
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,"Reduce");
    

    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step,-1];
Axis = [Axis, 3];

Moving_Log_Mid(4,1) = true;

end