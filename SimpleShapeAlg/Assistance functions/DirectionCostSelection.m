function [NewStep, NewAxis,NewAllModuleInd, NewMoving_Log, NewDirection,ReducedModuleNum] = DirectionCostSelection(Step, Axis,AllModuleInd, Moving_Log, Direction)

for ii = 1:numel(Step)
    Cost(ii) = abs(Step{ii}(:)')*sum(Moving_Log{ii},2);
end

[~,LowestCost_Loc] = min(Cost);

NewStep = Step{LowestCost_Loc};
NewAxis = Axis{LowestCost_Loc};
NewAllModuleInd = AllModuleInd{LowestCost_Loc};
NewMoving_Log = Moving_Log{LowestCost_Loc};
NewDirection = Direction(LowestCost_Loc);

ReducedModuleNum = sum(NewMoving_Log(end,:));

end
