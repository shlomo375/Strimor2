function NewChild = AddOrDeleteChild(OldChild,NewChild)
if ~isempty(OldChild)
    [Exist,Loc] = ismember(OldChild,NewChild,'rows');
    
    if any(Exist)
        NewChild(Loc(Exist),:) = [];
        OldChild(Loc>0,:) = [];
    end
    NewChild = [OldChild; NewChild];
end
end
