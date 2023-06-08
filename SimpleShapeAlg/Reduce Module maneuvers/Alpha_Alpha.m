function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom, Task] = Alpha_Alpha(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx,Module_Num)


Task = [];
Step = [];
Axis = [];
if Module_Num == 1
    StartConfig = Tree.Data{Tree.LastIndex,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig = Tree.EndConfig{1,"IsomorphismMatrices1"}{1}(:,:,1);
    Task = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, TopLineIdx-1, "AlphaDiff_Override",0,"BetaDiff_Override",1,Side=Direction);
    return
end
if ~isempty(Edges)
    
    if Edges(1,1,4)
        % NotTested("not fully tested")
        GroupSizeRequired = [2,4];
    else
        GroupSizeRequired = [2,3];
    end
    
    % GroupSizeRequired = [2,3];
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end
    
    
    
    Reletive_Position = [1;-1;2];
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,"Reduce");

    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step,-1];
Axis = [Axis, 3];

Moving_Log_Mid(4,1:2) = true;

end