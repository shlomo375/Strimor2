function NewTask = Alpha_Beta_Beta__1(WS, StartConfig, TargetConfig,ConfigShift, Downwards, Line,Direction)

% Alpha_Override = zeros(size(StartConfig));
% Beta_Override = zeros(size(StartConfig));
% Beta_Override(Line) = -1;

% NewTask = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line-1, AlphaDiff_Override=Alpha_Override,BetaDiff_Override=Beta_Override,WS=WS,ConfigShift=ConfigShift);
NewTask = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",Line-1,"Downwards",Downwards,"Type",-1,"DestenationLine_Beta",Line-2,"Side",Direction);
end
