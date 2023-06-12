function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Create_Beta_Alpha(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,Downwards,Tree,TopLineIdx,varargin)
Step = [];
Axis = [];
Task = [];

% Task = Module_Task_Allocation(GroupSize, TargetGroupSize, ~Downwards, SwitchLine, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
if ~isempty(Edges)
    if Downwards
        % NotTested("Not Tested: Create_Alpha_Beta_1 Downwards==1")
    end
    
    GroupSizeRequired = [-3,3];
    [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edges,GroupSizeRequired,"Create");
    if ~OK
        return
    end

    Position_relative_buttom_group = [-1;0;-inf]; %article [2;0;inf]
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Position_relative_buttom_group,"Create");
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

Step = [Step, -1];
Axis = [Axis, 3];

Moving_Log_Top(3,1) = true;

Step(4) = -1;
Axis(4) = 1;
Moving_Log_Top(4,2:end) = true;

Step(5) = -1;
Axis(5) = 2;
Moving_Log_Top(5,1:2) = true;
Moving_Log_Buttom(5,1) = true;

end