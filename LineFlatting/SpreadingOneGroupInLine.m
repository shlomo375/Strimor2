function SpreadingOneGroupInLine(WS,Axis,Step,tree,ParentInd)
GroupInd = ModuleIndSortByRow(WS.Space.Status);

Lines = 2:numel(GroupInd);
NotFinishLine = true(1,length(Lines));

LineToCheck = @(Line) Line(randi(length(Line)));
while any(NotFinishLine)
    MoveLine = LineToCheck(Lines(NotFinishLine));

    MoveingModules = GroupInd{MoveLine};
    
    [OK, Configuration, Movement, NewWS] = MakeAMove(WS,Axis,Step,MoveingModules');
    
    if OK
        PlotWorkSpace(NewWS,[]);
        %% Update procedure
        [~, ParentCost, ParentLevel] = Get(tree,ParentInd,"Cost","Level");

        [Level, Cost] = CostFunction(Movement, ParentCost, ParentLevel,tree.N);

        CostToTarget = 1;

        [tree,~,ConfigInd] = UpdateTree(tree, ParentInd, Configuration, Movement, Level, Cost,CostToTarget);
        %%
        if ConfigInd ~= tree.LastIndex
            break
        end
        
        NotFinishLine = true(1,length(Lines));
        
        NewWS.Space.Status(NewWS.Space.Status==2) = 1;
        WS = NewWS;
    else
        NotFinishLine(MoveLine-1) = false;
    end
end

end
