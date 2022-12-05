function [NumberOfCOnfig,  PathLength, Path,time,ResultFileName] = Expend2Tree(TreeFolder, Info)
ResultFileName = [];
NumberOfCOnfig = 0;
PathLength=[];
Path=[];
time = [];
% TreeFolder = extractBefore(TreeFolder,"\Start"|"\Target");


try        
    ds = fileDatastore(TreeFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    if any(contains(ds.Files,"success"))
        try
            [NumberOfCOnfig, PathLength] = ExtructTreeDataRepaire(TreeFolder);
        end
        return
    end
catch e
    e
    
end

TreeProp(2) = TreeProperties(TreeFolder,"Target");
TreeProp(1) = TreeProperties(TreeFolder,"Start"); 


while true

%     TreeProp(1).tree = LoadTree(TreeProp(2).Folder);
%     TreeProp(2).tree = LoadTree(TreeFolder,"Start");
    
    algorithm ="RRT*"; 
%     
%     MinRootConfig = min([size(TreeProp(1).RootConfigs,1),size(TreeProp(2).RootConfigs,1)]);
%     RootConfigIndex = [1:MinRootConfig, 1:MinRootConfig];
    
    
    
    for TargetIndex = 1:size(TreeProp(1).Target,1)

        TreeProp(1).tree = TreeClass(TreeProp(1).Folder, N,Info.MaxConfig+500, TreeProp(1).tree.Data,TreeProp(1).Target(TargetIndex,:));
        
        N = sum(logical(TreeProp(1).Target(1,:).ConfigMat{:}),'all');
        Size = [N, 2*N];
        
        TreeTurn = logical([1,0]);
        TreeProperty = TreeProp(TreeTurn);
        while true

            tree.AddDuration = TreeProperty.FinalDuration;
            
            BasicWS = WorkSpace(Size,algorithm);
            MaxNumOfConfig = TreeProperty.TotalNodes/2+5;
            if MaxNumOfConfig > 1e5
                MaxNumOfConfig = 1e5;
            end
            
            try
                LastIndex = tree.LastIndex;
                stackProgress = 0;
                while tree.LastIndex < MaxNumOfConfig
                    if LastIndex == tree.LastIndex
                        stackProgress = stackProgress +1;
                        if stackProgress>tree.LastIndex*3+100
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
            catch e
                e
            end
               
%             SaveTree2Files(tree);
            SaveTree(tree);
            
            if ~isnan(tree.NumOfIsomorphismAxis)
                [Connect, ConnectedNode] = CompareMixsedTree2TreeFilesIsomorphism(tree.Data,TreeProp(~TreeTurn).ds,tree.NumOfIsomorphismAxis);
            else
                [Connect, ConnectedNode] = CompareMixsedTree2TreeFiles(tree.Data,TreeProp(~TreeTurn).ds);
            end
            
            if Connect
                for ConnectedNode_idx = 1:size(ConnectedNode,1)
                    if ~isnan(tree.NumOfIsomorphismAxis)
                        [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeDataIsomorphism(TreeFolder,ConnectedNode,tree.NumOfIsomorphismAxis);
                    else
                        [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(TreeFolder,ConnectedNode(ConnectedNode_idx,:),true);
                    end
                    save(TreeFolder+"\success.mat","time","Path","PathLength","NumberOfCOnfig");
                    SuccessDir = fullfile(extractBefore(TreeFolder,digitsPattern+"N\"),"AllTreeResulte");
                    mkdir(SuccessDir);
                    ResultFileName = replace(extractAfter(TreeFolder,"RRTtree\"),"\","-")+".mat";
                    save(fullfile(SuccessDir,ResultFileName),"ResultFileName","time","Path","PathLength","NumberOfCOnfig");
        %             MakeVideoOfPath(Path, 8, 60, "try");
                    if PathLength ~= -1
    %                     break
                    end
                end
                 
                return
            end
            
            TreeProperty.TotalNodes = TreeProperty.TotalNodes + tree.LastIndex;
            TreeProperty.FinalDuration = tree.LastNodeTime;
            TreeProp(TreeTurn) = TreeProperty;
    
            TreeTurn = ~TreeTurn;
            TreeProperty = TreeProp(TreeTurn);
        end
    end

end

end