function [Exists,tree, ConfigInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd)
        Exists = false;
        [~, ParentCost, ParentLevel] = Get(tree,ParentInd,"Cost","Level");

        [Level, Cost] = CostFunction(Movement, ParentCost, ParentLevel,tree.N);

        CostToTarget = 1;

        [tree,~,ConfigInd] = UpdateTree(tree, ParentInd, Configuration, Movement, Level, Cost,CostToTarget);
        %%
        if ConfigInd ~= tree.LastIndex
            Exists = true;
        end
end
