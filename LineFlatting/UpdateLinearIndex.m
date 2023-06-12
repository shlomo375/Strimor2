function NewInd = UpdateLinearIndex(MatrixSize,OldInd,MovementAxis,Step)

switch MovementAxis
    case 1
        NewInd = OldInd + 2*Step*MatrixSize(1);
    case 2
        NewInd = OldInd + Step*(MatrixSize(1)-1);
    case 3
        NewInd = OldInd + Step*(MatrixSize(1)+1);
end

end
