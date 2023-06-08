function Line = ActiveLine(Task)

OptionalLine = Task{1,["Current_Line_Alpha","Current_Line_Beta"]};
if any(OptionalLine)
    Finish = Task{1,["Finish_Alpha","Finish_Beta"]};
    Line = max(OptionalLine(~Finish));
else
    Line = Task.Current_Line;
end
if all(~Task{1,["Current_Line_Alpha","Current_Line_Beta","Current_Line"]})
    d=5
end


end
