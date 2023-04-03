function [Step, Axis, All_Module_Ind, Moving_Log] = ExecuteManuver(ManuverHandle, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Right_Left,Up_Down)

if matches(Right_Left,"Right")
    Top_GroupInd = flip(Top_GroupInd);
    Mid_GroupInd = flip(Mid_GroupInd);
    Buttom_GroupInd = flip(Buttom_GroupInd);
end

if matches(Up_Down,"Down")
    Temp = Top_GroupInd;
    Top_GroupInd = Buttom_GroupInd;
    Buttom_GroupInd = Top_GroupInd;
    Edges = flip(Edges,1);
end

Moving_Log_Top = false(4,numel(Top_GroupInd));
Moving_Log_Mid = false(4,numel(Mid_GroupInd));
Moving_Log_Buttom = false(4,numel(Buttom_GroupInd));
All_Module_Ind = [Top_GroupInd, Mid_GroupInd, Buttom_GroupInd];


[Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom] = ManuverHandle(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges);


Moving_Log = [Moving_Log_Top;Moving_Log_Mid;Moving_Log_Buttom];

if matches(Right_Left,"Right")
    Step = -Step;
    if matches(Up_Down,"Up") 
        NewAxis = Axis;
        NewAxis(Axis==2) = 3;
        NewAxis(Axis==3) = 2;
        Axis = NewAxis;
    end
else
    if matches(Up_Down,"Down")
        NewAxis = Axis;
        NewAxis(Axis==2) = 3;
        NewAxis(Axis==3) = 2;
        Axis = NewAxis;
    end
end




end
