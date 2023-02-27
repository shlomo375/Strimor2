%% check nan unique config
addpath(genpath('C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles'));
TotalErase = 0;

Trees(1) = "RRTtree\36N\CarTree";
Trees(2) = "RRTtree\36N\LineTree";
Trees(3) = "RRTtree\36N\RotatedLineTree";
Trees(4) = "RRTtree\36N\ShapeTree";



for ii = numel(Trees):-1:1
    Ds{ii} = fileDatastore(Trees{ii},"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    TreeFile = contains(Ds{ii}.Files,"size");
    ds{ii} = subset(Ds{ii},TreeFile);
    files{ii} = ds{ii}.Files;
    files{ii} = extractBetween(files{ii},"Tree\",".mat");
    s = split(files{ii},"_");
    files{ii} = join(s(:,1:3),"_");
%     FullNameFiles(ii} = string(ds{ii}.Files);

    fprintf("get files name...\n");
end
%%
AllFiles = unique(cat(1,files{:}));

for ii = 1:numel(ds)

    for jj = 1:numel(AllFiles)
        
        if any(contains(ds{ii}.Files,AllFiles{jj}))
            fprintf("file: "+ AllFiles{jj}+" tree: "+string(ii)+"Total Delete: "+string(TotalErase)+"\n");
            data = subset(ds{ii},contains(ds{ii}.Files,AllFiles{jj}));
            FileData = readall(data);
            SemiFileData = FileData;
            SemiFileData(:,["Index","time","ConfigMat","ParentMat","Childs"]) = [];
            
            [c,ia] = unique(SemiFileData);
            TotalErase = TotalErase + size(c,1)-size(FileData,1);
            FileData = FileData(ia,:);
            
            SaveFile(AllFiles{jj},FileData);


        end

    end


end



