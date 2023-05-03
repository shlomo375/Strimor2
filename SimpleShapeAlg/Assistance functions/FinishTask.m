function Task = FinishTask(Task)

if Task.Current_Line_Alpha == Task.DestenationLine_Alpha ||...
        Task.Current_Line_Alpha == Task.DestenationLine
    Task.Finish_Alpha = true;
end

if Task.Current_Line_Beta == Task.DestenationLine_Beta ||...
        Task.Current_Line_Beta == Task.DestenationLine
    Task.Finish_Beta = true;
end


if Task.Finish_Alpha && Task.Finish_Beta
    Task.Finish = true;
end
end