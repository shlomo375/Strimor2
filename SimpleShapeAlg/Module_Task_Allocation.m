function Task = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, Addition)
arguments
    StartConfig
    TargetConfig
    Downwards
    Line
    Addition.AlphaDiff_Override (:,1) {mustBeInteger} = [];
    Addition.BetaDiff_Override (:,1) {mustBeInteger} = [];
    Addition.WS = [];
    Addition.ConfigShift = [];
    Addition.Side = "";
    Addition.DisableSwitch = false;
end
[AbsDiff, AlphaDiff, BetaDiff, Switch] = GetGroupConfigDiff(StartConfig,TargetConfig);
try
if numel(Addition.BetaDiff_Override) == 1 || numel(Addition.AlphaDiff_Override) == 1
    Temp = zeros(size(StartConfig));
    Temp(Line) = Addition.BetaDiff_Override;
    Addition.BetaDiff_Override = Temp;

    Temp = zeros(size(StartConfig));
    Temp(Line) = Addition.AlphaDiff_Override;
    Addition.AlphaDiff_Override = Temp;
end
catch mee3
    mee3
end
if ~isempty(Addition.AlphaDiff_Override) && ~isempty(Addition.BetaDiff_Override)
    AlphaDiff_Override_Log = logical(Addition.AlphaDiff_Override);
    AlphaDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);

    BetaDiff_Override_Log = logical(Addition.BetaDiff_Override);
    BetaDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
    
    if any(AlphaDiff_Override_Log)
        AbsDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);
    end
    if any(BetaDiff_Override_Log)
        AbsDiff(AlphaDiff_Override_Log) = AbsDiff(AlphaDiff_Override_Log) + Addition.BetaDiff_Override(BetaDiff_Override_Log);
    end
else
    if ~isempty(Addition.AlphaDiff_Override)
        AlphaDiff_Override_Log = logical(Addition.AlphaDiff_Override);
        AlphaDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);
        BetaDiff(AlphaDiff_Override_Log) = 0;
        AbsDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);
    end
    if ~isempty(Addition.BetaDiff_Override)
        BetaDiff_Override_Log = logical(Addition.BetaDiff_Override);
        BetaDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
        AlphaDiff(BetaDiff_Override_Log) = 0;
        AbsDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
    end
end


TopLine = find(StartConfig,1,"last");

DestenationLine_Alpha = max([0,find(AlphaDiff >= 1,1,"last")]);
DestenationLine_Beta = max([0,find(BetaDiff >= 1,1,"last")]);
% Dest = [DestenationLine_Alpha,DestenationLine_Beta];



% Switch edges
% several tasks at ones
if Switch(Line) && ~any(Addition.AlphaDiff_Override) && ~any(Addition.BetaDiff_Override)
    Task = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",Line,"Downwards",Downwards,"Type",0);
    return
end



% Remove modules 
    % Whole line - based the nuber of alpha in the top line
        if Line == TopLine && ...
                abs(AbsDiff(Line)) == abs(StartConfig(Line)) && ...
                AlphaDiff(Line) == -1
            Task = CreatTaskAllocationTable([],"ActionType","DeleteLine","Current_Line",Line,"Downwards",Downwards,"DestenationLine_Alpha",DestenationLine_Alpha,"DestenationLine_Beta",DestenationLine_Beta,"Side",Addition.Side);
            return
        
    % One module
        elseif AlphaDiff(Line) == -1 && BetaDiff(Line) >= 0
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Downwards",Downwards,"Type",1,"DestenationLine_Alpha",DestenationLine_Alpha,"Side",Addition.Side);
            return
        elseif BetaDiff(Line) == -1  && AlphaDiff(Line) >= 0
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",Line,"Downwards",Downwards,"Type",-1,"DestenationLine_Beta",DestenationLine_Beta,"Side",Addition.Side);
            return
    % Two module
        elseif AlphaDiff(Line) <= -1 && BetaDiff(Line) <= -1
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Current_Line_Beta",Line,"Downwards",Downwards,"Type",0,"DestenationLine_Alpha",DestenationLine_Alpha,"DestenationLine_Beta",DestenationLine_Beta,"Side",Addition.Side);
            return
        end

% Adding modules
if AlphaDiff(Line) > 0 || BetaDiff(Line) > 0
    Downwards = ~Downwards;
    StartingLine_Alpha = max([0,find(AlphaDiff(1:Line) <= -1,1,"last")]);
    StartingLine_Beta = max([0,find(BetaDiff(1:Line) <= -1,1,"last")]);
%     StartLine = [StartingLine_Alpha,StartingLine_Beta];
    
    % Adding modules
        % whole line
            if Line == (TopLine + 1) && ...
                    abs(StartConfig(Line)) == 0
                
                Task = CreatTaskAllocationTable([],"ActionType","CreateLine","Current_Line_Alpha",Line,"Current_Line_Beta",Line,"Downwards",Downwards,"Type",0,"DestenationLine",0,"Side",Addition.Side);
                return
        % One module
            elseif xor(AlphaDiff(Line) == 1,BetaDiff(Line) == 1)
%                 [GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(Addition.WS, Addition.ConfigShift,Downwards);
%                 Edges1 = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
                if ~Downwards
                    StartConfig = -flip(StartConfig);
                end
                Edges = Get_GroupEdges(StartConfig);
                DestenationLine = size(Edges,1)-(Line-1);
                
%                 Addition.Side = ["Left","Right"];
                if AlphaDiff(Line) == 1 && BetaDiff(Line) <= 0
                    ReqiuerdType = -1;
                else
                    ReqiuerdType = 1;
                end
                Direction = ["Left","Right"];
                switch Addition.Side
                    case "Left"
                        First_Left = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),1) == ReqiuerdType,1);
                        First_Right = inf;
                    case "Right"
                        First_Right = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),2) == ReqiuerdType,1);
                        First_Left = inf;
                    otherwise
                        First_Left = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),1) == ReqiuerdType,1);
                        First_Right = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),2) == ReqiuerdType,1);
                end

                [First_Line, DirLoc] = min([First_Left,First_Right]);
                if ReqiuerdType == -1
                    Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",First_Line,"Downwards",Downwards,"Type",-ReqiuerdType,"DestenationLine",DestenationLine,"Side",Direction(DirLoc));
                else
                    Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",First_Line,"Downwards",Downwards,"Type",-ReqiuerdType,"DestenationLine",DestenationLine,"Side",Direction(DirLoc));
                end
        % Two module
            elseif AlphaDiff(Line) >= 1 && BetaDiff(Line) >= 1
                DestenationLine = size(StartConfig,1)-(Line-1);
                StartLine = size(StartConfig,1)+1 - find(abs(StartConfig(1:Line-1))>=4,1,"last"); % When you need to bring 2 to fill a missing row, take from the closest row below it which has 4 modules or more.
                Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",StartLine,"Current_Line_Beta",StartLine,"Downwards",Downwards,"Type",0,"DestenationLine",DestenationLine,"Side",Addition.Side);
                return
            end
    Downwards = ~Downwards;
end

% Remove Alpha Add Beta

% Remove Beta Add Alpha







end





