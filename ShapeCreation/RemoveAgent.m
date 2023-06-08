function [WS] = RemoveAgent(WS,type,n)
inds = find((WS.Space.Type ==type & logical(WS.Space.Status)));

Agent = inds(randi(numel(inds),n,1));

% numel(find(WS.Space.Status))
WS.Space.Status(Agent) = 0;
% numel(find(WS.Space.Status))

end

