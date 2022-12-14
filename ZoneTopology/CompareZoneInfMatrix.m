function Match = CompareZoneInfMatrix(ZoneMatrix1,ZoneMatrix2)
if size(ZoneMatrix1,3) == 3
    ZoneMatrix1 = ZoneMatrix1(:,:,2:3);
end

if size(ZoneMatrix2,3) == 3
    ZoneMatrix2 = ZoneMatrix2(:,:,2:3);
end

Match = false;

D_Zone = ZoneMatrix1 - ZoneMatrix2;
D_Zone(isinf(D_Zone)) = 0;
D_Zone(isnan(D_Zone)) = 0;


if ~sum(D_Zone,"all")
    Match = true;
end

end
