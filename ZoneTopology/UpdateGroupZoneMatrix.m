function GroupZoneMatrix = UpdateGroupZoneMatrix(Overlap_Row, Overlap_Col,Gap_Indexes,GroupIndexes, AboveOrBelow, GroupZoneMatrix)
if strcmp(AboveOrBelow,"Below")
    RowUpOrDown = -1;
    ComplexNumber = 1;
    Overlap_Row(Overlap_Row==1) = [];
else
    RowUpOrDown = 1;
    ComplexNumber = 1i;
    Overlap_Row(Overlap_Row==numel(GroupIndexes)) = [];
end

for idx = 1:numel(Overlap_Row)
    OverlapIndexes = GroupIndexes{Overlap_Row(idx)}{Overlap_Col(idx)}';
    
    Gap = Gap_Indexes(Overlap_Row(idx)+RowUpOrDown,:);
    Gaps = Gap(Gap>0);
    if isempty(Gaps)
        continue
    end
    
    %The gap index is of the left group, right edge, so if the overlap is
    % less than or equal to the gap index, it means that it has reached the
    % area to the left of the gap (first gap with minus sign)
    ZeroAtRow = find(any(~sign(OverlapIndexes - Gaps'),2),1);
    OverlapZone = ceil(ZeroAtRow/2)*3-(mod(ZeroAtRow,2)*2);

    if isempty(OverlapZone)
        Switch = find(any(sign(OverlapIndexes - Gaps')<0,2),1);
        OverlapZone = ceil(Switch/2)*3-1;

        if isempty(OverlapZone)
            OverlapZone = numel(Gaps)/2*3;
        end
    end

    
    GroupZoneMatrix(Overlap_Row(idx),Overlap_Col(idx)) = GroupZoneMatrix(Overlap_Row(idx),Overlap_Col(idx)) + OverlapZone * ComplexNumber;
end


end
