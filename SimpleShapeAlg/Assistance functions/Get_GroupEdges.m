function Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds,StartEdge)
arguments
    GroupsSizes
    GroupIndexes
    GroupsInds
    StartEdge (1,1) = 0;
end

% Alpha_Num = abs(ceil(GroupsSizes/2));
% Beta_Num = abs(GroupsSizes)-Alpha_Num;
EndMat = EndIsAlpha(GroupsSizes);
% EndIsAlphaMat(isnan(EndIsAlphaMat)) = 
EndMat(EndMat==0) = -1;
EndMat(isnan(EndMat)) = 0;
SignMat = sign(GroupsSizes);
if numel(GroupsSizes) > 4
    Edges = zeros(4,2,numel(GroupsSizes));
else
    Edges = zeros(4,2,4);
end

% EdgeCol = cell(numel(GroupsInds),1);
for Line = 1:size(GroupsSizes,1)
    if GroupsSizes(Line)
        Edges(:,:,Line+StartEdge) = [GroupsInds{Line}{1}(1),GroupsInds{Line}{1}(end);...
                                  GroupIndexes{Line}{1}(1),GroupIndexes{Line}{1}(end);...
                                  SignMat(Line,1), EndMat(Line,1);... 
                                  GroupsSizes(Line,1),0];
    end
end

end
