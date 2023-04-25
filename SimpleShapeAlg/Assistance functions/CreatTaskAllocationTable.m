function ModuleTransitionData = CreatTaskAllocationTable(ModuleTransitionData,Name,Value)
arguments
    ModuleTransitionData
end
arguments (Repeating)
    Name (1,1) {mustBeTextScalar,matches(Name,["Current_Line","Module_Num","Side","Downwards","DestenationLine","Type"])}
    Value (1,1)
end
    
if isempty(ModuleTransitionData)
    ModuleTransitionData = table(0,0,"",false,false,false,0,0,'VariableNames',["Current_Line","Module_Num","Side","Downwards","Finish","Sequence","DestenationLine","Type"]);
end
for ii = 1:numel(Name)

    ModuleTransitionData{1,Name{ii}} = Value{ii};

end


end