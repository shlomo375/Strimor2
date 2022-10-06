function [AgentMap, PositionMap] = CreatMap(size)
PositionMap = [0,1;1,0];
PositionMap = repmat(PositionMap,size(1)/2,size(2)/2);
AgentMap = zeros(size);

end
