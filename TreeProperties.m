function Prop = TreeProperties(Folder,Direction)
Prop.Folder = fullfile(Folder,Direction);

Prop.ds = fileDatastore(Prop.Folder,"IncludeSubfolders",true,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);

[Prop.FinalDuration,Prop.TotalNodes] = TreeLastTimeAndSize(Prop.ds);

load(fullfile(Prop.Folder,"Target.mat"),"TargetConfig");
Prop.Target = TargetConfig;
end