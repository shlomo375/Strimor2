function [NewPoints, Point]  = AgentLineOfSight(P,Space, Point,Lines, AngleMap, UnitVecList)

Lines.FullSub = Lines.FullSub + Point(P.Sub);


[FirstWhitePixel,NewPoints, LinesInd] = FindWhitePixel(Space,round(Lines.FullSub),Lines.FilterInd,P.SpaceThreshold);

ClearLineLength = sum(FirstWhitePixel,4)-2;

[Point(1,P.VecMagnitude),LengthRepetitionInd] = max(permute(ClearLineLength,[5,1,2,3,4]),[],2);

Point(1,P.UnitVec) = UnitVecList(LengthRepetitionInd,:);
%%
OrthogonalVectorInd = AngleMap(LengthRepetitionInd,2:end);
Point(1,P.Diameter) = min(ClearLineLength(OrthogonalVectorInd)); 

end
