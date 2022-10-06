function AllConfig2Update = CollectChildInfo2SetInParent(AllConfig2Update, FileData, ConfigNewLoc, DeleteChild)
if nargin==4 && ~isempty(DeleteChild)
    ChildInfo = [FileData.ConfigRow(ConfigNewLoc),FileData.ConfigCol(ConfigNewLoc),ConfigNewLoc; DeleteChild.ConfigRow, DeleteChild.ConfigCol,DeleteChild.Index];
    ParentConfigSize = [FileData.ParentRow(ConfigNewLoc),FileData.ParentCol(ConfigNewLoc);DeleteChild.ParentRow,DeleteChild.ConfigCol];
    ParentStr = [FileData.ParentStr(ConfigNewLoc);DeleteChild.ParentStr];
    AllConfig2Update = [AllConfig2Update; table(ParentStr,ParentConfigSize,ChildInfo)];
else
    ChildInfo = [FileData.ConfigRow(ConfigNewLoc),FileData.ConfigCol(ConfigNewLoc),ConfigNewLoc];
    ParentConfigSize = [FileData.ParentRow(ConfigNewLoc),FileData.ParentCol(ConfigNewLoc)];
    ParentStr = FileData.ParentStr(ConfigNewLoc);
    AllConfig2Update = [AllConfig2Update; table(ParentStr,ParentConfigSize,ChildInfo)];
end
% StrGroup = DivideStrByFile(ParentStr,ParentConfigSize,ChildInfo);
% cellfun(@(x) SetChildInfo(x,ds),StrGroup,'UniformOutput',false);

end

%"010010010010010010010010010010010010010010010010110010010010010011011010010010010010010010010010010",
%3 33
