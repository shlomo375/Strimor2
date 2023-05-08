function [NewStep, NewAxis,NewAllModuleInd, NewMoving_Log, NewDirection,NewDecision,ReducedModuleNum,Tasks] = DirectionCostSelection(Step, Axis,AllModuleInd, Moving_Log, Direction,Decision,Tasks)
if size(Tasks{1},1) && ~size(Tasks{2},1)
    LowestCost_Loc = 2;
elseif ~size(Tasks{1},1) && size(Tasks{2},1)
    LowestCost_Loc = 1;
else
    for ii = 1:numel(Step)
        Cost(ii) = abs(Step{ii}(:)')*sum(Moving_Log{ii},2);
    end
    
    [~,LowestCost_Loc] = min(Cost);
end

NewStep = Step{LowestCost_Loc};
NewAxis = Axis{LowestCost_Loc};
NewAllModuleInd = AllModuleInd{LowestCost_Loc};
NewMoving_Log = Moving_Log{LowestCost_Loc};
NewDirection = Direction(LowestCost_Loc);
NewDecision = func2str(Decision{LowestCost_Loc});

ReducedModuleNum = sum(NewMoving_Log(end,:));
Tasks = Tasks{LowestCost_Loc};
end
