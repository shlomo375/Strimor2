function SetChildInfoInParent(ds,InfoTable)

StrGroup = DivideStrByFile(InfoTable.ParentStr,InfoTable.ParentConfigSize,InfoTable.ChildInfo);
cellfun(@(x) SetChildInfo(x,ds),StrGroup,'UniformOutput',false);

end
