function Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds)

EndMat = EndIsAlpha(GroupsSizes);
% EndIsAlphaMat(isnan(EndIsAlphaMat)) = 
EndMat(EndMat==0) = -1;
EndMat(isnan(EndMat)) = 0;
SignMat = sign(GroupsSizes);
if numel(GroupsSizes) > 4
    Edges = zeros(3,2,numel(GroupsSizes));
else
    Edges = zeros(3,2,4);
end
% EdgeCol = cell(numel(GroupsInds),1);
for Line = 1:size(GroupsSizes,1)
    if GroupsSizes(Line)
        Edges(:,:,Line) = [GroupsInds{Line}{1}(1),GroupsInds{Line}{1}(end);...
                                  GroupIndexes{Line}{1}(1),GroupIndexes{Line}{1}(end);...
                                  SignMat(Line,1), EndMat(Line,1)];
    end
end

end
