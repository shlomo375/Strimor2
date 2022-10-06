function SetChildInfo(Group,ds)

if Group{1}(1) == 0
    ParentLoc = 0;
    return
end

FileName = "size_"+string(Group{1}(1,1))+"_"+ string(Group{1}(1,2)+".mat");
FileExist = contains(ds.Files,FileName);
File = partition(ds,'Files',ds.Files{FileExist});
FileData = read(File);

[Str4Serch,~,ci] = unique(Group{2});
Compare = @(str) CompareStrs(str, Group{1}(1,:), FileData.ConfigStr, Group{1}(1,:));
StrIndexInFile = arrayfun(Compare,Str4Serch);
AddOrDelete = @(IndexInFile) {AddOrDeleteChild(FileData.Childs{IndexInFile},Group{3}(StrIndexInFile(ci)==IndexInFile,:))};

try
FileData.Childs(StrIndexInFile) = arrayfun(@(x)AddOrDelete(x),StrIndexInFile);
catch
    d=7
end
save(ds.Files{FileExist},"FileData");

end
