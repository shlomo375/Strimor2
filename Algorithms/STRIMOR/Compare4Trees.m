%% Compare Trees
clear
Connect = [];
trees = [];
Config = [];
addpath(genpath('C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles'));

Trees(1) = "RRTtree\36N\CarTree";
Trees(2) = "RRTtree\36N\LineTree";
Trees(3) = "RRTtree\36N\RotatedLineTree";
Trees(4) = "RRTtree\36N\ShapeTree";



fprintf("get files name...\n");
for ii = numel(Trees):-1:1
    Ds{ii} = fileDatastore(Trees{ii},"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    TreeFile = contains(Ds{ii}.Files,"size");
    ds{ii} = subset(Ds{ii},TreeFile);
    files{ii} = ds{ii}.Files;
    files{ii} = extractBetween(files{ii},"Tree\",".mat");
    s = split(files{ii},"_");
    files{ii} = join(s(:,1:3),"_");
    FullNameFiles{ii} = string(ds{ii}.Files);

    fprintf("get files name...\n");
end
%%
AllFiles = unique(cat(1,files{:}));
FullNameFiles = cat(1,FullNameFiles{:});
MatchInAllTree = @(File) FullNameFiles(contains(FullNameFiles,File));
FileExist = arrayfun(MatchInAllTree,AllFiles,'UniformOutput',false);

for ii = 307:-1:1%numel(FileExist):-1:1
    if numel(FileExist{ii})<2
        continue
    end
    tic
    DataStore = @(filesLoc) fileDatastore(filesLoc,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    Match2Tree = @(File) DataStore(FileExist{ii}(contains(FileExist{ii},File)));
    DsFile = arrayfun(Match2Tree,Trees,'UniformOutput',false);
    
    data = cell(1,4);
    for kk = 1:numel(DsFile)
        fprintf("load file: "+string(ii)+" name: "+AllFiles(ii)+" tree: "+string(kk)+"\n");
        data{kk} = readall(DsFile{kk});
    end
    for jj = 1:numel(data)-1
        

        fprintf("tree num "+string(jj)+" vs left\n")
        Else = setdiff(1:numel(DsFile),jj);

%         fprintf("load file: "+AllFiles(ii)+" from tree: "+string(jj)+"\n")
        
        
        File1 = data{jj};
        try
        ElseFile = [];
        for qq = (jj+1):numel(data)
            if(~isempty(data{qq}))
                ElseFile = [ElseFile;data{qq}];
            end
        end
        catch e
            e
        end
        if size(File1,1)==0 || size(ElseFile,1)==0
            continue
        end
       
        if size(data{jj},1)>size(ElseFile,1)
            temp = ElseFile;
            ElseFile = File1;
            File1 = temp;
        end
        
            
        fprintf("\n file size: "+size(File1,1)+" / "+size(ElseFile,1)+"\n");
        try
        output = ismember(File1.ConfigStr,ElseFile.ConfigStr);
        catch e
            e
        end
        
        if any(output)
            fprintf("\nconnnnnnnect\n");
%             pause
            Config = [Config;{File1(output,:),extractBetween(DsFile{jj}.Files(1),"N\","\size")}];
            save("RRTtree\36N\ConnectConfig.mat","Connect","Config");
        else
            fprintf(" trees not connect\n\n\n");
        end
    end
    toc
end

