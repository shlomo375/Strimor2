function NewTask = Alpha_Alpha_Alpha__1(WS, StartConfig, TargetConfig,ConfigShift, Downwards, Line)

% StartConfig, TargetConfig, Downwards, Line
% ModuleType = -1;
Destenation_Line = Line - 2;
Beta_Override = zeros(size(StartConfig));
Beta_Override(Destenation_Line) = 1;
% NewTask = TransferModuleToLine(WS, ConfigShift,ModuleType,DestenationLine,~Downwards);

% ModuleTransitionData = Module_Task_Allocation(StartConfig, TargetConfig, ~Downwards, DestenationLine=Destenation_Line,Required_Module_Type=ModuleType)

NewTask = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Destenation_Line, BetaDiff_Override=Beta_Override,WS=WS,ConfigShift=ConfigShift);
end