function [TreeArray, LastNodeIndex] = MoveSeriesOfAgentCombinations(WS,Comb,dir, LastNodeIndex, Parent, TreeArray, FileName, ArrayLength)
    AgentList = unique([Comb{:}]);
    AgentList = [AgentList(:),size(AgentList,2)*ones(size(AgentList,2),1)];
    
    while ~isempty(Comb)
        if isempty(Comb{1})
            Comb(1) = [];
            continue;
        end
%         try
        MaxStep = min(AgentList(ismember(AgentList(:,1),Comb{1}),2));
%         catch
%             d=5;
%         end
        for step = 1:MaxStep
%             t = tic;
            [OK, Configuration, Movment, CollidingAgent] = MakeAMove(WS,dir,step,Comb{1});
%             fprintf('%s\n',toc(t)+" move   ");
            if (~OK)
                break
            else
                node = CreatRRT_Node(LastNodeIndex, Parent, Configuration, Movment);
%                 TreeArray = SaveNode(node, TreeArray, FileName, ArrayLength);
                [TreeArray, LastNodeIndex] = SaveNode(node, TreeArray, FileName, ArrayLength, LastNodeIndex);
            end
        end
        Comb(1) = [];
    end
end
