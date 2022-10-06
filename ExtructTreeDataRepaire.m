function [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeDataRepaire(Folder)
if ~contains(Folder,"OneTree")
    StartFolder = fullfile(Folder,"Start");
    EndFolder = fullfile(Folder,"Target");
    StartDs = fileDatastore(StartFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    StartDs.Files(~contains(StartDs.Files,"size")) = [];
    StartTree = readall(StartDs);


    TargetDs = fileDatastore(EndFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    [Connect, ConnectedNode] = CompareMixsedTree2TreeFiles(StartTree,TargetDs);
    
    TwoTree = true;
else
    load(fullfile(Folder,"Target.mat"),"TargetConfig");
    ConnectedNode = TargetConfig;
    Connect = 1;
    TwoTree = false;
end
if Connect
    for ConnectedNode_idx = 1:size(ConnectedNode,1)
        [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(Folder,ConnectedNode(ConnectedNode_idx,:),TwoTree);
        save(Folder+"\success.mat","time","Path","PathLength","NumberOfCOnfig");
        SuccessDir = fullfile(extractBefore(Folder,digitsPattern+"N\"),"AllTreeResulte");
        mkdir(SuccessDir);
        ResultFileName = replace(extractAfter(Folder,"RRTtree\"),"\","-")+".mat";
        save(fullfile(SuccessDir,ResultFileName),"ResultFileName","time","Path","PathLength","NumberOfCOnfig");
    %                 MakeVideoOfPath(Path, 8, 60, "try");
        if PathLength ~= -1
            break
        end
    end
            
end

end
