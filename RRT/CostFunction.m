function [Level, Cost] = CostFunction(Movment, ParentCost, ParentLevel)

Cost = ParentCost + length(Movment.Agent).*abs(Movment.step);
Level = ParentLevel + 1;

end
