function TreeFolder = ExpendMultyTree(TreeFolder, Info)

DontStop = true;
load(fullfile(TreeFolder,"Target.mat"),"TargetConfig");

ds = fileDatastore(TreeFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
if any(contains(ds.Files,"ExpendFinish"))
    return
end

FinalDur = TreeLastTimeAndSize(ds);
    

while DontStop
    [Data,FileIndex] = GetVariablesFromDs(ds,["Visits","Cost2Target"]);
    data.Visits = Data(:,1);
    data.Cost2Target = Data(:,2);
    
    NodeIndex = TreeClass.RandConfig(data,[],1);
    
    RootConfig = GetVariablesFromDs(ds,[],sort(NodeIndex),FileIndex);
    
    algorithm ="RRT*"; 

    for ii = 1:size(RootConfig,1)
        N = sum(logical(RootConfig(ii,:).ConfigMat{:}),'all');
        Size = [N, 2*N];
    
    
        tree = TreeClass(TreeFolder, N,1e4+500, RootConfig(ii,:),TargetConfig);
        tree.AddDuration = FinalDur;
        
        BasicWS = WorkSpace(Size,algorithm);
        
         LastIndex = tree.LastIndex;
            stackProgress = 0;
        while tree.LastIndex < 1e4
            if LastIndex == tree.LastIndex
                stackProgress = stackProgress +1;
                if stackProgress==10
                    return
                end
            else
                stackProgress = 0;
                LastIndex = tree.LastIndex;
            end
            NodeIndex = randi(tree.LastIndex,1,1);
    %             NodeIndex = TreeClass.RandConfig(tree.Data,tree.LastIndex);
            [tree, Config.Status, Config.Type] = Get(tree,NodeIndex,"ConfigMat","Type");
    
            WS = SetConfigurationOnSpace(BasicWS, Config);
            Parts =  AllSlidingParts(WS);
            tree = MovingEachIndividualPartPCDepth(tree, WS, Parts, NodeIndex);
    
        end
        ConfigNum = tree.LastIndex;
 
        SaveTree2Files(tree);
        save(fullfile(TreeFolder,"ExpendFinish.mat"),"ConfigNum");
    end
%     if ~contains(TreeFolder,["1001","1002"])
        DontStop = false;
%     end
end


end