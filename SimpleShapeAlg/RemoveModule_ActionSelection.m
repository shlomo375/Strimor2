function [Decision, varargout] = RemoveModule_ActionSelection(Three_Line_GroupsSizes, Three_Line_TargetGroupSizes, Three_Line_Edges,GroupNum)

if Three_Line_GroupsSizes(3,GroupNum) > 2 || Three_Line_GroupsSizes(3,GroupNum) < -3
    [AlphaDiff, BetaDiff] = GetGroupConfigDiff(Three_Line_GroupsSizes,Three_Line_TargetGroupSizes);
    Decision = "Remove Module";
    if xor(abs(AlphaDiff(1)) == 1,abs(BetaDiff(1)) == 1) 
       Num_Removed_Module = 1;
    else
       Num_Removed_Module = 2;
    end
    varargout{1} = Num_Removed_Module;

else % Total line remove

    [Decision, varargout{1}] = CheapManeuver(Three_Line_Edges,GroupNum,Three_Line_GroupsSizes(3,GroupNum));
    Num_Removed_Module = Three_Line_GroupsSizes(1);
    
end

if abs(Three_Line_TargetGroupSizes(2)) - abs(Three_Line_GroupsSizes) >= Num_Removed_Module
    varargout{2} = true;
else
    varargout{2} = false;
end

end



function [ManeuverRequired, Direction] = CheapManeuver(Three_Line_Edges,GroupNum,NumModule_TopLine)

Maneuver_Cost = struct("Alpha_Alpha_Alpha__1",100,...
                       "Alpha_Alpha_Alpha__2",2,...
                       ...
                       "Alpha_Alpha_Beta__1",7,...
                       "Alpha_Alpha_Beta__2",2,...
                       ...
                       "Alpha_Beta_Alpha__1",6,...
                       "Alpha_Beta_Alpha__2",1,...
                        ...
                       "Alpha_Beta_Beta__1",1,...
                       "Alpha_Beta_Beta__2",3,...
                        ...
                        ...
                        ...
                       "Beta_Alpha_Alpha__2",4,...
                       "Beta_Alpha_Alpha__3",1,...
                       ...
                       "Beta_Alpha_Beta__2",3,...
                       "Beta_Alpha_Beta__3",2,...
                       ...
                       "Beta_Beta_Alpha__2",4,...
                       "Beta_Beta_Alpha__3",1,...
                       ...
                       "Beta_Beta_Beta__2",1,...
                       "Beta_Beta_Beta__3",100);

LineEdgesLeft = join(string([Three_Line_Edges{3,GroupNum}(3,1), ...
                                 Three_Line_Edges{2,GroupNum}(3,1), ...
                                 Three_Line_Edges{1,GroupNum}(3,1)]),"");
LineEdgesRight = join(string([Three_Line_Edges{3,GroupNum}(3,2), ...
                             Three_Line_Edges{2,GroupNum}(3,2), ...
                             Three_Line_Edges{1,GroupNum}(3,2)]),"");
Right = join([join([LineEdgesRight,"_"],"").replace("-1","Beta_").replace("1","Alpha_"),string(NumModule_TopLine)],"");
Left = join([join([LineEdgesLeft,"_"],"").replace("-1","Beta_").replace("1","Alpha_"),string(NumModule_TopLine)],"");

if Maneuver_Cost.(Right) < Maneuver_Cost.(Left)
    ManeuverRequired = str2func(Right);
    Direction = "Right";
else
    ManeuverRequired = str2func(Left);
    Direction = "Left";
end

end

