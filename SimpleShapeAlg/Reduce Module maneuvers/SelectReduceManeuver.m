function [ManeuversRequired, Direction] = SelectReduceManeuver(Three_Line_Edges)

LineEdgesLeft = join(string([Three_Line_Edges(3,1,3), ...
                             Three_Line_Edges(3,1,2)]),"_");
LineEdgesRight = join(string([Three_Line_Edges(3,2,3), ...
                              Three_Line_Edges(3,2,2)]),"_");

Right = join([LineEdgesRight.replace("-1","Beta").replace("1","Alpha")],"");
Left = join([LineEdgesLeft.replace("-1","Beta").replace("1","Alpha")],"");

ManeuversRequired{2} = str2func(Right);
Direction(2) = "Right";

ManeuversRequired{1} = str2func(Left);
Direction(1) = "Left";

end