function FreeSpaceInd = FreeSpace(WS,OldInd,Axis,Step)
R = {WS.R1, WS.R2, WS.R3};

if Step>0
    FreeSpaceRange = -1:Step*2 + 1;
else
    FreeSpaceRange = -1*(-1:Step*2 + 1);
end

[LogicalPosition,~] = ismember(R{Axis},OldInd);
[Row,Col] = find(LogicalPosition,numel(OldInd));

FreeSpaceInd = R{Axis}(sub2ind(size(R{Axis}),repmat(Row,[1,length(FreeSpaceRange)]),Col+FreeSpaceRange));
FreeSpaceInd = unique(FreeSpaceInd);

end
