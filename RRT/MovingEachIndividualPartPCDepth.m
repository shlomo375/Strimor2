function [tree,success] = MovingEachIndividualPartPCDepth(tree, WS, Agent, Parent)
% try
success = false;
for dir = 1:length(Agent)
    for Comb = 1:size(Agent{dir},2)
        AgentGroup = Agent{dir}(Agent{dir}(:,Comb)>0,Comb);
        OK = true;
        step = 0;
        while OK == 1
            step = step + 1;
            [OK, tree] = MoveAgentGroup(WS,dir,step,AgentGroup,tree,Parent);
        end
        if OK == 2
            success = true;
            return
        end
        OK = true;
        step = 0;
        while OK == 1
            step = step - 1;
            [OK, tree] = MoveAgentGroup(WS,dir,step,AgentGroup,tree,Parent);
        end
        if OK == 2
            success = true;
            return
        end
    end
end


end

