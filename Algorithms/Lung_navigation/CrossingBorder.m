function Point = CrossingBorder(Space,Point)
% % Agent = zeros(size(AgentInd,1),3)
% [AgentX,AgentY,AgentZ] = ind2sub(size(Space),AgentInd);
% Agent = [AgentX,AgentY,AgentZ];
DeletePoint = any(Point.Sub > size(Space)-1 | Point.Sub < 2,2);
Point.Sub(DeletePoint,:) = [];
Point.Ind(DeletePoint) = [];

end
