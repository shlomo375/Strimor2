function CentralArea = CenterOfArea(Map)
[y,x] = find(Map);
Xc = round(sum(x)./sum(Map>0,'all'));
Yc = round(sum(y)./sum(Map>0,'all'));

CentralArea = sub2ind(size(Map),Yc,Xc);
end
