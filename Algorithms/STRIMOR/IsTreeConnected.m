function [Node, Path,PathLength, Connected2Tree] = IsTreeConnected(TreeFolder, FolderList)
PathLength = [];
Node = [];
Path = [];
Connected2Tree =[];
ds = fileDatastore(TreeFolder,"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
ds.Files(~contains(ds.Files,"size")) = [];
Tree = readall(ds); 

for idx_FolderList = 1:numel(FolderList)
    if matches(FolderList(idx_FolderList),TreeFolder)
        continue
    end
    try
        Ds = fileDatastore(FolderList(idx_FolderList),"IncludeSubfolders",false,"ReadFcn",@LoadTableFromMAT,'PreviewFcn',@LoadTableFromMATPreview,'UniformRead',true);
    catch e
        e
    end
        [Connect, ConnectedNode] = CompareMixsedTree2TreeFiles(Tree,Ds);
    if Connect
        for jj = 1:size(ConnectedNode,1)
            [PL, P] = Get2TreesPath(ds,Ds, ConnectedNode(jj,:));
            if PL ~=-1
                Path = [Path;P];
                PathLength = [PathLength; PL];
                Node = [Node;ConnectedNode(jj,:)];
                Connected2Tree = [Connected2Tree;FolderList(idx_FolderList)];
                return
            end
        end        
    end

end
end
