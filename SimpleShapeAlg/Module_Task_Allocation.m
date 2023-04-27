function ModuleTransitionData = Module_Task_Allocation(WS,StartConfig, TargetConfig, ConfigShift,Downwards, Line)

[AbsDiff, AlphaDiff, BetaDiff] = GetGroupConfigDiff(StartConfig,TargetConfig);
TopLine = find(StartConfig,1,"last");

DestenationLine_Alpha = find(AlphaDiff >= 1,1,"last");
DestenationLine_Beta = find(BetaDiff >= 1,1,"last");
Dest = [DestenationLine_Alpha,DestenationLine_Beta];

StartingLine_Alpha = find(AlphaDiff <= -1,1,"last");
StartingLine_Beta = find(BetaDiff <= -1,1,"last");
StartLine = [StartingLine_Alpha,StartingLine_Beta];
%% Possible situations
% Each module that comes down knows its future location
% "Current_Line","Module_Num","Side","Downwards","Finish","Sequence","DestenationLine","Type","ActionType"
% Remove modules 
    % Whole line - based the nuber of alpha in the top line
        if Line == TopLine && ...
                abs(AbsDiff(Line)) == abs(StartConfig(Line)) && ...
                AlphaDiff(Line) == -1
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","DeleteLine","Current_Line",Line,"Downwards",Downwards,"DestenationLine",Dest);
        
    % One module
        elseif AlphaDiff(Line) == -1 && BetaDiff(Line) >= 0
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","ReduceLine","Current_Line",Line,"Downwards",Downwards,"Type",1,"DestenationLine",Dest(1));
        elseif BetaDiff(Line) == -1  && AlphDiff(Line) >= 0
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","ReduceLine","Current_Line",Line,"Downwards",Downwards,"Type",-1,"DestenationLine",Dest(2));
    % Two module
        elseif AlphaDiff(Line) <= -1 && BetaDiff(Line) <= -1
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","ReduceLine","Current_Line",Line,"Downwards",Downwards,"Type",0,"DestenationLine",Dest);

% Adding modules
    % whole line
        elseif Line == (TopLine + 1) && ...
                abs(StartConfig(Line)) == 0
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","CreateLine","Current_Line",StartLine,"Downwards",Downwards,"Type",0,"DestenationLine",Line);
    % One module
        elseif AlphaDiff(Line) == 1 && BetaDiff(Line) <= 0
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","AddModule","Current_Line",StartLine(1),"Downwards",Downwards,"Type",1,"DestenationLine",Line);
        elseif AlphaDiff(Line) <= 0 && BetaDiff(Line) == 1
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","AddModule","Current_Line",StartLine(2),"Downwards",Downwards,"Type",-1,"DestenationLine",Line);
    % Two module
        elseif AlphaDiff(Line) >= 1 && BetaDiff(Line) >= 1
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","AddModule","Current_Line",StartLine,"Downwards",Downwards,"Type",0,"DestenationLine",Line);


% Switch edges
    % several tasks at ones
        elseif StartConfig(Line) == - TargetConfig(Line)
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",Line,"Downwards",Downwards,"Type",0);
        end




end





