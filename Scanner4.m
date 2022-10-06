function [NumConfigScanned, Path,OK] = Scanner(Ds,Config,mode)
OK = true;
%% Find config in tree

fileName = join(["size",Config.ConfigRow,Config.ConfigCol],"_");
ds = subset(Ds,contains(Ds.Files,fileName));

for ii = 1:numel(ds.Files)
    FileData = read(ds);
    ConfigLoc = ismember(FileData(:,["ConfigStr","ConfigRow","ConfigCol"]),Config(:,["ConfigStr","ConfigRow","ConfigCol"]));
    if any(ConfigLoc)
        Config = FileData(ConfigLoc,:);
        break
    end
end
%%

NumConfigScanned = 0;
Path = Config;
Parent = [];

while abs(Config.Index) ~= 1
    NumConfigScanned = NumConfigScanned + 1;
    size(Path,1)
    ParentStr = Config{:,"ParentStr"};
    ParentSize = Config{:,["ParentRow","ParentCol"]};
    try
    temp = table(ParentStr,ParentSize(:,1),ParentSize(:,2),'VariableNames',["ConfigStr","ConfigRow","ConfigCol"]);
    catch e
        e
    end
    fileName = join(["size",ParentSize(1),ParentSize(2)],"_");
    ds = subset(Ds,contains(Ds.Files,fileName));
    
    for ii = 1:numel(ds.Files)
        FileData = read(ds);
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
            [a,b]  = ismember(Parent(:,["ConfigRow","ConfigCol","ConfigStr","ParentStr"]),Path(:,["ConfigRow","ConfigCol","ConfigStr","ParentStr"]));
            if any(a)
                if ~any(~a)
                    fprintf("bad config")
                    OK = false
                    return
                end
               Parent = Parent(find(~a,1),:);
            end
            Path(end+1,:) = Parent(1,:);
        case "FlipAndPath"
            NewParent = FlipMovmentAndConfig(Config,Parent);
            FileData(ParentLoc,:) = NewParent;
            FileAddress = ds.Files{FileLoc};
            save(FileAddress,"FileData");
            
            Path(end+1,:) = NewParent;
    end
    catch e
        fprintf("corupt");
       
        pause
    end
    Config = Parent;
end
switch mode
    case "FlipAndPath"
        Path = flip(Path,1);
    otherwise
end

end
