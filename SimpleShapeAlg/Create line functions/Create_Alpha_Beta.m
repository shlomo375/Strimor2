% function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Create_Beta_Alpha(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx,varargin)
function Task = Create_Alpha_Beta(WS, StartConfig, TargetConfig,ConfigShift, Downwards, Line)

Step = [];
Axis = [];

Destenation_Line = Line - 2;
AlphaDiff = zeros(size(StartConfig));
BetaDiff = zeros(size(StartConfig));
AlphaDiff(Destenation_Line) = 1;

Task = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Destenation_Line, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
Task.Downwards = ~Task.Downwards;
return
% if ~isempty(Edges)
%     NotTested("Not Tested: Create_Beta_Alpha - spacial atention")
% 
%     GroupSizeRequired = [4,3];
%     [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edges,GroupSizeRequired);
%     if ~OK
%         return
%     end
% 
%     Position_relative_buttom_group = [1;2];
%     [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
% 
%     Moving_Log_Buttom(1:2,:) = true;
%     Moving_Log_Top(2,:) = true;
% end
% 
% Step = [Step, 1];
% Axis = [Axis, 3];
% 
% Moving_Log_Buttom(3,1:2) = true;
% Moving_Log_Top(3,1:2) = true;



end