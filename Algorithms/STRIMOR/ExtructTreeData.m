function [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(TreeFolder,ConnectedOrTargetNode,TwoTree)
NumberOfCOnfig = 0;
time = datetime("tomorrow");
Path = [];
StartFolder = TreeFolder;
if TwoTree
    StartFolder = fullfile(TreeFolder,"Start");
    time = ConnectedOrTargetNode.time;
end

StartDS = fileDatastore(StartFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
StartDS.Files(~contains(StartDS.Files,"size")) = [];

MiddelStartLevel = [];
for ii = 1:numel(StartDS.Files)
    File = read(StartDS);
    if TwoTree
        try
            File(File.time > time,:) = [];
        end
    end
    if isempty(MiddelStartLevel)
        MiddelStartLoc = ismember(File(:,["ConfigStr","ConfigCol","ConfigRow"]),ConnectedOrTargetNode(1,["ConfigStr","ConfigCol","ConfigRow"]));
        MiddelStartLevel = File{MiddelStartLoc,"Level"};
    end
    NumberOfCOnfig = NumberOfCOnfig + size(File,1);
end

if TwoTree
    TargetFolder = fullfile(TreeFolder,"Target");
    
    TargetDS = fileDatastore(TargetFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    TargetDS.Files(~contains(TargetDS.Files,"size")) = [];
    
    MiddelTargetLevel = [];
    for ii = 1:numel(TargetDS.Files)
    File = read(TargetDS);
    try
        File(File.time > time,:) = [];
    end
    NumberOfCOnfig = NumberOfCOnfig + size(File,1);
    
        if isempty(MiddelTargetLevel)
            MiddelTargetLoc = ismember(File(:,["ConfigStr","ConfigCol","ConfigRow"]),ConnectedOrTargetNode(1,["ConfigStr","ConfigCol","ConfigRow"]));
            MiddelTargetLevel = File{MiddelTargetLoc,"Level"};
        end
    end
    
    try
        [OK, PathFromStart, PathLengthStart] = ScannerIsomorphism(StartDS,ConnectedOrTargetNode,"Path");
           
        [OK2, PathFromTarget, PathLengthTarget] = ScannerIsomorphism(TargetDS,ConnectedOrTargetNode,"Path");
        
        Path = [PathFromTarget; PathFromStart]
    
        PathLength = PathLengthStart + PathLengthTarget + 2
    catch e
        e;
        PathLength = MiddelTargetLevel  + MiddelStartLevel + 2;
    end

else
    PathLength = ConnectedOrTargetNode{1,"Level"}+1;
    try
        [OK, Path] = Scanner(StartDS,ConnectedOrTargetNode,"Path");
    end
    OK2 = 1;
end

% PathLength = size(Path,1);
try
    if ~OK || ~OK2
        PathLength = -1;
    end
end
end
