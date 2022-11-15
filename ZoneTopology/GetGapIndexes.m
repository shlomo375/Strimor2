function GapIndexes = GetGapIndexes(Gap_Col, Gap_Row, GroupIndexes, Previous_Gap_Indexes)

GapIndexes = zeros(numel(GroupIndexes),2*max(Gap_Col));

for idx = 1:numel(Gap_Row)
    GapIndexes(Gap_Row(idx),(2*Gap_Col(idx)-1):(2*Gap_Col(idx))) = [GroupIndexes{Gap_Row(idx)}{Gap_Col(idx)}(end),GroupIndexes{Gap_Row(idx)}{Gap_Col(idx)+1}(1)];
end
GapIndexes = [GapIndexes, Previous_Gap_Indexes];

GapIndexes(~GapIndexes) = max(GapIndexes,[],'all')+1;
GapIndexes = sort(GapIndexes,2);
GapIndexes(GapIndexes==max(GapIndexes,[],'all')) = 0;

end
