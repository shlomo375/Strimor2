function [tree, flag] = MovingEachIndividualPart(WS, Agent, Parent, tree)
% Success = false;
flag = [];

for dir = 1:length(Agent)
%     try
% Resu = cell(length(Agent{dir}),1);
    for Comb = 1:length(Agent{dir})
        
        OK = true;
        step = 0;
        while OK
            step = step + 1;
            [OK, Configuration, Movment] = MakeAMove(WS,dir,step,Agent{dir}{Comb}');
%             Resulte{Comb} = {OK, Configuration, Movment};
            if OK
                
                if WS.Algoritem == "RRT*"
                    
                    [~, ParentCost, ParentLevel] = Get(tree,Parent,"Cost","Level");
                    [Level, Cost] = CostFunction(Movment, ParentCost, ParentLevel);
                    
                    [tree, flag] = UpdateTree(tree, Parent, Configuration, Movment, Level, Cost);
                end
                
                if ~isempty(flag)
                    return
                end
            end
        end
        
        OK = true;
        step = 0;
        while OK
            step = step - 1;
            [OK, Configuration, Movment] = MakeAMove(WS,dir,step,Agent{dir}{Comb}');
            if OK
                
                if WS.Algoritem == "RRT*"
                    
                    [~, ParentCost, ParentLevel] = Get(tree,Parent,"Cost","Level");
                    [Level, Cost] = CostFunction(Movment, ParentCost, ParentLevel);
                    
                    [tree, flag] = UpdateTree(tree, Parent, Configuration, Movment, Level, Cost);
                end
                
                if ~isempty(flag)
                    return
                end
                
            end
        end
    
    end
end

end
