function Task = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Line, Addition)
arguments
    StartConfig
    TargetConfig
    Downwards
    Line
    Addition.AlphaDiff_Override (:,1) {mustBeInteger} = false(size(StartConfig));
    Addition.BetaDiff_Override (:,1) {mustBeInteger} = false(size(StartConfig));
    Addition.WS = [];
    Addition.ConfigShift = [];
    Addition.Side = "";
    Addition.DisableSwitch = false;
    Addition.Task = [];
end
[AbsDiff, AlphaDiff, BetaDiff, Switch] = GetGroupConfigDiff(StartConfig,TargetConfig);

if numel(Addition.BetaDiff_Override) == 1 || numel(Addition.AlphaDiff_Override) == 1
    Temp = zeros(size(StartConfig));
    Temp(Line) = Addition.BetaDiff_Override;
    Addition.BetaDiff_Override = Temp;

    Temp = zeros(size(StartConfig));
    Temp(Line) = Addition.AlphaDiff_Override;
    Addition.AlphaDiff_Override = Temp;
end

if any(Addition.AlphaDiff_Override) && any(Addition.BetaDiff_Override)
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
    if any(Addition.AlphaDiff_Override)
        AlphaDiff_Override_Log = logical(Addition.AlphaDiff_Override);
        AlphaDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);
        BetaDiff(AlphaDiff_Override_Log) = 0;
        AbsDiff(AlphaDiff_Override_Log) = Addition.AlphaDiff_Override(AlphaDiff_Override_Log);
    end
    if any(Addition.BetaDiff_Override)
        BetaDiff_Override_Log = logical(Addition.BetaDiff_Override);
        BetaDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
        AlphaDiff(BetaDiff_Override_Log) = 0;
        AbsDiff(BetaDiff_Override_Log) = Addition.BetaDiff_Override(BetaDiff_Override_Log);
    end
end


% Switch edges
% several tasks at ones
if Switch(Line) && ~any(Addition.AlphaDiff_Override) && ~any(Addition.BetaDiff_Override)
    Task = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",Line,"Downwards",Downwards,"Type",0);
    return
end


TopLine = find(StartConfig,1,"last");

DestenationLine = max([0,find(AlphaDiff >= 1 | BetaDiff >= 1,1,"last")]);

if ~DestenationLine
    DestenationLine = Line - 1;
end

AddNewLine = false;
if ~StartConfig(DestenationLine)
    LineToCreate = DestenationLine;
    DestenationLine = DestenationLine + Downwards - (~Downwards);
    
    AddNewLine = true;
end
ReturnFlag = false;
% Remove modules 
    % Whole line - based the nuber of alpha in the top line
        if Line == TopLine && ...
                abs(AbsDiff(Line)) == abs(StartConfig(Line)) && ...
                AlphaDiff(Line) == -1 && BetaDiff(Line) >= -1
            % Task = CreatTaskAllocationTable([],"ActionType","DeleteLine","Current_Line",Line,"Downwards",Downwards,"DestenationLine_Alpha",DestenationLine_Alpha,"DestenationLine_Beta",DestenationLine_Beta,"Side",Addition.Side);
            Task = CreatTaskAllocationTable([],"ActionType","DeleteLine","Current_Line",Line,"Downwards",Downwards,"DestenationLine_Alpha",DestenationLine,"DestenationLine_Beta",DestenationLine,"Side",Addition.Side);
            ReturnFlag = true;
        elseif Line == TopLine && ...
                abs(AbsDiff(Line)) == abs(StartConfig(Line)) && ...
                AlphaDiff(Line) == -1 && BetaDiff(Line) == -2
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",Line,"Downwards",Downwards,"Type",-1,"DestenationLine_Beta",Line-1,"Side",Addition.Side);
            ReturnFlag = true;
        
    % One module
        elseif AlphaDiff(Line) <= -1 && BetaDiff(Line) >= 0
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Downwards",Downwards,"Type",1,"DestenationLine_Alpha",Line-1,"Side",Addition.Side);
            % ReturnFlag = true;
            return
            
        elseif BetaDiff(Line) <= -1  && AlphaDiff(Line) >= 0
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",Line,"Downwards",Downwards,"Type",-1,"DestenationLine_Beta",Line-1,"Side",Addition.Side);
            % ReturnFlag = true;
            return
            
    % Two module
        elseif AlphaDiff(Line) <= -1 && BetaDiff(Line) <= -1
            % Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Current_Line_Beta",Line,"Downwards",Downwards,"Type",0,"DestenationLine_Alpha",DestenationLine_Alpha,"DestenationLine_Beta",DestenationLine_Beta,"Side",Addition.Side);
            if Line < DestenationLine
                Downwards = ~Downwards;
                Line = size(StartConfig,1)-(Line-1);
                DestenationLine = size(StartConfig,1)-(DestenationLine-1);
            end
            Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",Line,"Current_Line_Beta",Line,"Downwards",Downwards,"Type",0,"DestenationLine_Alpha",DestenationLine,"DestenationLine_Beta",DestenationLine,"Side",Addition.Side);
            ReturnFlag = true;
            
        end
        if ReturnFlag && AddNewLine
            % if Task.DestenationLine_Beta
            %     Task.DestenationLine_Beta = Task.DestenationLine_Beta+1;
            % end
            % if Task.DestenationLine_Alpha
            %     Task.DestenationLine_Alpha = Task.DestenationLine_Alpha+1;
            % end
            % if Task.DestenationLine
            %     Task.DestenationLine = Task.DestenationLine+1;
            % end
            Task(2,:) = Task;
            LineToCreate = numel(StartConfig)-LineToCreate+1;
            Task(1,:) = CreatTaskAllocationTable([],"ActionType","CreateLine","Current_Line_Alpha",LineToCreate,"Current_Line_Beta",LineToCreate,"Downwards",~Downwards,"Type",0,"DestenationLine",0,"Side",Addition.Side);

        end

% Adding modules
if AlphaDiff(Line) > 0 || BetaDiff(Line) > 0
    Downwards = ~Downwards;
    % StartingLine_Alpha = max([0,find(AlphaDiff(1:Line) <= -1,1,"last")]);
    % StartingLine_Beta = max([0,find(BetaDiff(1:Line) <= -1,1,"last")]);
%     StartLine = [StartingLine_Alpha,StartingLine_Beta];
    
    % Adding modules
        % whole line
            if Line == (TopLine + 1) && ...
                    abs(StartConfig(Line)) == 0
                Line = numel(StartConfig)-Line+1;
                Task = CreatTaskAllocationTable([],"ActionType","CreateLine","Current_Line_Alpha",Line,"Current_Line_Beta",Line,"Downwards",~Downwards,"Type",0,"DestenationLine",0,"Side",Addition.Side);
                return
        % One module
            elseif xor(AlphaDiff(Line) == 1,BetaDiff(Line) == 1) || (AlphaDiff(Line) == 2 && BetaDiff(Line) == 0) || (AlphaDiff(Line) == 0 && BetaDiff(Line) == 2)
%                 [GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(Addition.WS, Addition.ConfigShift,Downwards);
%                 Edges1 = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
                
                if ~Downwards
                    StartConfig = -flip(StartConfig);
                    AbsDiff = flip(AbsDiff);
                    Edges = Get_GroupEdges(StartConfig);
                    DestenationLine = size(Edges,1)-(Line-1);
                    UpsideDown = -1;
                else
                    Edges = Get_GroupEdges(StartConfig);
                    DestenationLine = Line;
                    UpsideDown = 1; % do nothimg
                end
                
%                 DestenationLine = size(Edges,1)-(Line-1);
                
%                 Addition.Side = ["Left","Right"];
                if AlphaDiff(Line) >= 1 && BetaDiff(Line) <= 0
                    ReqiuerdType = 1*UpsideDown; % alpha in the regular look
                else
                    ReqiuerdType = -1*UpsideDown; % beta in the regular look
                    
                end
                if matches(Addition.Side,"")
                    if sign(StartConfig(DestenationLine)) == ReqiuerdType && ~mod(abs(StartConfig(DestenationLine)),2) 
                        Addition.Side = "Right";
                    elseif ~mod(abs(StartConfig(DestenationLine)),2)
                        Addition.Side = "Left";
                    end
                end
                Direction = ["Left","Right"];
                switch Addition.Side
                    case "Left"
                        First_Left = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),1) == ReqiuerdType,1);% & abs(StartConfig((DestenationLine+1):size(Edges,1))) > 2,1);
                        First_Right = inf;
                    case "Right"
                        First_Right = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),2) == ReqiuerdType,1);%& abs(StartConfig((DestenationLine+1):size(Edges,1))) > 2,1);
                        First_Left = inf;
                    otherwise
                        First_Left = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),1) == ReqiuerdType,1);% & abs(StartConfig((DestenationLine+1):size(Edges,1))) > 2,1);
                        First_Right = DestenationLine + find(Edges((DestenationLine+1):size(Edges,1),2) == ReqiuerdType,1);% & abs(StartConfig((DestenationLine+1):size(Edges,1))) > 2,1);
                end
                if (isempty(First_Right) && isinf(First_Left)) || (isempty(First_Left) && isinf(First_Right))
                    Task = Get_Module_From_The_Other_Side(First_Right,DestenationLine,Addition.Side,ReqiuerdType,Downwards,Edges,AbsDiff);
                    return
                end
                [First_Line, DirLoc] = min([First_Left,First_Right]);
                if ReqiuerdType == UpsideDown
                    Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",First_Line,"Downwards",Downwards,"Type",ReqiuerdType,"DestenationLine",DestenationLine,"Side",Direction(DirLoc));
                    return
                else
                    Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",First_Line,"Downwards",Downwards,"Type",ReqiuerdType,"DestenationLine",DestenationLine,"Side",Direction(DirLoc));
                    return
                end
        % Two module
            elseif AlphaDiff(Line) >= 1 && BetaDiff(Line) >= 1
                DestenationLine = size(StartConfig,1)-(Line-1);
                StartLine = find(abs(StartConfig(1:Line-1))>=4,1,"last");
                
                StartLine = size(StartConfig,1)+1 - StartLine; % When you need to bring 2 to fill a missing row, take from the closest row below it which has 4 modules or more.
                if isempty(StartLine)
                    if ~Downwards
                        StartConfig = flip(StartConfig);
                    end
                    StartLine = Line+ find(abs(StartConfig(Line+1:end))>=4,1,"first");
                    DestenationLine = Line;
                    Downwards = ~Downwards;
                end
                Task = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",StartLine,"Current_Line_Beta",StartLine,"Downwards",Downwards,"Type",0,"DestenationLine",DestenationLine,"Side",Addition.Side);
                return
            end

    Downwards = ~Downwards;
end

end


function Task_Queue = Get_Module_From_The_Other_Side(First_Right,DestenationLine,Side,ReqiuerdType,Downwards,Edges,AbsDiff)


NotCompleteLine = logical(AbsDiff);

if matches(Side,"Left")
    FirstStage_Side = "Right";
else
    FirstStage_Side = "Left";
end

%% Stage 1
if isempty(First_Right)
    
    FirstStage_Init_Location = find(Edges(:,2) == ReqiuerdType & NotCompleteLine,1,"first");
    % FirstStage_Final_Location = find(Edges(:,2),1,"last");
    
else
    FirstStage_Init_Location = find(Edges(:,1) == ReqiuerdType & NotCompleteLine,1,"first");
    % FirstStage_Final_Location = find(Edges(:,2),1,"last"); 
end
if ~isempty(FirstStage_Init_Location)
    FirstStage_Current_Line = size(Edges,1)-(FirstStage_Init_Location-1);
    FirstStage_Destenation_Line = size(Edges,1)-(DestenationLine-1);

    if ReqiuerdType == -1
        Task_Queue = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",FirstStage_Current_Line,"Downwards",~Downwards,"Type",-ReqiuerdType,"DestenationLine",FirstStage_Destenation_Line,"Side",Side);
    else
        Task_Queue = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",FirstStage_Current_Line,"Downwards",~Downwards,"Type",-ReqiuerdType,"DestenationLine",FirstStage_Destenation_Line,"Side",Side);
    end
    return
end


if isempty(First_Right)
    
    FirstStage_Init_Location = find(Edges(:,1) == ReqiuerdType & NotCompleteLine,1,"last");
    FirstStage_Final_Location = find(Edges(:,1),1,"last");
    
else
    FirstStage_Init_Location = find(Edges(:,2) == ReqiuerdType & NotCompleteLine,1,"last");
    FirstStage_Final_Location = find(Edges(:,2),1,"last");
    
end
    FirstStage_Current_Line = size(Edges,1)-(FirstStage_Init_Location-1);
    FirstStage_Destenation_Line = size(Edges,1)-(FirstStage_Final_Location-1);
    if ReqiuerdType == -1
        Task_Remove = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",FirstStage_Current_Line,"Downwards",~Downwards,"Type",-ReqiuerdType,"DestenationLine",FirstStage_Destenation_Line,"Side",FirstStage_Side);
    else
        Task_Remove = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",FirstStage_Current_Line,"Downwards",~Downwards,"Type",-ReqiuerdType,"DestenationLine",FirstStage_Destenation_Line,"Side",FirstStage_Side);
    end

    %% Stage 2
    Task_Switch = CreatTaskAllocationTable([],"ActionType","Switch","Current_Line",FirstStage_Destenation_Line,"Downwards",~Downwards);

    %% Stage 3
    if ReqiuerdType == -1
        Task_Add = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Alpha",FirstStage_Final_Location,"Downwards",Downwards,"Type",-ReqiuerdType,"DestenationLine",DestenationLine,"Side",Side);
    else
        Task_Add = CreatTaskAllocationTable([],"ActionType","TransitionModules","Current_Line_Beta",FirstStage_Final_Location,"Downwards",Downwards,"Type",-ReqiuerdType,"DestenationLine",DestenationLine,"Side",Side);
    end

% test the option to switch the base line and that it...
BaseLine = find(Edges(:,1),1,"last");
if Edges(BaseLine,1) ~= Edges(BaseLine,2)
    % Task_Remove.DestenationLine = FirstStage_Current_Line-1;
    Task_Queue = [Task_Add;Task_Remove;Task_Switch]; %solve form end to start
else
    Task_Queue = [Task_Add;Task_Switch;Task_Remove]; %solve form end to start
end
end





