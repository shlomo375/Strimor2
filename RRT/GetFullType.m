function FullType = GetFullType(ConfigMat,Type)
TypeLoc = find(logical(ConfigMat),1);
Size = size(ConfigMat);
r = ones(Size(1),1);
r(1:2:end) = -1;
c = ones(1,Size(2));
c(1:2:end) = -1;
FullType = r.*c;
if Type ~= FullType(TypeLoc)
    FullType = FullType*-1;
end
end
