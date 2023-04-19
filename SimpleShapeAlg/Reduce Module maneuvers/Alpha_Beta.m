function [Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Direction] = Alpha_Beta(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Direction,GroupsNum)

arguments
    Moving_Log_Top
    Moving_Log_Mid
    Moving_Log_Buttom
    Edges
    Direction
    GroupsNum = ones(numel(Edges),1);
end

if ~isempty(Edges)
    Reletive_Position = [-1;-2;2];
    [Step, Axis, Direction] = Select_Direction_Compute_Step(Direction,Edges,Reletive_Position,GroupsNum);
    

    Moving_Log_Buttom(1,:) = true;
    Moving_Log_Mid(1:2,:) = true;
    Moving_Log_Top(1:3,:) = true;
end

Step = [Step,1];
Axis = [Axis, 2];

Moving_Log_Mid(3,1) = true;

end