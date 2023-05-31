function [Step, Axis, All_Module_Ind, Moving_Log, NewTask] = ComputeManuver(ManuverHandle, Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,Edges,Side,Task,Tree)

% if ~Downwards
%     Temp = Top_GroupInd;
%     Top_GroupInd = Buttom_GroupInd;
%     Buttom_GroupInd = Top_GroupInd;
%     Edges = flip(Edges,1);
% end
All_Module_Ind = [];
Moving_Log = []; 

Moving_Log_Top = false(4,numel(Top_GroupInd));
Moving_Log_Mid = false(4,numel(Mid_GroupInd));
Moving_Log_Buttom = false(4,numel(Buttom_GroupInd));



[Step, Axis, Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom, NewTask] = ManuverHandle(Moving_Log_Top,Moving_Log_Mid,Moving_Log_Buttom,Edges,Side,Task.Downwards,Tree,Task.Current_Line,Task.Module_Num);

if size(NewTask,1)
    return
end

NumStep = length(Step);
Moving_Log_Top = [Moving_Log_Top; false(NumStep-size(Moving_Log_Top,1),size(Moving_Log_Top,2))];
Moving_Log_Mid = [Moving_Log_Mid; false(NumStep-size(Moving_Log_Mid,1),size(Moving_Log_Mid,2))];
Moving_Log_Buttom = [Moving_Log_Buttom; false(NumStep-size(Moving_Log_Buttom,1),size(Moving_Log_Buttom,2))];

Moving_Log = [Moving_Log_Top, Moving_Log_Mid, Moving_Log_Buttom];



if matches(Side,"Right")
    Step = -Step;
    if Task.Downwards 
        NewAxis = Axis;
        NewAxis(Axis==2) = 3;
        NewAxis(Axis==3) = 2;
        Axis = NewAxis;
    end
else
    if ~Task.Downwards
        NewAxis = Axis;
        NewAxis(Axis==2) = 3;
        NewAxis(Axis==3) = 2;
        Axis = NewAxis;
    end
end


%%
if matches(Side,"Right")
    Top_GroupInd = flip(Top_GroupInd);
    Mid_GroupInd = flip(Mid_GroupInd);
    Buttom_GroupInd = flip(Buttom_GroupInd);
end
All_Module_Ind = [Top_GroupInd, Mid_GroupInd, Buttom_GroupInd];
%%
RemoveStep = ~Step;
Step(RemoveStep) = [];
Axis(RemoveStep) = [];
Moving_Log(RemoveStep,:) = [];
ReducedModuleNum = sum(Moving_Log(end,:));
end
