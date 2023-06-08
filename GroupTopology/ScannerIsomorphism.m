function [OK, Path, ConfigLevel] = ScannerIsomorphism(Ds,Config,mode)

OK = 1;
%% Find config in tree



StartFile = fullfile(extractBefore(Ds.Files(1),"\size"),"Start.mat");
load(StartFile,"StartConfig");
fileName = join(["size",Config.ConfigRow,Config.ConfigCol],"_");
ds = subset(Ds,contains(Ds.Files,fileName));

for ii = 1:numel(ds.Files)
    FileData = read(ds);
    ConfigLoc = ismember(FileData(:,["ConfigStr","ConfigRow","ConfigCol","Type"]),Config(:,["ConfigStr","ConfigRow","ConfigCol","Type"]));
    if any(ConfigLoc)
        Config = FileData(ConfigLoc,:);
        break
    end
end
%%
ConfigLevel = Config.Level;
Path = Config;
Parent = [];
try
while ~isequal(Config,StartConfig)
 
    ParentStr = Config{:,"ParentStr"};
    ParentSize = Config{:,["ParentRow","ParentCol"]};
    if ParentSize(1)==0
        break
    end
    temp = table(ParentStr,ParentSize(1),ParentSize(2),'VariableNames',["ConfigStr","ConfigRow","ConfigCol"]);
    
    fileName = join(["size",ParentSize(1),ParentSize(2)],"_");
    ds = subset(Ds,contains(Ds.Files,fileName));
    
    for ii = 1:numel(ds.Files)
        FileData = read(ds);

        [~,UniqueLoc] = unique(FileData(:,["ConfigRow","ConfigCol","ConfigStr","Type"]));
        FileData = FileData(UniqueLoc,:);

        ParentLoc = ismember(FileData(:,["ConfigStr","ConfigRow","ConfigCol"]),temp);
        if any(ParentLoc)
            Parent = FileData(ParentLoc,:);
            
            FileLoc = ii;
            break
        end
    end
    try
    switch mode
        case "flip"   
            %%
            NewParent = FlipMovmentAndConfig(Config,Parent);
            FileData(ParentLoc,:) = NewParent;
    
            FileAddress = ds.Files{FileLoc};
            save(FileAddress,"FileData");
    
        case "Path"
            Loc = ~ismember(Parent(:,["ConfigStr","ParentStr"]),Path(:,["ConfigStr","ParentStr"]));
            
            if any(Loc)
                Parent = Parent(find(Loc,1),:);
                Path(end+1,:) = Parent;
            else
                OK = 0;
                break
            end
        case "FlipAndPath"
            Loc = ~ismember(Parent(:,["ConfigStr","ParentStr"]),Path(:,["ConfigStr","ParentStr"]));
            Parent = Parent(find(Loc,1),:);
            NewParent = FlipMovmentAndConfig(Config,Parent);
            FileData(ParentLoc,:) = NewParent;
            FileAddress = ds.Files{FileLoc};
%             save(FileAddress,"FileData");
            
            Path(end+1,:) = NewParent;
    end
    catch ME3
        fprintf("corupt");
        OK = 1;
        
        break
    end
    Config = Parent;
end
catch ME4
    ME4
end

switch mode
    case "FlipAndPath"
        Path = flip(Path,1);
    otherwise
end

end
