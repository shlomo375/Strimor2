function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Beta_Beta(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx,Module_Num)
Task = [];
Step = [];
Axis = [];
if Module_Num == 1
    StartConfig = Tree.Data{Tree.LastIndex,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig = Tree.EndConfig{1,"IsomorphismMatrices1"}{1}(:,:,1);
    Task = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, TopLineIdx-1, "AlphaDiff_Override",1,"BetaDiff_Override",0,Side=Direction);
    return
end

if ~isempty(Edges)
    
    GroupSizeRequired = [-1,-4];
    [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end
    
    Reletive_Position = [0;-3;1];
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,"Reduce");
    

    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step,1];
Axis = [Axis, 2];

Moving_Log_Mid(4,1:2) = true;

end