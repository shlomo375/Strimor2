function [TreeName, TotalTreeNode, ConfigPerSec] = ExpendCompleteTree(TreeFolder, Info)
TotalTreeNode = 0;
ConfigPerSec = 0;

TreeName = extractAfter(TreeFolder,"Results\"); 
load(fullfile(TreeFolder,"CompleteTree","Target.mat"),"TargetConfig");

ds = fileDatastore(fullfile(TreeFolder,"CompleteTree"),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
if any(contains(ds.Files,"success"))
    return
end

ds.Files(~contains("size")) = [];

RandomFileIdx = randi(numel(ds.Files));
subDS = subset(ds,RandomFileIdx);
FileData = read(subDS);
RootConfig = FileData(randi(size(FileData,1)),:);

algorithm ="RRT*"; 
N = sum(logical(FileData(1,:).ConfigMat{:}),'all');
tree = TreeClass(fullfile(TreeFolder,"CompleteTree"), N,Info.MaxConfig+500, RootConfig, TargetConfig);
Size = [N, 2*N];


LastIndex = tree.LastIndex;
stackProgress = 0;
while tree.LastIndex < Info.MaxConfig
    if LastIndex == tree.LastIndex
        stackProgress = stackProgress +1;
        if stackProgress>tree.LastIndex*3+100
            return
        end
    else
        LastIndex = tree.LastIndex;
        stackProgress = 0;
    end


    StartTime = tic;
    
    BasicWS = WorkSpace(Size,algorithm);
    UpdateCostConfig = [];%%
    
        
    NodeIndex = TreeClass.RandConfig(tree.Data,tree.LastIndex);
    [tree, Config.Status, Config.Type] = Get(tree,NodeIndex,"ConfigMat","Type");

    WS = SetConfigurationOnSpace(BasicWS, Config);
    Parts =  AllSlidingParts(WS);

    Combinations = MakeRandomPartsCombinations(Parts,Info.RowNumData);  

    [tree,success] = MovingEachIndividualPartPCDepth(tree, WS, Combinations, NodeIndex);


    if success
        fprintf("success!!!");
        SaveTree2Files(tree);
%                 Resulte = GetResulteData(TreeFolder);
        Resulte = "success";
        save(TreeProperty.Folder+"\success.mat","Resulte");
        
        break
    end
end

SaveTree2Files(tree);

end

end