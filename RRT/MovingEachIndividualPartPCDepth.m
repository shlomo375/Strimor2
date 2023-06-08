function [tree,success] = MovingEachIndividualPartPCDepth(tree, WS, Agent, Parent)
% try
success = false;
for dir = 1:length(Agent)
    for Comb = 1:length(Agent{dir})
        OK = true;
        step = 0;
        while OK == 1
            step = step + 1;
            [OK, tree] = MoveAgentGroup(WS,dir,Comb,step,Agent,tree,Parent);
        end
        if OK == 2
            success = true;
            return
        end
        OK = true;
        step = 0;
        while OK == 1
            step = step - 1;
            [OK, tree] = MoveAgentGroup(WS,dir,Comb,step,Agent,tree,Parent);
        end
        if OK == 2
            success = true;
            return
        end
    end
end


end

