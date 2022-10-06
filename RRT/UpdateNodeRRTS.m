function [Tree, Update] = UpdateNodeRRTS(Tree, Nodes)
Update = true;
% [Level, Cost] = CostFunction(Movment, Tree(Parent));
% Loc = FindConfigInTree(Tree, Nodes.Dec);
[UpdateLocInNodes, UpdateLocInTree]  = ismember(Nodes.Dec,Tree.Dec);
UpdateCost = Nodes.Cost(UpdateLocInNodes) < Tree.Cost(UpdateLocInTree);
UpdateLevel = Nodes.Cost(UpdateLocInNodes) == Tree.Cost(UpdateLocInTree)&...
             Nodes.Level(UpdateLocInNodes) < Tree.Level(UpdateLocInTree);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for NodesIndex = Loc
    if NodesIndex
        if UpdateNodes.Cost(NodesIndex) < Tree.Cost(NodesIndex)
            UpdateNodes.Index(NodesIndex) = Tree.Index(NodesIndex);
            Tree = InsertNode(Tree, TreeIndex, Nodes, NodesIndex);
        end
        if UpdateNodes.Cost(NodesIndex) == Tree.Cost(NodesIndex)
            if UpdateNodes.Level(NodesIndex) < Tree.Level(NodesIndex)
                UpdateNodes.Index(NodesIndex) = Tree.Index(NodesIndex);
                Tree = InsertNode(Tree, TreeIndex, Nodes, NodesIndex);
            end
        end

    else
        Tree = InsertNode(Tree, TreeIndex, Nodes, NodesIndex);
    end
end
%     if UpdateNodes.Cost(NodesIndex) < Tree.Cost(NodesIndex)
%         UpdateNodes.Index = Tree.Index;
%         Tree(Loc) = Nodes;
%     end
%     if Cost == OldNode.Cost
%         if Nodes.Level < OldNode.Level
%             Nodes.Index = OldNode.Index;
%             Tree(Loc) = Nodes;
%         end
%     end
% 
% end
% 
% if ~isempty(OldNode)
%     if Nodes.Cost < OldNode.Cost
%         Nodes.Index = OldNode.Index;
%         Tree(Loc) = Nodes;
%     end
%     if Cost == OldNode.Cost
%         if Nodes.Level < OldNode.Level
%             Nodes.Index = OldNode.Index;
%             Tree(Loc) = Nodes;
%         end
%     end
% else
%     Update = false;
% end


end
