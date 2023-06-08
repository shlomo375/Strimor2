function [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeDataRepaire(Folder)
Path = [];
time = [];
Isomotphism = double(extractBetween(Folder,"_IM","Axis"));
if ~contains(Folder,"OneTree")
    StartFolder = fullfile(Folder,"Start");
    EndFolder = fullfile(Folder,"Target");
    StartDs = fileDatastore(StartFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    StartDs.Files(~contains(StartDs.Files,"size")) = [];
    StartTree = readall(StartDs);


    TargetDs = fileDatastore(EndFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    if isempty(Isomotphism) || isnan(Isomotphism)
        [Connect, ConnectedNode] = CompareMixsedTree2TreeFiles(StartTree,TargetDs);
    else
        [Connect, ConnectedNode] = CompareMixsedTree2TreeFilesIsomorphism(StartTree,TargetDs,Isomotphism);
    end
    
    TwoTree = true;
else
    load(fullfile(Folder,"Target.mat"),"TargetConfig");
    ConnectedNode = TargetConfig;
    Connect = 1;
    TwoTree = false;
end
if Connect
    if isempty(Isomotphism) || isnan(Isomotphism)
        [NumberOfCOnfig, PathLength,Path,time] = ExtructTreeData(Folder,ConnectedNode(1,:),TwoTree);
    else
        [NumberOfCOnfig, PathLength,Path,time] = ExtructTreeDataIsomorphism(Folder,ConnectedNode,Isomotphism);
    end
        
        save(Folder+"\success.mat","time","Path","PathLength","NumberOfCOnfig");
    SuccessDir = fullfile(extractBefore(Folder,digitsPattern+"N\"),"AllTreeResulte");
    mkdir(SuccessDir);
    ResultFileName = replace(extractAfter(Folder,"RRTtree\"),"\","-")+".mat";
    save(fullfile(SuccessDir,ResultFileName),"ResultFileName","time","Path","PathLength","NumberOfCOnfig");
%                 MakeVideoOfPath(Path, 8, 60, "try");
      
end

end
