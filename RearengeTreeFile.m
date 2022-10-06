
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
addpath(genpath(SoftwareLocation));
CompleteFileLoc = "RRTtree\36N";
Trees(1) = "RRTtree\36N\CarTree";
Trees(2) = "RRTtree\36N\LineTree";
Trees(3) = "RRTtree\36N\RotatedLineTree";
Trees(4) = "RRTtree\36N\ShapeTree";

for ii = 1:numel(Trees)
ds = fileDatastore(Trees(ii),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    ds.Files(~contains(ds.Files,"size")) = [];

sizes = unique(extractBefore(ds.Files,"_"+digitsPattern+"_p"+digitsPattern+".mat"));
for jj = 1:numel(sizes)
    smallDs = subset(ds,contains(ds.Files,sizes(ii)));
    disp(sizes{jj});
    File = readall(smallDs);
    SaveFile(sizes(jj),File);
    for kk  =1:numel(smallDs.Files)
        delete(smallDs.Files{kk});
    end
end
end
