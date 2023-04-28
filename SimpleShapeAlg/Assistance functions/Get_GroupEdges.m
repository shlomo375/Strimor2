function Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds)

EndIsAlphaMat = EndIsAlpha(GroupsSizes);
% EndIsAlphaMat(isnan(EndIsAlphaMat)) = 
EndIsBetaMat = ~EndIsAlphaMat;
SignMat = sign(GroupsSizes);
Edges = zeros(3,2,4);
% EdgeCol = cell(numel(GroupsInds),1);
for Line = 1:size(GroupsSizes,1)
        Edges(:,:,Line) = [GroupsInds{Line}{1}(1),GroupsInds{Line}{1}(end);...
                                  GroupIndexes{Line}{1}(1),GroupIndexes{Line}{1}(end);...
                                  SignMat(Line,1), EndIsAlphaMat(Line,1)-EndIsBetaMat(Line,1)];
end

end
