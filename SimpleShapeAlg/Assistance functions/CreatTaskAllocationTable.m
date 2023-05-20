function Task = CreatTaskAllocationTable(Task,Name,Value)
arguments
    Task
end
arguments (Repeating)
    Name (1,1) {mustBeTextScalar,matches(Name,["Current_Line","Module_Num","Side","Downwards","DestenationLine","Type","ActionType","Finish_Alpha","Finish_Beta","Total_Downwards"])}
    Value (1,:)
end
    
if isempty(Task)
    Task = table("",0,0,0,0,"",false,false,false,false,false,0,0,0,0,'VariableNames',["ActionType","Current_Line","Current_Line_Alpha","Current_Line_Beta","Module_Num","Side","Downwards","Finish","Finish_Alpha","Finish_Beta","Sequence","DestenationLine","DestenationLine_Alpha","DestenationLine_Beta","Type"]);
end
for ii = 1:numel(Name)
    Task{1,Name{ii}} = Value{ii};
end

if Task.Current_Line_Alpha == Task.Current_Line_Beta && Task.Current_Line_Alpha
    Task.Current_Line = Task.Current_Line_Alpha;
end
if Task.DestenationLine_Alpha == Task.DestenationLine_Beta && Task.DestenationLine_Alpha
    Task.DestenationLine = Task.DestenationLine_Alpha;
end

Task.Module_Num = sum([Task.Current_Line_Alpha~=Task.DestenationLine_Alpha,Task.Current_Line_Beta~=Task.DestenationLine_Beta]);

Task.Current_Line = ActiveLine(Task);



end