function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Alpha_Alpha_Beta__1(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx,Module_Num)
Step = [];
Axis = [];
Task = [];

if ~isempty(Edges)
    
    % NotTested("need to change the movments");
    GroupSizeRequired = [-1,5,1];
    [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edges,GroupSizeRequired);
    if ~OK
        return
    end
    Position_relative_buttom_group = [0;-4;1];
    [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step, 1];
Axis = [Axis, 2];
Moving_Log_Mid(4,1:3) = true;
Moving_Log_Top(4,1) = true;


% Step = [Step, 1,1,1,-1, -1, -1, 1];
% Axis = [Axis, 3,3,1, 2,  3,  1, 2];
% Moving_Log_Buttom(4,1) = true;
% Moving_Log_Buttom(5,1) = true;
% Moving_Log_Buttom(6,2:end) = true;
% 
% Moving_Log_Mid(7,1) = true;
% Moving_Log_Buttom(7,2) = true;
% 
% Moving_Log_Mid(8,1) = true;
% Moving_Log_Buttom(8,1) = true;
% 
% Moving_Log_Top(9,1) = true;
% 
% Moving_Log_Top(10,1) = true;
% Moving_Log_Mid(10,1) = true;
% Moving_Log_Buttom(10,1:2) = true;


end