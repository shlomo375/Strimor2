function [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeData(TreeFolder,ConnectedOrTargetNode,TwoTree)
NumberOfCOnfig = 0;
time = datetime("tomorrow");

StartFolder = TreeFolder;
if TwoTree
    StartFolder = fullfile(TreeFolder,"Start");
    time = ConnectedOrTargetNode.time;
end

StartDS = fileDatastore(StartFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
StartDS.Files(~contains(StartDS.Files,"size")) = [];


for ii = 1:numel(StartDS.Files)
    File = read(StartDS);
    if TwoTree
        try
            File(File.time > time,:) = [];
        end
    end
    NumberOfCOnfig = NumberOfCOnfig + size(File,1);
end

if TwoTree
    TargetFolder = fullfile(TreeFolder,"Target");
    
    TargetDS = fileDatastore(TargetFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    TargetDS.Files(~contains(TargetDS.Files,"size")) = [];
    
    for ii = 1:numel(TargetDS.Files)
    File = read(TargetDS);
    try
        File(File.time > time,:) = [];
    end
    NumberOfCOnfig = NumberOfCOnfig + size(File,1);
    end
end

if TwoTree
    if isnan(Isomorphism)
        try
            [OK, PathFromStart, PathLengthStart] = Scanner(StartDS,ConnectedOrTargetNode,"Path");
                
            [OK2, PathFromTarget, PathLengthTarget] = Scanner(TargetDS,ConnectedOrTargetNode,"FlipAndPath");
            
            Path = [PathFromTarget(1:end-1,:); PathFromStart];
        
            PathLength = PathLengthStart + PathLengthTarget + 2;
        catch e
            d=5
        end
    else
        try
            [OK, PathFromStart, PathLengthStart] = ScannerIsomorphism(StartDS,ConnectedOrTargetNode,"Path",Isomorphism);
                
            [OK2, PathFromTarget, PathLengthTarget] = ScannerIsomorphism(TargetDS,ConnectedOrTargetNode,"FlipAndPath",Isomorphism);
            
            Path = [PathFromTarget(1:end-1,:); PathFromStart];
        
            PathLength = PathLengthStart + PathLengthTarget + 2;
        catch e
            d=6
        end
    end
else
    [OK, Path, PathLength] = Scanner(StartDS,ConnectedOrTargetNode,"Path");
    OK2 = 1;
end

% PathLength = size(Path,1);

if ~OK || ~OK2
    PathLength = -1;
end

end
