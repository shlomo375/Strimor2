function ModuleTransitionData = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, Addition)
arguments
    StartConfig
    TargetConfig
    Downwards
    Line
    Addition.AlphaDiff_Override (:,1) {mustBeInteger} = [];
    Addition.BetaDiff_Override (:,1) {mustBeInteger} = [];
    Addition.WS = [];
    Addition.ConfigShift = [];
end
[AbsDiff, AlphaDiff, BetaDiff] = GetGroupConfigDiff(StartConfig,TargetConfig);

if ~isempty(Addition.AlphaDiff_Override)
    AlphaDiff_Override_Log = logical(Addition.AlphaDiff_Override);
    AlphaDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);
    BetaDiff(AlphaDiff_Override_Log) = 0;
    AbsDiff(AlphaDiff_Override_Log) = Addition.lphaDiff_Override(AlphaDiff_Override_Log);
end
if ~isempty(Addition.BetaDiff_Override)
    BetaDiff_Override_Log = logical(Addition.BetaDiff_Override);
    BetaDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
    AlphaDiff(BetaDiff_Override_Log) = 0;
    AbsDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
end


TopLine = find(StartConfig,1,"last");

DestenationLine_Alpha = find(AlphaDiff >= 1,1,"last");
DestenationLine_Beta = find(BetaDiff >= 1,1,"last");
Dest = [DestenationLine_Alpha,DestenationLine_Beta];

% Remove modules 
    % Whole line - based the nuber of alpha in the top line
        if Line == TopLine && ...
                abs(AbsDiff(Line)) == abs(StartConfig(Line)) && ...
                AlphaDiff(Line) == -1
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","DeleteLine","Current_Line",Line,"Downwards",Downwards,"DestenationLine_Alpha",Dest(1),"DestenationLine_Beta",Dest(2));
        
    % One module
        elseif AlphaDiff(Line) == -1 && BetaDiff(Line) >= 0
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Downwards",Downwards,"Type",1,"DestenationLine_Alpha",Dest(1));
        elseif BetaDiff(Line) == -1  && AlphaDiff(Line) >= 0
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",Line,"Downwards",Downwards,"Type",-1,"DestenationLine_Beta",Dest(2));
    % Two module
        elseif AlphaDiff(Line) <= -1 && BetaDiff(Line) <= -1
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Current_Line_Beta",Line,"Downwards",Downwards,"Type",0,"DestenationLine_Alpha",Dest(1),"DestenationLine_Beta",Dest(2));
        end

% Adding modules
if AlphaDiff(Line) >= 0 && BetaDiff(Line) >= 0 
    Downwards = ~Downwards;
    StartingLine_Alpha = find(AlphaDiff <= -1,1,"last");
    StartingLine_Beta = find(BetaDiff <= -1,1,"last");
    StartLine = [StartingLine_Alpha,StartingLine_Beta];
    
    % Adding modules
        % whole line
            if Line == (TopLine + 1) && ...
                    abs(StartConfig(Line)) == 0
                ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","CreateLine","Current_Line_Alpha",StartLine(1),"Current_Line_Beta",StartLine(2),"Downwards",Downwards,"Type",0,"DestenationLine",Line);
        % One module
            elseif xor(AlphaDiff(Line) == 1,BetaDiff(Line) == 1)
                [GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(Addition.WS, Addition.ConfigShift,Downwards);
                Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
                
                DestenationLine = size(Edges,3)-(Line-1);
                
                Direction = ["Left","Right"];
                if AlphaDiff(Line) == 1 && BetaDiff(Line) <= 0
                    First_Left = DestenationLine-1 + find(Edges(3,1,DestenationLine:size(Edges,3)) == -1,1);
                    First_Right = DestenationLine-1 + find(Edges(3,2,DestenationLine:size(Edges,3)) == -1,1);
                    [First_Line, DirLoc] = min([First_Left,First_Right]);

                    ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",First_Line,"Downwards",Downwards,"Type",1,"DestenationLine",DestenationLine,"Side",Direction(DirLoc));
                elseif AlphaDiff(Line) <= 0 && BetaDiff(Line) == 1
                    First_Left = DestenationLine-1 + find(Edges(3,1,DestenationLine:size(Edges,3)) == 1,1);
                    First_Right = DestenationLine-1 + find(Edges(3,2,DestenationLine:size(Edges,3)) == 1,1);
                    [First_Line, DirLoc] = min([First_Left,First_Right]);

                    ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",First_Line,"Downwards",Downwards,"Type",-1,"DestenationLine",DestenationLine,"Side",Direction(DirLoc));
                end

        % Two module
            elseif AlphaDiff(Line) >= 1 && BetaDiff(Line) >= 1
                ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",StartLine(1),"Current_Line_Beta",StartLine(2),"Downwards",Downwards,"Type",0,"DestenationLine",Line);
            end

end

% Remove Alpha Add Beta

% Remove Beta Add Alpha


% Switch edges
    % several tasks at ones
        if StartConfig(Line) == - TargetConfig(Line)
            ModuleTransitionData = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",Line,"Downwards",Downwards,"Type",0);
        end




end





