function [WS,Tree, ParentInd,ConfigShift] = MoveTo(WS, Tree, ParentInd, ConfigShift,Axis,Steps,Ploting)
% N = 
if ~Steps
    return
end
RotationMatrices = {WS.R1,WS.R2,WS.R3};
switch Axis
    case 1
        [GroupsSizes,~, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
    case 2
        ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
        ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);
        
        [GroupsSizes,~, GroupInd] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
    case 3
        ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
        ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);
        
        [GroupsSizes,~, GroupInd] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);
end

LineNum = nnz(GroupsSizes);
N = sum(abs(GroupsSizes));
if any(abs(GroupsSizes) >= N/2)
    FirstStage_Lines = find(abs(GroupsSizes) >= N/2,1);
    SecondStage_Line = find(abs(GroupsSizes) < N/2);

    AllModuleInd = zeros(1,N);
    SumOfAllLine = cumsum(abs(GroupsSizes));
    Loc = [0;SumOfAllLine];
    for ii = 1:numel(SumOfAllLine)
        AllModuleInd((Loc(ii)+1):Loc(ii+1)) = GroupInd{ii}{:}';
    end

    Moving_Log = false(2,numel(AllModuleInd));
    Moving_Log(1,1:SumOfAllLine(FirstStage_Lines)) = true;
    Moving_Log(2,(SumOfAllLine(FirstStage_Lines)+1):SumOfAllLine(max(SecondStage_Line))) = true;

elseif LineNum == 2
    FirstStage_Lines = 1;
    SecondStage_Line = 2;
    SumOfAllLine = cumsum(abs(GroupsSizes));

    AllModuleInd = zeros(1,N);
    Loc = [0;SumOfAllLine];
    for ii = 1:numel(SumOfAllLine)
        AllModuleInd((Loc(ii)+1):Loc(ii+1)) = GroupInd{ii}{:}';
    end

    Moving_Log = false(2,numel(AllModuleInd));
    Moving_Log(1,1:SumOfAllLine(FirstStage_Lines)) = true;
    Moving_Log(2,(SumOfAllLine(FirstStage_Lines)+1):SumOfAllLine(max(SecondStage_Line))) = true;




else
    SumCoupleLine = sum([abs(GroupsSizes(1:floor(LineNum/2))),flip(abs(GroupsSizes(end-floor(LineNum/2)+1:end)))],2);
    if mod(LineNum,2)
        SumCoupleLine(end+1,:) = abs(GroupsSizes(ceil(LineNum/2)));
    end
    SumOfAllLine = cumsum(SumCoupleLine);
    
    % three stage: 50%, half, half
    
    FirstStage_Lines = find(SumOfAllLine(1:end-1) < floor(N/2),1,"last");
    SecondStage_Line = (FirstStage_Lines+1):(ceil((numel(SumOfAllLine)-FirstStage_Lines)/2)+FirstStage_Lines);
    
    AllModuleInd = zeros(1,N);
    Loc = [0;SumOfAllLine];
    for ii = 1:numel(SumOfAllLine)
        if ii == numel(SumOfAllLine) && mod(LineNum,2)
            AllModuleInd((Loc(ii)+1):Loc(ii+1)) = GroupInd{ii}{:}';
        else
            AllModuleInd((Loc(ii)+1):Loc(ii+1)) = [GroupInd{ii}{:}', GroupInd{end-(ii-1)}{:}'];
        end
    end

    Moving_Log = false(3,numel(AllModuleInd));
    Moving_Log(1,1:SumOfAllLine(FirstStage_Lines)) = true;
    Moving_Log(2,(SumOfAllLine(FirstStage_Lines)+1):SumOfAllLine(max(SecondStage_Line))) = true;
    Moving_Log(3,(SumOfAllLine(max(SecondStage_Line))+1):end) = true;
end


OK = false;
k = 1;

Axis = repmat(Axis,1,size(Moving_Log,1));
WS.DoSplittingCheck = true;
StepsSign =sign(Steps);
if abs(Steps) > 1
    Step = repmat(sign(Steps)*1,1,size(Moving_Log,1));
else
    Step = repmat(ceil(Steps/2),1,size(Moving_Log,1));
end
while sign(Steps) == StepsSign
    % [WS, Tree, ParentInd,OK,AllModuleInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",true,"GoBackStep",false);
    % if OK
    %     Steps = sign(Steps)*(abs(Steps) - abs(Step(1)));
    % else
    %     break
    % end
    while ~OK
        if ~Step
            break
        end
        [WS, Tree, ParentInd,OK,AllModuleInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",false,"GoBackStep",false);
        if ~OK
            Step = repmat(sign(Steps)*(abs(Steps)-k),1,size(Moving_Log,1));
            k = k+1;
        else
            Steps = sign(Steps)*(abs(Steps) - abs(Step(1)));
        end
    end

    if ~Step
        break
    end

    WS.DoSplittingCheck = false;
    [WS, Tree, ParentInd,OK,AllModuleInd] = Sequence_of_Maneuvers(WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",false,"GoBackStep",false);
    if (abs(Steps) - abs(Step(1)))<0
        Step = repmat(Steps,1,size(Moving_Log,1));
    else
        Steps = sign(Steps)*(abs(Steps) - abs(Step(1)));
    end
   
end

Tree = AddManuversInfo(Tree,"MoveTo",numel(Step));
WS.DoSplittingCheck = false;
end
