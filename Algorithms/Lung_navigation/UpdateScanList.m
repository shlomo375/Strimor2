function [Tree, ScannedSpace] = UpdateScanList(p,Tree,ScannedSpace,NewPointsTable, NewPointsInd)
% NewPointsInd.IndFiltered(ScannedSpace.Full(NewPointsInd.IndFiltered)) = [];

if ~isempty(NewPointsInd.IndFiltered)
    [~,ScanPointInTree] = ismember(NewPointsInd.IndFiltered,Tree.Data(:,p.Ind));
    
    if ~isempty(Tree.Scan)
        ClosedPointLogical = any(sqrt(sum((pagemtimes(cat(2,ones(numel(ScanPointInTree),1,3),permute(Tree.Data(ScanPointInTree,p.Sub),[1,3,2])), cat(1,permute(Tree.Scan(:,p.Sub),[3,1,2]),-ones(1,size(Tree.Scan,1),3)))).^2,3))<p.DeleteScanedPointZone,2);
        Tree.Scan = unique([Tree.Scan; Tree.Data(ScanPointInTree(~ClosedPointLogical),:)],"rows");
        
        ScannedSpace.Scan(NewPointsInd.IndFiltered(~ClosedPointLogical)) = true;
    else
        Tree.Scan = unique([Tree.Scan; Tree.Data(ScanPointInTree,:)],"rows");
        ScannedSpace.Scan(NewPointsInd.IndFiltered) = true;
    end
    
    ScannedSpace.Full(NewPointsInd.Ind) = true;
    
end



end
