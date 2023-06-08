function [NumberOfCOnfig, PathLength, Path, time] = ExtructTreeDataIsomorphism(TreeFolder,ConnectedOrTargetNode,IsoAxises)
Path = [];
StartFolder = TreeFolder;
StartFolder = fullfile(TreeFolder,"Start");
time = ConnectedOrTargetNode.time;

StartDS = fileDatastore(StartFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
StartDS.Files(~contains(StartDS.Files,"size")) = [];

StartFile = readall(StartDS);
StartFile(StartFile.time > time,:) = [];

NumberOfCOnfig = size(StartFile,1);

TargetFolder = fullfile(TreeFolder,"Target");
    
TargetDS = fileDatastore(TargetFolder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
TargetDS.Files(~contains(TargetDS.Files,"size")) = [];

TargetFile = readall(TargetDS);
TargetFile(TargetFile.time > time,:) = [];

NumberOfCOnfig = NumberOfCOnfig + size(TargetFile,1);

Lable = ["IsomorphismStr1","IsoSiz1r","IsoSiz1c";"IsomorphismStr2","IsoSiz2r","IsoSiz2c";"IsomorphismStr3","IsoSiz3r","IsoSiz3c"];
MinLevel1 = 1e10;
MinLevel2 = 1e10;
StartConnectedNode = [];
TargetConnectedNode = [];
for Axis = 1:IsoAxises
    FileConfigLoc = ismember(StartFile(:,Lable(Axis,:)),ConnectedOrTargetNode(:,Lable(Axis,:)));

    FilesConnectedNode = StartFile(FileConfigLoc,:);
    [MinLevel1, Node2Save] = min([MinLevel1; FilesConnectedNode.Level]);
    StartConnectedNode = [StartConnectedNode; FilesConnectedNode];

end

for Axis = 1:IsoAxises
    FileConfigLoc = ismember(TargetFile(:,Lable(Axis,:)),ConnectedOrTargetNode(:,Lable(Axis,:)));

    FilesConnectedNode = TargetFile(FileConfigLoc,:);
    [MinLevel2,Node2Save] = min([MinLevel2; FilesConnectedNode.Level]);

    TargetConnectedNode = [TargetConnectedNode; FilesConnectedNode];

end
PathLength1 = MinLevel1 + MinLevel2 + 2; 

%%
PairValue1= [];
PairValue2= [];
PairValue3= [];
for ii = 1:size(StartConnectedNode,1)
    PairLoc1 = strcmp(StartConnectedNode.IsomorphismStr1(ii),TargetConnectedNode.IsomorphismStr1);
    OptionalConfig = TargetConnectedNode(PairLoc1,:);
    MinVal = min(OptionalConfig.Level);
    if isempty(MinVal)
        PairValue1 = [PairValue1; 10000];
    else
        PairValue1 = [PairValue1; MinVal+StartConnectedNode.Level(ii)];
    end 
end

for ii = 1:size(StartConnectedNode,1)
    PairLoc2 = strcmp(StartConnectedNode.IsomorphismStr2(ii),TargetConnectedNode.IsomorphismStr2);
    OptionalConfig = TargetConnectedNode(PairLoc2,:);
    MinVal = min(OptionalConfig.Level);
    if isempty(MinVal)
        PairValue2 = [PairValue2; 10000];
    else
        PairValue2 = [PairValue2; MinVal+StartConnectedNode.Level(ii)];
    end 
end

for ii = 1:size(StartConnectedNode,1)
    PairLoc3 = strcmp(StartConnectedNode.IsomorphismStr3(ii),TargetConnectedNode.IsomorphismStr3);
    OptionalConfig = TargetConnectedNode(PairLoc3,:);
    MinVal = min(OptionalConfig.Level);
    if isempty(MinVal)
        PairValue3 = [PairValue3; 10000];
    else
        PairValue3 = [PairValue3; MinVal+StartConnectedNode.Level(ii)];
    end 
end

[~,PairLoc] = min(min([PairValue1,PairValue2,PairValue3],[],2),[],1);
StartConnectedNode = StartConnectedNode(PairLoc,:);

PairLoc1 = strcmp(StartConnectedNode.IsomorphismStr1,TargetConnectedNode.IsomorphismStr1);
OptionalConfig = TargetConnectedNode(PairLoc1,:);
try
[MinVal(1),MinLoc(1)] = min(OptionalConfig.Level);
catch
    MinVal(1) = 10000;
    MinLoc(1) = 0;
end
PairLoc1 = strcmp(StartConnectedNode.IsomorphismStr2,TargetConnectedNode.IsomorphismStr2);
OptionalConfig = TargetConnectedNode(PairLoc1,:);
try
[MinVal(2),MinLoc(2)] = min(OptionalConfig.Level);
catch
    MinVal(2) = 10000;
    MinLoc(2) = 0;
end
PairLoc1 = strcmp(StartConnectedNode.IsomorphismStr3,TargetConnectedNode.IsomorphismStr3);
OptionalConfig = TargetConnectedNode(PairLoc1,:);
try
[MinVal(3),MinLoc(3)] = min(OptionalConfig.Level);
catch
    MinVal(3) = 10000;
    MinLoc(3) = 0;
end

[Val,Loc] = min(MinVal);
TargetConnectedNode = TargetConnectedNode(MinLoc(Loc),:);
    


%%
[OK, PathFromStart, PathLengthStart] = ScannerIsomorphism(StartDS,StartConnectedNode,"Path");
           
[OK2, PathFromTarget, PathLengthTarget] = ScannerIsomorphism(TargetDS,TargetConnectedNode,"Path");

Path = [PathFromTarget; PathFromStart]
    
PathLength = PathLengthStart + PathLengthTarget + 2

end
