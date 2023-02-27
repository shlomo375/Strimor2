function [Path, PathCost] = BestPath(P,Tree, ScannedSpace,Volume)
Path = zeros(1000,P.MatrixSize(2));
idx = 1;
dir = 1;
queryPoints = [];
[PathCost, PointLoc] = min(Tree.Data(1:Tree.LastIndex,P.Cost));

Point = Tree.Data(PointLoc,:);
Path(idx,:) = Point;

while Point(1,P.PerentInd)
    idx = idx+1;
    ParentPoint = Tree.Data(Tree.Data(:,P.Ind)==Point(P.PerentInd),:);
    Path(idx,:) = ParentPoint;
    Point = ParentPoint;

    if  Point(P.Sub(1)) > Path(idx-1,P.Sub(1))
        dir = -1;
    end
    queryPoints = [queryPoints, Point(P.Sub(1)):dir:Path(idx-1,P.Sub(1))];
end

Path(~Path(:,1),:) = [];
X=[];
Y=[];
Z=[];
if size(Path,1)>1
    YPath = Path(:,P.Sub(1));
    XPath = Path(:,P.Sub(2));
    ZPath = Path(:,P.Sub(3));
    
    
    for ii = 1:numel(XPath)-1
        
        X = [X,round(linspace(XPath(ii),XPath(ii+1),30))];
        Y = [Y,round(linspace(YPath(ii),YPath(ii+1),30))];
        Z = [Z,round(linspace(ZPath(ii),ZPath(ii+1),30))];
    end
        
    
    PathInd = sub2ind(P.SapceSize,Y,X,Z);
    
    ScannedSpace(PathInd) = 2;
    S = zeros(size(ScannedSpace));
    S(PathInd)=2;
    
    ShowValume(S,Volume);
end
end
