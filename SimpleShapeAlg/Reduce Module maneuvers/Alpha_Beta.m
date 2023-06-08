function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Beta(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx,Module_Num)

Task = [];
Step = [];
Axis = [];

if ~isempty(Edges)
    GroupSizeRequired = [-1,3];
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end
    
    Reletive_Position = [0;-2;-inf];
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,"Reduce");
    

    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step,1];
Axis = [Axis, 2];

Moving_Log_Mid(4,1) = true;

end