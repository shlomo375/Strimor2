function [GroupInd, GroupIndexes] = ModuleIndSortByRow(ConfigMat,R)

[row,col] = find(ConfigMat);
GroupIndexes = accumarray(row,col,[],@(x) {x});
for Line_idx = 1:numel(GroupIndexes)
    if ~isempty(GroupIndexes{Line_idx})
        StartLine = Line_idx;
        GroupIndexes(1:StartLine-1) = [];
        break
    end

end

for Line = numel(GroupIndexes):-1:1%StartLine+numel(GroupIndexes)-1:-1:StartLine
    if nargin == 2
        GroupInd{Line} = R(sub2ind(size(ConfigMat),repmat(Line+StartLine-1,[numel(GroupIndexes{Line}),1]),GroupIndexes{Line}));
    else
        GroupInd{Line} = sub2ind(size(ConfigMat),repmat(Line+StartLine-1,[numel(GroupIndexes{Line}),1]),GroupIndexes{Line});
    end
end


end
