function [Level, Cost] = CostFunction(Movment, ParentCost, ParentLevel,N)
NumOfAgent = numel(Movment.Agent);
if Movment.Agent > N
    NumOfAgent = N- numel(Movment.Agent);
end
Cost = ParentCost + NumOfAgent.*abs(Movment.step);
Level = ParentLevel + 1;

end
