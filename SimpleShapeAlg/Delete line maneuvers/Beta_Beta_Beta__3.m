function ModuleTransitionData = Beta_Beta_Beta__3(GroupsSizes,GroupIndexes,GroupsInds,DestenationLine,Downwards)

ModuleType = 1; % 
DestenationLine = DestenationLine - 2;
ModuleTransitionData = TransferModuleToLine(GroupsSizes,GroupIndexes,GroupsInds,ModuleType,DestenationLine,~Downwards);

end
