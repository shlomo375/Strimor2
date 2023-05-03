function ModuleTransitionData = Beta_Beta_Beta__3(GroupsSizes,GroupIndexes,GroupsInds,DestenationLine,Downwards)

Destenation_Line = Line - 2;
Alpha_Override = zeros(size(StartConfig));
Alpha_Override(Destenation_Line) = 1;

NewTask = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Destenation_Line, BetaDiff_Override=Beta_Override,WS=WS,ConfigShift=ConfigShift);


ModuleType = 1; % 
DestenationLine = DestenationLine - 2;
ModuleTransitionData = TransferModuleToLine(GroupsSizes,GroupIndexes,GroupsInds,ModuleType,DestenationLine,~Downwards);

end
