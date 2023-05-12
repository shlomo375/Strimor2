function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Task] = Switch_Alpha_Beta_to_Beta_Alpha(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,MovmentDirection,Downwards,Tree,TopLineIdx)
Step = [];
Axis = [];
Task = [];


if ~isempty(Edges)
    NotTested
    
    GroupSizeRequired = [3,4];
    [OK, Task] = GroupSizeAsNeeded(GroupsSizes,TargetGroupSize,GroupSizeRequired,Line,Task.Downwards);
    if ~OK
        % Task_Queue(end+1,:) = Task;
        return
    end
    
    Top_Step = floor(Side_Sign*((Edges(2,2,Line-1)-(Edges(3,2,Line-1)==1)) - (Edges(2,2,Line)-(Edges(3,2,Line)==-1))/2));
    TopBottom_Step = floor(Side_Sign*((Edges(2,1,Line-2)+(Edges(3,1,Line-2)==1)) - (Edges(2,2,Line-1)-(Edges(3,2,Line-1)==-1)))/2);
    Step = [TopBottom_Step,Top_Step];
    Axis = [1,1];
    % Position_relative_buttom_group = [1;- 1];
    % [Step, Axis] = ArangeGroupLocations(MovmentDirection,Edges,Position_relative_buttom_group);
 
    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Top(1:2,:) = true;
end

Step = [Step, 1];
Axis = [Axis, 2];

Moving_Log_Buttom(3,1:2) = true;
Moving_Log_Top(3,1:3) = true;



end



function [OK, Task] = GroupSizeAsNeeded(GroupSize,TargetGroupSize,GroupSizeRequired,SwitchLine,Downwards)

OK = true;
Task = [];
if abs(GroupSize(SwitchLine)) < abs(GroupSizeRequired(1))
    Addition = abs(GroupSizeRequired(1)) - abs(GroupSize(SwitchLine));
    if Addition >= 2
        AlphaDiff = 1;
        BetaDiff = 1;
    elseif EndIsAlpha(GroupSize(SwitchLine))
        BetaDiff = 1;
        AlphaDiff = 0;
    else
        AlphaDiff = 1;
        BetaDiff = 0;
    end
    OK = false;
    Task = Module_Task_Allocation(GroupSize, TargetGroupSize, ~Downwards, SwitchLine, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
    return 

elseif abs(GroupSize(SwitchLine+1)) < abs(GroupSizeRequired(2)) || GroupSize(SwitchLine+1) == -GroupSizeRequired(2) 
    
    Addition = abs(GroupSizeRequired(2)) - abs(GroupSize(SwitchLine+1));
    if Addition >= 2
        AlphaDiff = 1;
        BetaDiff = 1;
    elseif EndIsAlpha(GroupSize(SwitchLine+1))
        BetaDiff = 1;
        AlphaDiff = 0;
    else
        AlphaDiff = 1;
        BetaDiff = 0;
    end
    OK = false;
    Task = Module_Task_Allocation(GroupSize, TargetGroupSize, ~Downwards, SwitchLine+1, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);
    return

end
end