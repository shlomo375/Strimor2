function [WS,Node,Config] = CreateRectungularShape(BasicWS,N,High)

if isempty(BasicWS)
    BasicWS = WorkSpace([N,N*2],"RRT*");
end

Width = ceil(N/High);
GroupsSizes = zeros(High,1);
GroupsSizes(1:end-1) = Width;
GroupsSizes(end) = N-sum(GroupsSizes);

GroupsSizes(1) = -GroupsSizes(1);
for row = 2:numel(GroupsSizes)
    GroupsSizes(row) = -sign(GroupsSizes(row-1))*GroupsSizes(row);
end


Config.Status = ones(numel(GroupsSizes),max(abs(GroupsSizes)));
Config.Status(end,GroupsSizes(end)+1:end) = 0; 
Config.Type = 1;

WS = SetConfigurationOnSpace(BasicWS,Config);
WS = FixEqualeTypeNumberModule(WS,'same');

Config = GetConfiguration(WS);
Node = CreateNode(1);
Node = ConfigStruct2Node(Node,Config);


end
