%% tree validetion

clear
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
addpath(genpath(SoftwareLocation));
CompleteFileLoc = "RRTtree\36N";
Trees(1) = "RRTtree\36N\CarTree";
Trees(2) = "RRTtree\36N\LineTree";
Trees(3) = "RRTtree\36N\RotatedLineTree";
Trees(4) = "RRTtree\36N\ShapeTree";

DataLength = 1;
VarName = {'time','Index','ParentIndex','Type','Level','Cost','Dir','Step','ConfigRow','ConfigCol','ParentRow','ParentCol','Visits','Cost2Target','ConfigStr','ParentStr','ConfigMat','ParentMat','Childs'};
VarType = {'duration','double','double','double','double','double','double','double','double','double','double','double','double','double','string','string','cell','cell','cell'};
Data = table('Size',[DataLength,numel(VarName)],'VariableTypes',VarType,'VariableNames',VarName);

for ii = 1:numel(Trees)
    
    FolderName = fullfile(CompleteFileLoc,"New"+extractAfter(Trees(ii),"N\"));
    
    mkdir(FolderName);
    ds = fileDatastore(Trees(ii),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    ds.Files(~contains(ds.Files,"size")) = [];
    TreeFile = tall(ds);
    
    try
        load(FolderName+"\CheckConfig.mat","CheckConfig");
        
    catch e
        Data = gather(TreeFile(TreeFile.ParentIndex == 0,:));
        [CheckConfig,Loc] = unique(Data(:,["ConfigStr","ConfigRow","ConfigCol","Type"]));
        CheckConfig = CheckConfig(:,["ConfigStr","ConfigRow","ConfigCol"]);
        Data = Data(Loc,:);
    end

    if isempty(CheckConfig)
        fprintf("empty start config");
        break
    end
    tree = TreeClass(FolderName,36,1,Data);
    tree.Data(:,"time") = [];
    sizes = unique(extractBefore(ds.Files,"_"+digitsPattern+"_p"+digitsPattern+".mat"));
    while true
        ds = fileDatastore(Trees(ii),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
        ds.Files(~contains(ds.Files,"size")) = [];
        CheckConfig.Properties.VariableNames = ["ParentStr","ParentRow","ParentCol"];
        NewCheckConfig = [];
        for jj = 1:numel(sizes)
            try
            smallDs = subset(ds,contains(ds.Files,sizes(jj)));
            disp(string(extractAfter(sizes{jj},"36N")));
            File = readall(smallDs);
            fprintf("ismember...\n");
            [TreeFileLoc, DataConfigLoc] = ismember(File(:,["ParentStr","ParentRow","ParentCol"]),CheckConfig);
            catch e
                e
                TreeFileLoc = 0;
            end
            if any(TreeFileLoc)
                fprintf("serch next batch...\n");
                temp = File(TreeFileLoc,2:end);
                File(TreeFileLoc,:) = [];
                SaveFile(sizes(jj),File);
                for kk  =1:numel(smallDs.Files)
                    delete(smallDs.Files{kk});
                end
        %         temp(:,"time") = [];
                [temptemp,Loc] = unique(temp(:,["ConfigStr","ConfigRow","ConfigCol","Type"]));
                NewCheckConfig = [NewCheckConfig; temp(Loc,["ConfigStr","ConfigRow","ConfigCol"])];
                tree.Data = [tree.Data; temp(Loc,:)];
                
                fprintf("BatchSize: "+ size(tree.Data,1));
                
            end


             
                
            
        end
        
            SaveTree2Files(tree);
            try
                save(tree.FolderName+"\CheckConfig.mat","CheckConfig");
            catch ME1
            end
            tree.Data = [];
        
        if isempty(NewCheckConfig)
            fprintf("finish filter the tree");
%                 fprintf("old tree size: "+OldTreeSize);
                Ds = fileDatastore(tree.FolderName,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
                NewTree = tall(Ds);
                fprintf("new tree size: "+gather(size(NewTree)));
                return 
        end
        CheckConfig = NewCheckConfig;
                
       
        
        
        
        
    end
end