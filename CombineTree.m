%% combine trees
clear
addpath(genpath('C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles'));
% FolderFile = "RRTtree\36N\FolderFile.mat";
% 
% load(FolderFile,'Folders');

% MainTree = extractBefore(Folders(1),"_");
files = dir("RRTtree\36N");
D = ["RRTtree\36N\Car","RRTtree\36N\Line","RRTtree\36N\Rotated","RRTtree\36N\Shape"];
W = ["RRTtree\36N\Car\CarTree","RRTtree\36N\Line\LineTree","RRTtree\36N\Rotated\RotatedLineTree","RRTtree\36N\Shape\ShapeTree"];
ff{1} = dir("RRTtree\36N\Car");
ff{2} = dir("RRTtree\36N\Line");
ff{3} = dir("RRTtree\36N\Rotated");
ff{4} = dir("RRTtree\36N\Shape");
fprintf("start...")
for kk = 3:numel(ff)
    files = ff{kk};
    files = files(contains({files.name},digitsPattern,"IgnoreCase",true));
%     files = files(~contains({files.name},"1","IgnoreCase",true));
    for ii = 1:numel(files)
        ds = fileDatastore(D(kk)+"\"+files(ii).name,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
        ds.Files = ds.Files(contains(ds.Files,"size"));
        
        FilesName = ds.Files;
        FolderName = D(kk)+"\"+extractBefore(files(ii).name,"_");
        f=files(ii).name;
        for jj = numel(FilesName):-1:1  
%             flag = 1;
    %         while flag
    %             try
                    FileData = struct2cell(load(FilesName{jj},"FileData"));
                    FileData = FileData{:};
            %         Tree.Data = FileData;
            %         clear FileData;
            
                    TreeClass.CombineTrees(FileData,FolderName,f,jj);
                    delete(FilesName{jj});
                    flag = 0;
    %             catch e
    %                 disp(e)
    %             end
    %         end
        end
        ds = fileDatastore(W(kk),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
        ds.Files = ds.Files(contains(ds.Files,"size"));
%         try
            Tall = tall(ds);
            s = gather(size(Tall));
            fprintf("tree size: "+string(s(1)));
            rmdir(D(kk)+"\"+files(ii).name,"s");

            BeckupFolder = insertAfter(D(kk),"N\","Beckup\");
%             try
                rmdir(BeckupFolder,"s");
%             catch
%             end
            fprintf("coping file...\n");
            copyfile(D(kk),BeckupFolder)
%         catch e
%             disp(e)
%             pause
%         end
        
        
    
    end

end

