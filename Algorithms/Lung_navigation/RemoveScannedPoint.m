function ScannedList = RemoveScannedPoint(P,ScannedList, Point)
sum(abs(Point(P.Sub) - ScannedList(:,P.Sub)),2);
ScannedList(sum(abs(Point(P.Sub) - ScannedList(:,P.Sub)),2)<=P.DeleteScanedPointZone,:) = [];


end
