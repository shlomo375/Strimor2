function ModuleTransitionData = CreatTaskAllocationTable(ModuleTransitionData,Name,Value)
arguments
    ModuleTransitionData
end
arguments (Repeating)
    Name (1,1) {mustBeTextScalar,matches(Name,["Current_Line","Module_Num","Side","Downwards","DestenationLine","Type","ActionType","Finish_Alpha","Finish_Beta"])}
    Value (1,:)
end
    
if isempty(ModuleTransitionData)
    ModuleTransitionData = table("",0,0,0,0,"",false,false,false,false,false,0,0,0,0,'VariableNames',["ActionType","Current_Line","Current_Line_Alpha","Current_Line_Beta","Module_Num","Side","Downwards","Finish","Finish_Alpha","Finish_Beta","Sequence","DestenationLine","DestenationLine_Alpha","DestenationLine_Beta","Type"]);
end
for ii = 1:numel(Name)
    ModuleTransitionData{1,Name{ii}} = Value{ii};
end

if ModuleTransitionData.Current_Line_Alpha == ModuleTransitionData.Current_Line_Beta && ModuleTransitionData.Current_Line_Alpha
    ModuleTransitionData.Current_Line = ModuleTransitionData.Current_Line_Alpha;
end
if ModuleTransitionData.DestenationLine_Alpha == ModuleTransitionData.DestenationLine_Beta && ModuleTransitionData.DestenationLine_Alpha
    ModuleTransitionData.DestenationLine = ModuleTransitionData.DestenationLine_Alpha;
end

end