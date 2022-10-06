function [Connect, trees] = CompareStrTrees(folders)
Connect = [];
trees = [];

RootFolder = extractBefore(folders(1),'N\');
RootFolder = RootFolder+"N";
LastCompareTime = struct2cell(load(fullfile(RootFolder,"LastCompareTime.mat")));
LastCompareTime = LastCompareTime{:};
fprintf("get files name...\n");
for k = size(folders,2):-1:1
    Ds{k} = fileDatastore(folders(k),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    TreeFile = contains(Ds{k}.Files,"size");
    ds{k} = subset(Ds{k},TreeFile);
    files{k} = ds{k}.Files;
    files{k} = extractBetween(files{k},"Tree\",".mat");
    FullNameFiles{k} = string(ds{k}.Files);

    files{k} = extractBetween(FullNameFiles{k},"Tree\",".mat");
    fprintf("get files name...\n");
end
%%
AllFiles = unique(cat(1,files{:}));
FullNameFiles = cat(1,FullNameFiles{:});
MatchInAllTree = @(File) FullNameFiles(contains(FullNameFiles,File));
FileExist = arrayfun(MatchInAllTree,AllFiles,'UniformOutput',false);

for ii = 1:numel(FileExist)
    for jj = 1:numel(FileExist{ii})
        Else = setdiff(1:numel(FileExist{ii}),jj);
        ds_File1 = fileDatastore(FileExist{ii}(jj),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
        ds_FileElse = fileDatastore(FileExist{ii}(Else),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
        
        File1 = read(ds_File1);
        NewConfigStr = datetime(File1{:,"time"}) > LastCompareTime;

        ElseFile = readall(ds_FileElse);
        CompFun = @(str) CompareStrs(str, [], ElseFile{:,"ConfigStr"}, [0 0]);
        output = arrayfun(CompFun,File1{NewConfigStr,"ConfigStr"});
        if any(output)
            Connect(ii,jj) = true;
            trees(ii,jj) = {FileExist{ii}(jj),FileExist{ii}(Else),output};
        end
    end
end
LastCompareTime = datetime;
save(fullfile(RootFolder,"LastCompareTime.mat"),"LastCompareTime");

end
