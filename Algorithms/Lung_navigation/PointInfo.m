function PointsTable = PointInfo(p, SpaceSize,PointsInd, TargetCoord, Parent)

PointsTable = zeros(numel(PointsInd),p.MatrixSize(2));
[PointsTable(:,p.Sub(1)),PointsTable(:,p.Sub(2)),PointsTable(:,p.Sub(3))] = ind2sub(SpaceSize,PointsInd);
PointsTable(:,p.Ind) = PointsInd;

if nargin>=5
    PointsTable(:,p.PerentInd) = Parent(:,p.Ind);
    PointsTable(:,p.PathLength) = Parent(:,p.PathLength) + sum(abs((PointsTable(:,p.Sub) - Parent(:,p.Sub))),2);
end

PointsTable(:,p.TargetDis) = sum(abs(PointsTable(:,p.Sub) - [TargetCoord(2),TargetCoord(1),TargetCoord(3)]),2);

PointsTable(:,p.Cost) = PointsTable(:,p.PathLength) + p.CostRatio .* PointsTable(:,p.TargetDis);
end
