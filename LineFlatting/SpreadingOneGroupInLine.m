function [tree, WS, GroupInd] = SpreadingOneGroupInLine(WS,tree,GroupInd,Axis,Step,ParentInd)
% GroupInd = ModuleIndSortByRow(WS.Space.Status);

Lines = 2:numel(GroupInd);
NotFinishLine = true(1,length(Lines));

LineToCheck = @(Line) Line(randi(length(Line)));
while any(NotFinishLine)
    MoveLine = LineToCheck(Lines(NotFinishLine));

    MoveingModules = GroupInd{MoveLine};
    
    [OK, Configuration, Movement, NewWS] = MakeAMove(WS,Axis,Step,MoveingModules');
    
    if OK
%         figure(2)
%         PlotWorkSpace(NewWS,[]);
        %% Update procedure
        GroupInd{MoveLine} = UpdateLinearIndex(WS.SpaceSize,GroupInd{MoveLine},1,Step);

        [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
        if Exists
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
