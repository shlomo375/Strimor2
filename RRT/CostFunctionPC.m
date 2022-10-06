function [Level, Cost] = CostFunctionPC(Movment, ParentCost, ParentLevel)

Cost = ParentCost + Movment.Agent.*abs(Movment.step);
Level = ParentLevel + 1;

end
