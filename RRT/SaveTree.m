function Tree = SaveTree(FileName, Tree)
ArrayLength = length(Tree)    

t = datetime('now','TimeZone','local','Format','d_MMM_y_HH_mm_ss');
    Tree([Tree.Index] == 0) = [];
    save("RRTtree\30N\"+FileName +"__" + string(t)+'.mat',"Tree",'-nocompression');
    
    fprintf('%s\n',string(length(Tree))+" config was save in time: "+ string(t));
    
    if nargin>2
        Tree = CreatTreeArray(ArrayLength);
    end
    
end

