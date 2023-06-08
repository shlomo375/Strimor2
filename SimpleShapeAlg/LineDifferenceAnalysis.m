function [ActionFuncHandle,ActionName] = LineDifferenceAnalysis(StartLine,TargetLine)

if abs(StartLine) > abs(TargetLine)
    ActionFuncHandle = @RemoveModules;
    ActionName = "Remove modules";
elseif abs(StartLine) == abs(TargetLine)
    if sign(StartLine) ~= sign(TargetLine)
        ActionFuncHandle = @SwitchEdges;
        ActionName = "Switch edges";
    else
        ActionFuncHandle = [];
        ActionName = "Line are the same";
    end
else % StartLine < TargetLine
    ActionFuncHandle = @AddingModules;
    ActionName = "Adding modules";
end
end
