function Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds)

EndIsAlphaMat = EndIsAlpha(GroupsSizes);
EndIsBetaMat = ~EndIsAlphaMat;
SignMat = sign(GroupsSizes);
Edges = cell(numel(GroupsInds),1);
% EdgeCol = cell(numel(GroupsInds),1);
for Line = 1:size(GroupsSizes,1)
    for GroupNum = 1:numel(GroupsInds{Line})
        Edges{Line,GroupNum} = {[GroupsInds{Line}{GroupNum}(1),GroupsInds{Line}{GroupNum}(end);...
                                  GroupIndexes{Line}{GroupNum}(1),GroupIndexes{Line}{GroupNum}(end);...
                                  SignMat(Line,GroupNum), EndIsAlphaMat(Line,GroupNum)-EndIsBetaMat(Line,GroupNum)]};
    end
end

end
