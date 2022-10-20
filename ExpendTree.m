function [NumberOfCOnfig, PathLength, Path, time,ResultFileName] = ExpendTree(TreeFolder, Info)
NumberOfCOnfig = 0;
PathLength = 0; 
Path = 0;
time = 0;
ResultFileName = [];
load(fullfile(TreeFolder,"Target.mat"),"TargetConfig");
        
ds = fileDatastore(TreeFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
if any(contains(ds.Files,"success"))
TreeFolder
try
     [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(TreeFolder,TargetConfig,false);
catch e
e
end
     save(TreeFolder+"\success.mat","time","Path","PathLength","NumberOfCOnfig");
     SuccessDir = fullfile(extractBefore(TreeFolder,digitsPattern+"N\"),"AllTreeResulte");
     mkdir(SuccessDir);
     ResultFileName = replace(extractAfter(TreeFolder,"RRTtree\"),"\","-")+".mat";
     save(fullfile(SuccessDir,ResultFileName),"ResultFileName","time","Path","PathLength","NumberOfCOnfig");
    return
end

FinalDur = TreeLastTimeAndSize(ds);
    

while true
    [Data,FileIndex] = GetVariablesFromDs(ds,["Visits","Cost2Target"]);
    data.Visits = Data(:,1);
    data.Cost2Target = Data(:,2);
    if numel(data.Visits)<Info.iteration
        NodeIndex = TreeClass.RandConfig(data,[],numel(data.Visits));
    else
        NodeIndex = TreeClass.RandConfig(data,[],Info.iteration);
    end
    RootConfig = GetVariablesFromDs(ds,[],sort(NodeIndex),FileIndex);

    MaxConfigIter = 10000;
    algorithm ="RRT*"; 
    
    for ii = 1:size(RootConfig,1)
        N = sum(logical(RootConfig(ii,:).ConfigMat{:}),'all');
        Size = [N, 2*N];

    
        tree = TreeClass(TreeFolder, N,MaxConfigIter+500, RootConfig(ii,:),TargetConfig);
        tree.AddDuration = FinalDur;
        
        BasicWS = WorkSpace(Size,algorithm);
        

        LastIndex = tree.LastIndex;
        stackProgress = 0;
        while tree.LastIndex < MaxConfigIter
            if LastIndex == tree.LastIndex
                stackProgress = stackProgress +1;
                if stackProgress==tree.LastIndex*10+100
                    return
                end
            else
                LastIndex = tree.LastIndex;
                stackProgress = 0;
            end
            NodeIndex = TreeClass.RandConfig(tree.Data,tree.LastIndex);
            [tree, Config.Status, Config.Type] = Get(tree,NodeIndex,"ConfigMat","Type");
    
            WS = SetConfigurationOnSpace(BasicWS, Config);
            Parts =  AllSlidingParts(WS);
            [tree,success] = MovingEachIndividualPartPCDepth(tree, WS, Parts, NodeIndex);
            
            if success
                fprintf("success!!!\n");
                Resulte = "success";
                save(TreeFolder+"\success.mat","Resulte");
                break
            end
        end
        
        SaveTree2Files(tree);
        if success
            [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(TreeFolder,tree.EndConfig,false);
            save(TreeFolder+"\success.mat","time","Path","PathLength","NumberOfCOnfig");
            SuccessDir = fullfile(extractBefore(TreeFolder,digitsPattern+"N\"),"AllTreeResulte");
            mkdir(SuccessDir);
            ResultFileName = replace(extractAfter(TreeFolder,"RRTtree\"),"\","-")+".mat";
            save(fullfile(SuccessDir,ResultFileName),"ResultFileName","time","Path","PathLength","NumberOfCOnfig");
            return
        end
    end
end

end