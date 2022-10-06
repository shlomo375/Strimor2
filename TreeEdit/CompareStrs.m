function ListLoc = CompareStrs(Str, StrSizes, StrList, StrListSizes)
if size(StrListSizes,1)==1
    [~,ListLoc] = ismember(Str,StrList);
else
    LogicalLoc = (StrListSizes(:,1) == StrSizes(1,1) & StrListSizes(:,2) == StrSizes(1,2));
    [~,StrLoc] = ismember(StrList(LogicalLoc),Str);
    temp = find(LogicalLoc);
    ListLoc = temp(logical(StrLoc));
end


end
