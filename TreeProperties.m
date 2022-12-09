function Prop = TreeProperties(Folder,Direction,TargetNum)
if nargin==3
    Prop.Folder = fullfile(Folder,Direction+"_"+TargetNum);
else
    Prop.Folder = fullfile(Folder,Direction);
end

% Prop.ds = fileDatastore(Prop.Folder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);

Prop.tree = LoadTree(Prop.Folder);
try
    Prop.tree.Data = Prop.tree.Data(1:Prop.tree.LastIndex+10500,:);
catch
    Prop.tree.Data{1:end+10500,"Step"} = 1;
end

if ~contains(Prop.Folder,"Optimal")
    Prop.tree.NumOfIsomorphismAxis = 3;
end

Prop.FinalDuration = max(Prop.tree.Data.time);
Prop.TotalNodes = Prop.tree.LastIndex;
% [Prop.FinalDuration,Prop.TotalNodes] = TreeLastTimeAndSize(Prop.ds);

load(fullfile(Prop.Folder,"Target.mat"),"TargetConfig");
Prop.Target = TargetConfig;

Prop.tree = UpdateTreeTarget(Prop.tree,TargetConfig(1,:));
% Prop.tree = LoadTree(Prop.Folder);

Prop.ConnectedNode = [];
end