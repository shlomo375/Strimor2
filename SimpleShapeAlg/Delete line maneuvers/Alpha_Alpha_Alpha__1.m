function ModuleTransitionData = Alpha_Alpha_Alpha__1(WS, ConfigShift,DestenationLine,Downwards)


ModuleType = -1;
DestenationLine = DestenationLine - 2;
ModuleTransitionData = TransferModuleToLine(WS, ConfigShift,ModuleType,DestenationLine,~Downwards);


end