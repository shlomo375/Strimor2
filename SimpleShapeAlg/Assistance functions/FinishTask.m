function ModuleTransitionData = FinishTask(ModuleTransitionData)

if ModuleTransitionData.Current_Line_Alpha
    if ModuleTransitionData.Current_Line_Alpha ~= ModuleTransitionData.DestenationLine_Alpha &&...
            ModuleTransitionData.Current_Line_Alpha ~= ModuleTransitionData.DestenationLine
        return
    end

end

if ModuleTransitionData.Current_Line_Beta
    if ModuleTransitionData.Current_Line_Beta ~= ModuleTransitionData.DestenationLine_Beta &&...
            ModuleTransitionData.Current_Line_Beta ~= ModuleTransitionData.DestenationLine
        return
    end

end
   
ModuleTransitionData.Finish = true;
end
