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

TreeProp(2) = TreeProperties(TreeFolder,"Target",1);
TreeProp(1) = TreeProperties(TreeFolder,"Start"); 


while true

%     TreeProp(1).tree = LoadTree(TreeProp(2).Folder);
%     TreeProp(2).tree = LoadTree(TreeFolder,"Start");
    
    algorithm ="RRT*"; 
%     
%     MinRootConfig = min([size(TreeProp(1).RootConfigs,1),size(TreeProp(2).RootConfigs,1)]);
%     RootConfigIndex = [1:MinRootConfig, 1:MinRootConfig];
    
    
    
    for TargetIndex = 1:size(TreeProp(1).Target,1)
        N = sum(logical(TreeProp(1).Target(1,:).ConfigMat{:}),'all');
        Size = [N, 2*N];
        TreeProp(1).tree = UpdateTreeTarget(TreeProp(1).tree,TreeProp(1).Target(TargetIndex,:));
        TreeProp(2) = TreeProperties(TreeFolder,"Target",TargetIndex);
        
        
        TreeTurn = logical([1,0]);
        TreeProperty = TreeProp(TreeTurn);
        while true

            TreeProperty.tree.AddDuration = TreeProperty.FinalDuration;
            
            BasicWS = WorkSpace(Size,algorithm);
            MaxNumOfConfig = TreeProperty.TotalNodes/2+10;
            if MaxNumOfConfig > 1e5
                MaxNumOfConfig = 1e5;
            end
            
            try
                LastIndex = TreeProperty.tree.LastIndex;
                stackProgress = 0;
                while TreeProperty.tree.LastIndex < MaxNumOfConfig
                    if LastIndex == TreeProperty.tree.LastIndex
                        stackProgress = stackProgress +1;
                        if stackProgress>TreeProperty.tree.LastIndex*3+100
                            return
                        end
                    else
                        LastIndex = TreeProperty.tree.LastIndex;
                        stackProgress = 0;
                    end
                    NodeIndex = TreeClass.RandConfig(TreeProperty.tree.Data,TreeProperty.tree.LastIndex,"VisitBasedRand");
                    [TreeProperty.tree, Config.Status, Config.Type,ConfigVisits] = Get(TreeProperty.tree,NodeIndex,"ConfigMat","Type","Visits");
            
                    WS = SetConfigurationOnSpace(BasicWS, Config);
                    Parts =  AllSlidingParts(WS,N);
        
                    Combinations = MakeRandomPartsCombinations(Parts,ConfigVisits,"Partial");  
        
                    [TreeProperty.tree,success] = MovingEachIndividualPartPCDepth(TreeProperty.tree, WS, Combinations, NodeIndex);
                                
                    if success
                        fprintf("success!!!");
                        SaveTree(TreeProperty.tree);
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
            if ~mod(TreeProperty.tree.LastIndex,10000)
                SaveTree(TreeProperty.tree);
            end
            
%             if TreeProperty.tree.LastIndex~=find(TreeProperty.tree.Data.Index,1,"last")
%                 ss
%             end

            if ~isnan(TreeProperty.tree.NumOfIsomorphismAxis)
                try
                [Connect, TreeProperty.ConnectedNode,TreeProp(~TreeTurn).ConnectedNode] = CompareMixsedTree2TreeFilesIsomorphism(TreeProperty.tree.Data,TreeProp(~TreeTurn).tree.Data,TreeProperty.tree.NumOfIsomorphismAxis);

                catch MEC
                    MEC
                end
            else
                error
                [Connect, ConnectedNode] = CompareMixsedTree2TreeFiles(TreeProperty.tree.Data,TreeProp(~TreeTurn).tree.Data);
            end
            
            if Connect

                TreeProperty.TotalNodes = TreeProperty.TotalNodes + TreeProperty.tree.LastIndex;
                TreeProperty.FinalDuration = TreeProperty.tree.LastNodeTime;
                TreeProp(TreeTurn) = TreeProperty;

                SaveTree(TreeProp(1).tree);
                SaveTree(TreeProp(2).tree);
%                 if TreeProp(1).tree.LastIndex~=find(TreeProp(1).tree.Data.Index,1,"last")
%                 ss
%             end
% if TreeProp(2).tree.LastIndex~=find(TreeProp(2).tree.Data.Index,1,"last")
%                 ss
%             end
                for ConnectedNode_idx = 1:size(TreeProp(1).ConnectedNode,1)
                    if ~isnan(TreeProperty.tree.NumOfIsomorphismAxis)
                        [NumberOfCOnfig, PathLength, Path, time] = ExtructPathFromTrees(TreeProp(1).tree,TreeProp(2).tree,TreeProp(1).ConnectedNode(ConnectedNode_idx,:),TreeProp(2).ConnectedNode(ConnectedNode_idx,:));
                    else
                        [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(TreeFolder,ConnectedNode1(ConnectedNode_idx,:),true);
                    end
                    save(fullfile(TreeFolder,"Path_"+TargetIndex+".mat"),"time","Path","PathLength","NumberOfCOnfig");
                    SuccessDir = fullfile(extractAfter(TreeFolder,"Results"),"AllTreeResulte");
                    mkdir(SuccessDir);
                    ResultFileName = replace(extractAfter(TreeFolder,"RRTtree\"),"\","-")+"-Path_"+TargetIndex+".mat";
                    save(fullfile(SuccessDir,ResultFileName),"ResultFileName","time","Path","PathLength","NumberOfCOnfig");
        %             MakeVideoOfPath(Path, 8, 60, "try");
                    if PathLength ~= -1
    %                     break
                    end
                end
                 
                break
            end
            
            TreeProperty.TotalNodes = TreeProperty.TotalNodes + TreeProperty.tree.LastIndex;
            TreeProperty.FinalDuration = TreeProperty.tree.LastNodeTime;
            TreeProp(TreeTurn) = TreeProperty;
    
            TreeTurn = ~TreeTurn;
            TreeProperty = TreeProp(TreeTurn);
        end
    end

end

end