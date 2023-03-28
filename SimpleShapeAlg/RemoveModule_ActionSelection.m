function [Decision, varargout] = RemoveModule_ActionSelection(Three_Line_GroupsSizes, Three_Line_TargetGroupSize, Three_Line_Edges,GroupNum)

if Three_Line_GroupSize(1,GroupNum) > 2 || Three_Line_GroupSize(1,GroupNum) < -3
    [AlphaDiff, BetaDiff] = GetGroupConfigDiff(Three_Line_GroupsSizes,Three_Line_TargetGroupSize);
    Decision = "Remove Module";
    if xor(abs(AlphaDiff(1)) == 1,abs(BetaDiff(1)) == 1) 
       Num_Removed_Module = 1;
    else
       Num_Removed_Module = 2;
    end
    varargout{1} = Num_Removed_Module;
else % Toltal remove

end


end
