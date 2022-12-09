function [OK, Path, ConfigLevel] = ScannerIsomorphism(Tree,ConnectedConfig,mode,IsoAxises)

OK = 1;
%% Find config in tree
Lable = ["IsomorphismStr1","IsoSiz1r","IsoSiz1c";"IsomorphismStr2","IsoSiz2r","IsoSiz2c";"IsomorphismStr3","IsoSiz3r","IsoSiz3c"];
MinTime = max(Tree.Data.time);
for Axis = 1:IsoAxises
    ConfigLoc = ismember(Tree.Data(:,Lable(Axis,:)),ConnectedConfig(:,Lable(Axis,:)));

    ConnectedNode = Tree.Data(ConfigLoc,:);
    if ConnectedNode.time <= MinTime
        Config = ConnectedNode;
    end

end

StartConfig = Tree.StartConfig;

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
    
%     fileName = join(["size",ParentSize(1),ParentSize(2)],"_");
%     ds = subset(Ds,contains(Ds.Files,fileName));
    
%     for ii = 1:numel(ds.Files)
%         FileData = read(ds);
%%
%         [~,UniqueLoc] = unique(Tree1.Data(:,["ConfigRow","ConfigCol","ConfigStr","Type"]));
%         Tree1.Data = Tree1.Data(UniqueLoc,:);
%%
        ParentLoc = ismember(Tree.Data(:,["ConfigStr","ConfigRow","ConfigCol"]),temp);
        Parent = Tree.Data(ParentLoc,:);

    try
    switch mode
        case "flip"   
            %%
            NewParent = FlipMovmentAndConfig(Config,Parent);
            Tree.Data(ParentLoc,:) = NewParent;

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
%             NewParent = FlipMovmentAndConfig(Config,Parent);
%             Tree.Data(ParentLoc,:) = NewParent;
            Path(end+1,:) = Parent;
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
   
end

end
