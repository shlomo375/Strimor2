function [Connect, NumberOfCOnfig, PathLength, Path, time] = ConnectionProccess(TreeProperty,TreeProp,TreeTurn,TreeFolder,TargetIndex)
NumberOfCOnfig = 0;
PathLength = 0 ;
Path = 0;
time = 0;
 try        
    ds = fileDatastore(TreeFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    if any(contains(ds.Files,"Path_"+TargetIndex+".mat"))
        Connect = true;
        load(fullfile(TreeFolder,"Path_"+TargetIndex+".mat"),"time","Path","PathLength","NumberOfCOnfig");
        return
    end
catch e
    e
    
end

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
 

end


end
