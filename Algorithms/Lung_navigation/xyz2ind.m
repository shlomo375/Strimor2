function [Ind,Sub] = xyz2ind(SpaceSize, Coord)
Sub = [Coord(2),Coord(1),Coord(3)];
Ind = sub2ind(SpaceSize,Coord(2),Coord(1),Coord(3));

end
