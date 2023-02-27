function [ZoneInd, ZoneSubX, ZoneSubY, ZoneSubZ]  = GetZoneInd(Space,CenterLoc,ZoneSize)

% CenterLoc = CrossingBorder(Space,CenterLoc);

ZoneRange = (ZoneSize-1)./2;
ZoneX = (-ZoneRange(1):ZoneRange(1)).*ones(ZoneSize,1,3);
ZoneY = permute(ZoneX,[2,1,3]);
ZoneZ = permute(-ZoneRange(1):ZoneRange(1),[1,3,2]).*ones(ZoneSize);


CenterLoc3d = round(permute(CenterLoc,[4,2,3,1]));
ZoneSubX = ZoneX + CenterLoc3d(1,1,1,:);
ZoneSubY = ZoneY + CenterLoc3d(1,2,1,:);
ZoneSubZ = ZoneZ + CenterLoc3d(1,3,1,:);

ZoneInd = sub2ind(size(Space),ZoneSubY,ZoneSubX,ZoneSubZ);

end
