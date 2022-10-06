function [TreeName, TotalTreeNode, ConfigPerSec] = ExpendFromOneConfig(TaskData,TreeFolder, Info)
Q = TaskData{1};
TotalTreeNode = 0;
ConfigPerSec = 0;

TreeName = extractAfter(TreeFolder,"Results\"); 
load(fullfile(TreeFolder,"Target.mat"),"TargetConfig");
        
ds = fileDatastore(TreeFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
if any(contains(ds.Files,"success"))
    return
end

[Data,FileIndex] = GetVariablesFromDs(ds,["Visits","Cost2Target"]);
data.Visits = Data(:,1);
data.Cost2Target = Data(:,2);

if numel(data.Visits)<Info.iteration
    NodeIndex = TreeClass.RandConfig(data,[],numel(data.Visits));
else
    NodeIndex = TreeClass.RandConfig(data,[],Info.iteration);
end
RootConfig = GetVariablesFromDs(ds,[],sort(NodeIndex),FileIndex);


ii=1;
%for ii = 1:size(RootConfig,1)
while TotalTreeNode < 1e6
    MaxConfigIter = Info.MaxConfig + (1000*(randi(6,1)-3));
    algorithm ="RRT*"; 
    N = sum(logical(RootConfig(ii,:).ConfigMat{:}),'all');
    Size = [N, 2*N];
    tree = TreeClass(TreeFolder, N,MaxConfigIter+500, RootConfig(ii,:),TargetConfig);
    StartTime = tic;
    
    BasicWS = WorkSpace(Size,algorithm);
    UpdateCostConfig = [];
    
        while tree.LastIndex < MaxConfigIter
            NodeIndex = TreeClass.RandConfig(tree.Data,tree.LastIndex);
            [tree, Config.Status, Config.Type] = Get(tree,NodeIndex,"ConfigMat","Type");
    
            WS = SetConfigurationOnSpace(BasicWS, Config);
            Parts =  AllSlidingParts(WS);
            [tree,success] = MovingEachIndividualPartPCDepth(tree, WS, Parts, NodeIndex);
            if success
                fprintf("success!!!");
                SaveTree2Files(tree,UpdateCostConfig, TaskData);
%                 Resulte = GetResulteData(TreeFolder);
                Resulte = "success";
                save(TreeFolder+"\success.mat","Resulte");
                TotalTreeNode = TotalTreeNode + tree.LastIndex;
                return
            end
    %         [Combinations, ~] = MakeRandomPartsCombinations(Parts,10+(Visits>2)*1000);
%                     [Combinations, ~] = MakeRandomPartsCombinations(Parts,10);
    
%             [tree,success] = MovingEachIndividualPartPCDepth(tree, WS, Combinations, NodeIndex);
            
            ConfigPerSec = {tree.LastIndex./toc(StartTime)};
%             send(Q,{TreeName,"search",ii,TotalTreeNode + tree.LastIndex,1e6,round(ConfigPerSec)});
    
        end
        TotalTreeNode = TotalTreeNode + tree.LastIndex;
    
    
    SaveTree2Files(tree,UpdateCostConfig, TaskData);
%     send(Q,{TreeName,"finish",0,TotalTreeNode ,1e6,round(ConfigPerSec)})
end

end