classdef WorkSpace
    properties (SetAccess = public)
        SpaceSize %{mustBeVector,mustBeNumeric,mustBePositive}
        Space
        R1
        R2
        R3
        Algoritem
        
    end
    
    methods (Static)
        function [top,down] = CreatBasicMap(Size)
            PositionMap = [0,1;1,0];
            PositionMap = repmat(PositionMap,Size(1)/2,Size(2)/2);
            top = find(PositionMap==1);
            down = find(PositionMap==0);
        end

        function colors = Colors(Status)
            colors = zeros(size(Status,1),3);
            for i = 1:size(Status)
                switch Status(i)
                    case  1 %occupied
                        colors(i,:) = [29,147,253]/255;%[0 57 115]/255;%
                    case 0 % ampty
                        colors(i,:) = [1 1 1];
                    case -1 %Target
                        colors(i,:) = [1 .55 .55];%red
                    case 2 %selected
                        colors(i,:) = [0.4 1 0.4];%green
                    case 10 %error
                        colors(i,:) = [232, 7, 37]/255;%blue%[214,12,50]/255;%
                    case 3 %center of mass
                        colors(i,:) = [1 .75 .81];%pink
                    case 11
                        colors(i,:) = [0.5 0.5 0.5];
                end
            end
        end

        function s = SpaceStructure(Size)
            s.Status = zeros(Size);
            s.Type = [];
            s.index = zeros(Size);
            s.index(:) = 1:numel(s.index);
%             s = repmat(struct("Status",0,"Type",[],"index",0),Size);
        end
        
        function s = MovmentStructure(dir,step,Agent)
            s = struct("dir",dir,"step",step,"Agent",Agent);
        end
        
    end
    
    methods
        
        function WS = WorkSpace(Size,algoritem,Lite,FullType)
            WS.Space = WorkSpace.SpaceStructure(Size);
%             [WS.Space.index] = index{:};
            WS.SpaceSize = Size;
            WS.Algoritem = algoritem;
            if nargin < 4
                WS = SetSpaceType(WS);
            else
                WS.Space.Type = FullType;
                WS = AxisRotationMatrixNew(WS);
            end
%             PlotWorkSpace(WS);
            if nargin < 3
                WS = AxisRotationMatrixNew(WS);
            end

%             WS = AxisRotationMatrix(WS);

        end

        function WS = SetSpaceType(WS)
            temp = ones(WS.SpaceSize(1),1);
            temp(1:2:end) = -1;
            WS.Space.Type = repmat(temp,[1,WS.SpaceSize(2)]);
            temp = ones(1,WS.SpaceSize(2));
            temp(2:2:end) = -1;
            WS.Space.Type = WS.Space.Type.*temp;

        end

        function WS = AxisRotationMatrixNew(WS)
            line = @(x,m,n) (m*x+n');
            Size = WS.SpaceSize;
            Row = Size(1);
            Col = Size(2);
            if ~mod(Col,2)
                NewRow = sum(round(Size./2));
            else
                NewRow = sum(round([Row-1, Col]./2));
            end
%             NewCol = min(2*Size);
            
            %axis 1
            WS.R1 = reshape(1:prod(Size),Size);

            %axis 2
            R = [];
            n2 = 2.5:2:((2*NewRow)+1);
            [i,j] = meshgrid(1:Col,1:Row);
            for k = 1:length(n2)
                [ro,co] = find(abs(j-line(i,-1,n2(k)))<=.5);
                loc = flip(sortrows([ro,co],[2 1],{'descend' 'ascend'}),1);
                ind = sub2ind(Size,loc(:,1),loc(:,2));
                if isempty(ind)
                    break
                end
                if k>1
                    target = sub2ind(Size,loc(end,1),loc(end,2)-1);
                    shift = 1;
                    if find(ind==target)
                        target = sub2ind(Size,loc(end,1),loc(end,2)-2);
                        shift = 2;
                    end
    
%                     [row,col] = find(R==target);

                    R = [zeros(NewRow,length(ind)), R, zeros(NewRow,(k>1))];
                    [row,col] = find(R==target);
                    R(row+1,col+shift-length(ind):col+(shift==2)) = ind';
                    
                    
                else
                    R = [R, zeros(NewRow,length(ind))];
                    R(k,:) = ind';
                end
            end
            R(:,sum(R)==0) = []; 
            WS.R2 = R;
            
            
            %axis 3
            R = [];
            n3 = (Col-1.5+(mod(Col,2)==0)):-2:-(Col+(mod(Col,2)==0));
            if length(n3)>NewRow
                n3 = n3(1:NewRow);
            end
            [i,j] = meshgrid(1:Col,1:Row);
            for k = 1:length(n3)
                [ro,co] = find(abs(i-line(j,1,n3(k)))<=.5);
                loc = sortrows([ro,co],1,'ascend');
                ind = sub2ind(Size,loc(:,1),loc(:,2));
            
                if isempty(ind)
                    break
                end
                if k>1
                    target = sub2ind(Size,loc(1,1),loc(1,2)+1);
                    shift = 1;
                    if find(ind==target)
                        target = sub2ind(Size,loc(1,1),loc(1,2)+2);
                        shift = 2;
                    end
    
%                     [row,col] = find(R==target);

                    R = [zeros(NewRow,length(ind)), R, zeros(NewRow,(k>1))];
                    [row,col] = find(R==target);
                    R(row+1,col-(shift==2):col-(shift==2)+length(ind)-1) = ind';
                    
                    
                else
                    R = [R, zeros(NewRow,length(ind))];
                    R(k,:) = ind';
                end
            end
            R(:,sum(R)==0) = []; 
            WS.R3 = R;
        end

        function WS = AxisRotationMatrix(WS)
            RAxis1 = reshape(1:prod(WS.SpaceSize),[WS.SpaceSize]);

            Row = WS.SpaceSize(1);
            Col = WS.SpaceSize(2);
            n = prod(WS.SpaceSize);
            NewRow = round(sum(WS.SpaceSize./2));
            NewCol = min(WS.SpaceSize*2);

            %convert to axis 2:
            RAxis2 = zeros(NewRow,NewCol);
            
            %first partial rows
            for i = 1:round(Row/2)
                top = (n+1-2*i):-(Row-1):(n+Row-2*i*Row);
                down = top(1:end-1)+1;
                line = [top; down 0];
                line = line(:)';
                line = line(1:end-1);
                RAxis2(i,1:size(line,2)) = line; 
            end
            %all the rest of the rows.
            for i = (Row/2+1):NewRow
                top = (n-((i-Row/2)*2+1)*Row+1):-(Row-1):0;
                if length(top)>Row
                    top = top(1:Row);
                end
                down = top+Row;
                
                if length(top)<Row
                    if isempty(top)
                        down = 1;
                    else
                        down = [down down(end)-Row+1];
                    end
                end
                

                line = zeros(2,Row);
                line(1,1:length(down)) = down;
                line(2, 1:length(top)) = top;
                line = line(:)';
                
                RAxis2(i,1:size(line,2)) = line; 
            end
            
            %convert to axis 3: 
            RAxis3 = zeros(NewRow,NewCol);
            
            %first partial and complete rows
            for i = 1:Row
                top = (2*i-1)*Row:-(Row+1):0;
                if length(top)>10
                    top = top(1:10);
                end
                down = top-Row;
                if length(top)<Row
                    down = down(1:end-1);
                end
                
                line = zeros(2,Row);
                line(1,1:length(top)) = top;
                line(2, 1:length(down)) = down;
                line = line(:)';
                RAxis3(i,1:size(line,2)) = line; 
            end
            %all the rest partial rows.
            for i = Row+1:NewRow
                down = n-2*(i-Row-1):-(Row+1):0;
                down = down(1:NewCol/2-2*(i-Row-1));
                top = down(1:end-1)-1;

                line = zeros(2,Row);
                line(1,1:length(down)) = down;
                line(2, 1:length(top)) = top;
                line = line(:)';
                RAxis3(i,1:size(line,2)) = line; 
            end
            WS.R1 = RAxis1;
            WS.R2 = RAxis2;
            WS.R3 = RAxis3;
        end
        
        function WS = SetProp(WS,property,Loc,data)
            switch property
                case "Name"
                    [WS.Space(Loc).Name] = deal(data);
                case "ID"
                    [WS.Space(Loc).ID] = deal(data);
                case "Type"
                    [WS.Space(Loc).Type] = deal(data);
                case "Status"
                    [WS.Space(Loc).Status] = deal(data);
                case "Dir"
                    [WS.Space(Loc).Dir] = deal(data);
                case "Step"
                    [WS.Space(Loc).Step] = deal(data);
            end
        end
        
%         function PlotWorkSpace(WS,text,Agent,c,MoveNumber)
%             
%             
%             map = WS.Space;
%             Loc = true(size(map.Status));
%             if nargin>2
% %                 map = WS.Space(Agent);
%                 Loc = false(size(map.Status));
%                 Loc(Agent) = true;
%                 Loc = Loc';
%             end
% 
%             Status = map.Status;
%             if nargin>2
%                     Status(Agent) = deal(c);
%             end
%             Status = Status';
%             
%             Type = map.Type';
%             Index = map.index';
%            
% %             [yShift,xShift] = ind2sub(size(WS.Space.Status),Index);
%             [yShift,xShift] = meshgrid(1:size(WS.Space.Status,1),1:size(WS.Space.Status,2));
%             if nargin>4
%                 MoveNumText.x = min(xShift,[],"all")-3;
%                 MoveNumText.y = max(yShift,[],"all")+3;
%                 MoveNumText.value = MoveNumber(1);
%                 MoveNumText.handel = [];
%             else
%                 MoveNumText = [];
%             end
%             
%             if ~isempty(text)
%                 PlotTriangle([xShift(Loc),yShift(Loc)], Type(Loc), Status(Loc), num2str(Index(Loc')),[],[],MoveNumText);
%             else
%                 PlotTriangle([xShift(Loc),yShift(Loc)], Type(Loc), Status(Loc),[],[],[],MoveNumText);
%             end
%            axis equal;
% %             xlim([])
%         end

        function PlotWorkSpace(WS,GeneralPlot,PlotAgent,NumberPlot)
            
            arguments
                WS (1,1) {mustBeA(WS,"WorkSpace")}
%                 FigureHandle (1,1) = figure("Name","WorkSpacePloted");
                GeneralPlot.Plot_CellInd (1,1) {mustBeNumericOrLogical} = false;
                GeneralPlot.Plot_FullWorkSpace (1,1) {mustBeNumericOrLogical} = false;
                GeneralPlot.Plot_AllModule (1,1) {mustBeNumericOrLogical} = false;
%                 PlotAgent.PlotOnlySpacificAgent (1,1) {mustBeNumericOrLogical} = false;
                PlotAgent.Set_SpecificAgentInd (:,1) {mustBeInteger,mustBePositive,mustBeVector}
                PlotAgent.Set_SpecificColors (:,3) {mustBeInteger} = 10;
                NumberPlot.PlotMoveNumber (1,1) {mustBeNumericOrLogical} = false;
                NumberPlot.MoveNumber (1,1) {mustBePositive,mustBeInteger} = 1;
                NumberPlot.NumberLocation (1,2) {mustBePositive} = [3,3];
            end
            map = WS.Space;
            
            Status = map.Status;
            if GeneralPlot.Plot_FullWorkSpace
                Loc = true(size(map.Status));
            else
                [Row,Col] = find(map.Status);
                RowRange = [min(Row)-3,max(Row)+1];
                ColRange = [min(Col)-6,max(Col)+4];
                Loc = true(size(map.Status));
                Loc(1:RowRange(1)-1,:) = false;
                Loc(RowRange(2)+1:end,:) = false;
                Loc(:,1:ColRange(1)-1) = false;
                Loc(:,ColRange(2)+1:end) = false;
            end
            if isfield(PlotAgent,"Set_SpecificAgentInd")
%                 map = WS.Space(Agent);
%                 Loc = false(size(map.Status));
%                 Loc(PlotAgent.AgentInd) = true;
%                 Loc = Loc';
                Status(PlotAgent.AgentInd) = deal(Set_SpecificColors);
            end
            Loc = Loc';
            
            Status = Status';
            Type = map.Type';
            Index = map.index';
           
            [yShift,xShift] = meshgrid(1:size(WS.Space.Status,1),1:size(WS.Space.Status,2));
            
            if NumberPlot.PlotMoveNumber
                MoveNumText.x = min(xShift,[],"all")-NumberPlot.NumberLocation(1);
                MoveNumText.y = max(yShift,[],"all")+NumberPlot.NumberLocation(2);
                MoveNumText.value = NumberPlot.MoveNumber(1);
                MoveNumText.handel = [];
            else
                MoveNumText = [];
            end
            
            if GeneralPlot.Plot_CellInd
                PlotTriangle([xShift(Loc),yShift(Loc)], Type(Loc), Status(Loc), num2str(Index(Loc)),[],[],MoveNumText);
            else
                PlotTriangle([xShift(Loc),yShift(Loc)], Type(Loc), Status(Loc),[],[],[],MoveNumText);
            end
           axis equal;
%             xlim([])
        end
        
        function [WS, AgentLoc] = GetAgentFromUser(WS,Status)
%             PlotWorkSpace(WS,1);
            exit = 1;
            AgentLoc = [];
            hold on
            while exit
                [x,y,button] = ginput(1);
                y = y/sqrt(3);
                if button == 3
                    break
                end 
                AgentLoc(end+1) = sub2ind(WS.SpaceSize,round(y),round(x));
                plot(round(x),round(y)*sqrt(3),"xb","MarkerSize",20); 
            end
            for i = AgentLoc
                if Status == 1
                    WS.Space.Agent(i) = Agent;
                end
                WS.Space.Status(i) = Status;
            end
            cla
%             PlotWorkSpace(WS,1);
        end
        
        function WS = SetConfiguration(WS, Status, Loc)
            for i = Loc
                WS.Space(i).Status = Status;
            end
        end

        function CM = CenterOfMass(WS)
            
            l = find([WS.Space.Status] == 1);
            [y,x] = ind2sub(WS.SpaceSize,l);
            CM = [mean(y) mean(x)];
%             ind = sub2ind(WS.SpaceSize,CM(1),CM(2));
            
        end

        % Checking whether movement in a certain direction and number
        % of steps is technically possible.
        % Is there an agent that can be moved in relation to him. 
        % The action gets all the agents that need to move

        % The linear position of the agents in a particular R matrix is obtained,
        % the agents are moved in the same matrix and their linear representation
        % is translated into a linear representation in the matrix R1
        function [OK, MoveAgent2Ind, CollidingAgent, Alert] = ApproveMovment(WS,Movment,slide)
            if slide == "Slide"
                slide = 1;
            else
                slide = 0;
            end
            
            Alert = "movment is OK";
            CollidingAgent = [];
            MoveAgent2Ind = [];

            if ~all(WS.Space.Status(Movment.Agent))
                OK = false;
                return
            end


            Loc = Movment.Agent;
            Type = WS.Space.Type(Loc);
            BaseDown = Loc(Type==1);
%             BaseUp = Loc(~ismember(Loc, BaseDown));
            BaseUp = Loc(Type~=1);
            
            switch abs(Movment.dir)
                case 1
                    R = WS.R1;
                case 2
                    temp = BaseDown;
                    BaseDown = BaseUp;
                    BaseUp = temp;
                    R = WS.R2;
                case 3
                    temp = BaseDown;
                    BaseDown = BaseUp;
                    BaseUp = temp;
                    R = WS.R3;     
            end
            
            Size = size(R);
            [RowUp,ColUp] = find(ismember(R,BaseUp));
            [RowDown,ColDown] = find(ismember(R,BaseDown));

            RAgentLoc = sub2ind(Size,[RowUp;RowDown],[ColUp;ColDown]);
            
            step = abs(Movment.step);
            RightLeft = sign(Movment.step);
            

%%                               collision check
            NextAgentLoc = @(Col)([Col,RightLeft*ones(size(Col))] ...
                    *[ones(1,2*step+(slide==1));1:(2*abs(step)+(slide==1))]);
            try
            LocOnTheWay_Up = sub2ind(Size,RowUp.*ones(1,2*step+(slide==1)),NextAgentLoc(ColUp));
            LocOnTheWay_Down = sub2ind(Size,RowDown.*ones(1,2*step+(slide==1)),NextAgentLoc(ColDown));
            catch E   
%                 fprintf(E.identifier);
                Alert = "movment outside workspace area.";
                    OK = false;
                    return
            end
            LocOnTheWay = [LocOnTheWay_Up; LocOnTheWay_Down];
            
%%                           outside border check
            LocInSpace = R(LocOnTheWay(:,1:end-1));
            [~,OutSideCol] = find(~LocInSpace,1);
            if ~isempty(OutSideCol)
%                 step = round(min(OutSideCol)/2)-1;
% %                 if (step==-1)
% %                     dir
% %                 end
%                 LocOnTheWay = LocOnTheWay(:,1:2*step);
%                 if ~step
                    Alert = "movment outside workspace area.";
                    OK = false;
                    return
%                 end  
            end
%             
%%                          end of outside border check
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            try
            LocInSpace = R(LocOnTheWay);
            zeroLoc = (LocInSpace == 0);
            LocInSpace(zeroLoc) = 1;
            OptionalCollision = WS.Space.Status(LocInSpace);
            OptionalCollision(zeroLoc) = 0;
            catch e
                fprintf(e.identifier);
            end

            RelevantLoc = ~ismember(LocOnTheWay,RAgentLoc);
%             [CollisionRow,CollisionCol] = find(OptionalCollision & RelevantLoc);%%ttttttttttttttttttttttttttttttttttttttt
%             try
            CollidingAgent = [BaseUp(:); BaseDown(:)];
%             catch
%                 d=5
%             end
            CollidingAgent = CollidingAgent(any(OptionalCollision & RelevantLoc,2));
            if ~isempty(CollidingAgent)
                OK = false;
                Alert = "Colliding Agent";
                return

            end
%%                         end of collision check
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%                          Possible Relative Movement
            NextPartner = @(Col)([Col,2*RightLeft*ones(size(Col))]*[ones(1,step+1);0:step]);
            
            ProblemRowUp = (RowUp>=Size(1));
            ProblemRowDown = (RowDown<=1);
            RowUp(ProblemRowUp) = Size(1)-1;
            RowDown(ProblemRowDown) = 2;
            try
            PartnerAgentUpIndLoc = sub2ind(Size,(RowUp+1).*ones(1,step+1),NextPartner(ColUp));
            
            PartnerAgentDownIndLoc = sub2ind(Size,(RowDown-1).*ones(1,step+1),NextPartner(ColDown));
            
            NotCouplingUp = ismember(R(PartnerAgentUpIndLoc(:,1)),BaseDown);
            NotCouplingDown = ismember(R(PartnerAgentDownIndLoc(:,1)),BaseUp);
            catch E
                fprintf(E.identifier);
            end
            try
            PartnerAgentUpIndLoc(NotCouplingUp | ProblemRowUp,:) = [];
            PartnerAgentDownIndLoc(NotCouplingDown | ProblemRowDown,:) = [];
            catch e
                e
            end
            try
            PartnerAgent = [PartnerAgentUpIndLoc; PartnerAgentDownIndLoc];
            catch qwe
                qwe
            end
            try
            PartnerAgentInSpace = R(PartnerAgent);
            zeroLoc = (PartnerAgentInSpace == 0);
            PartnerAgentInSpace(zeroLoc) = 1;
%             ExistsAgent = reshape([WS.Space(PartnerAgentInSpace).Status],size(PartnerAgent));
            ExistsAgent = WS.Space.Status(PartnerAgentInSpace);
            ExistsAgent(zeroLoc) = 0;

            catch E
                PlotWorkSpace(WS)
                fprintf(E.identifier);
            end
%             ForbiddenStep = find(~any(ExistsAgent),1);
            
            if ~isempty(find(~any(ExistsAgent),1))
                OK = false;
                Alert = "no agent suitable for relative movment";
                return
            end
%%                      end of Possible Relative Movement
            OK = true;
            Alert = "all good";
            try
            MoveAgent2Ind = LocInSpace(:,end-(slide==1));
            catch E
                fprintf(E.identifier);
            end
        end
        
        function ScannedAgent = ScanningAgents(WS, ScannedAgent, Agent)
            ScannedAgent(Agent) = 1;
%             r = {WS.R1, WS.R2, WS.R3};
            i = 1;
            for r = {WS.R1, WS.R2, WS.R3}
%                 R = cell2mat(r);
                R = r{1};
%                 [row,col] = find(ismember(R,Agent),1);
                [row,col] = find(R==Agent);
                col = col+1-2*(i==1);
                i = 2;
                if (col<=0) ||(col>size(R,2))
                    continue
                end
                try
                NextAgent = R(sub2ind(size(R),row,col));
                catch e
                    d=5;
                end
                if ~NextAgent
                    continue
                end
                
                if ~ScannedAgent(NextAgent)
                    ScannedAgent = ScanningAgents(WS, ScannedAgent, NextAgent);
                end
      
            end  
        end 

        
        function [ScannedAgent, ModulesList,Idx] = ScanningAgentsFast(WS, ScannedAgent, Agent, FirstItr, ModulesList,AgentType, Idx)
            if nargin<5
                ModulesList = zeros(sum(logical(WS.Space.Status),"all"),1);
                AgentType = WS.Space.Type(Agent);
                Idx = 1;
            end
            ScannedAgent(Agent) = true;
            ModulesList(Idx) = Agent;
            Idx = Idx +1;

            NextAgent = Agent + WS.SpaceSize(1);
            if NextAgent >= 1 && NextAgent <= numel(WS.Space.Status)
                if ~ScannedAgent(NextAgent)
                    [ScannedAgent, ModulesList,Idx] = ScanningAgentsFast(WS, ScannedAgent, NextAgent, [], ModulesList,-AgentType, Idx);
                end
            end
            
            NextAgent = Agent - WS.SpaceSize(1);
            if NextAgent >= 1 && NextAgent <= numel(WS.Space.Status)
                if ~ScannedAgent(NextAgent)
                    [ScannedAgent, ModulesList,Idx] = ScanningAgentsFast(WS, ScannedAgent, NextAgent, [], ModulesList,-AgentType, Idx);
                end
            end
            
            NextAgent = Agent - AgentType;
            if abs(mod(NextAgent,WS.SpaceSize(1))-mod(Agent,WS.SpaceSize(1)))<=1
                if ~ScannedAgent(NextAgent)
                        [ScannedAgent, ModulesList,Idx] = ScanningAgentsFast(WS, ScannedAgent, NextAgent, [], ModulesList,-AgentType, Idx);
                end
            end

            if ~isempty(FirstItr)
                ModulesList(~ModulesList) = [];
            end
        end 

%         function approve = ScanningAgentsFast(WS, ScannedAgent)
%             approve = true;
% %             Agent = find(~ScannedAgent);
% %             Agent = Agent(randperm(length(Agent),1));
%             
% %             ScannedAgent(Agent) = 1;
%             group = {[]};
% %             r = {WS.R1, WS.R2, WS.R3};
%             while any(~ScannedAgent)
%                 Agent = find(~ScannedAgent);
%                 Agent = Agent(randperm(length(Agent),1));
% 
% 
%                 Neighbors = [];
%                 for r = {WS.R1, WS.R2, WS.R3}
%                     R = cell2mat(r);
%                     [row,~] = find(ismember(R,Agent),1);
%                     NextLoc = R(sub2ind(size(R),row*ones(1,size(R,2)),1:size(R,2)));
%                     NextLoc(NextLoc==0) = []; 
%                     Populated = ~[WS.Space(NextLoc).Status];
%                     
%                     first = Populated(1:find(NextLoc==Agent));
%                     last = Populated(size(first,2)+1:end);
%                     Neighbors = [Neighbors, NextLoc(find(first,1,"last")+1:size(first,2))];
%                     Neighbors = [Neighbors, NextLoc(size(first,2)+(1:find(last,1,"first")-1))];
%                     
%                 end
%                 ScannedAgent(Neighbors) = 1;
%                 AddToGroup = false;
%                 for i=1:size(group,2)
%                     
%                     g = cell2mat(group(i));
%                     if isempty(g)
%                         group = {Neighbors};
%                         AddToGroup = true; 
%                         break
%                     end
%                     
%                     if ~isempty(ismember(g,Neighbors))
%                         group(i) = {unique([g,Neighbors])};
%                         AddToGroup = true; 
%                         break
%                     end
%                 end
%                 if ~AddToGroup
%                     group(end+1) = {Neighbors};
%                 end
%             end
%                 if size(group,2)>1
%                     approve = false;
%                 end
%                 
%         end
%         
        function [Approve, Alert] = SplittingCheckSlow(WS)
            Approve = true;            
            space = logical(reshape([WS.Space.Status],size(WS.R1)));
            
            Size1 = size(WS.R1);
            Size2 = size(WS.R2);
            Size3 = size(WS.R3);
            MaxCol = max([Size1(2),Size2(2),Size3(2)]);
            MaxRow = Size1(1)+Size2(1)+Size3(1);
            
            R = zeros(MaxRow,MaxCol);
            ThreeSpace = R;
            R(1:Size1(1),1:Size1(2)) = WS.R1;
            R(Size1(1)+(1:Size2),1:Size2(2)) = WS.R2;
            R(Size1(1)+Size2(1)+(1:Size3),1:Size3(2)) = WS.R3;

            ThreeSpace(1:Size1(1),1:Size1(2)) = space;
            
            for dir = 2:3
                switch abs(dir) 
                    case 2
                        r = WS.R2;
                    case 3
                        r = WS.R3;     
                end
                %     find number of row is chosen dir
                tempInd = (r==1);
                r(r==0) = 1;
                Config = space(r);
                r(r==1) = 0;
                r(tempInd) = 1;
                Config(r==0) = 0;    
                
                switch abs(dir) 
                    case 2
                        ThreeSpace(Size1(1)+(1:Size2),1:Size2(2)) = Config;
            
                    case 3
                        ThreeSpace(Size1(1)+Size2(1)+(1:Size3),1:Size3(2)) = Config;   
                end
            end
%        %%%%%%%%%%%%%%%%         Config = logical(Space);
                
                
%                 dThreeSpace=diff([zeros(size(ThreeSpace,1),1),ThreeSpace],1,2);
                dThreeSpace=[ThreeSpace,zeros(size(ThreeSpace,1),1)]-[zeros(size(ThreeSpace,1),1),ThreeSpace]; 
                dThreeSpace(dThreeSpace~=1)=0;
                Integral=cumsum(dThreeSpace,2);
            
                Integral(~ThreeSpace)=0;
                Number=cumsum(max(Integral,[],2));
                Groups=Integral+[0;Number(1:end-1)];
                Groups(~ThreeSpace) = 0;
                
                
            
%             i=1:max(z{1},[],"all");
            NumCounts = histcounts(Groups,max(Groups,[],"all")+1);
            [~,Num] = max(NumCounts(2:end));
            
            Agent = R(Groups==Num);
            GroupsNumberHistory = zeros(1,max(Groups,[],"all"));
            GroupsNumberHistory(Num) = 1;
            NumOfAgent = sum(space,'all');
            while numel(Agent) < NumOfAgent
                AgentPosInGroups = ismember(R,Agent);
                
                GroupsNumber = unique(Groups(AgentPosInGroups));
                GroupsNumber = setdiff(GroupsNumber,find(GroupsNumberHistory));
                if isempty(GroupsNumber)
                    Approve = false;
                    break
                end
                
                GroupsNumberHistory(GroupsNumber) = 1;
                
                NewAgentPosInR = ismember(Groups,GroupsNumber);
                Agent = unique([Agent; R(NewAgentPosInR)]);
            end
        end
        
      
%             Approve = true;
%             Parts = AllSlidingParts(WS);
%             Parts = cat(1,Parts{:});
%             while numel(Parts)>1
%                 Exists = cellfun(@(x)any(ismember(x,Parts{1})),Parts);
%                 if ~any(Exists(2:end))
%                     Approve = false;
%                     break
%                 end
%                 Connect = {unique(cat(1,Parts{Exists}))};
%                 Parts = [Parts(~Exists); {0}];
%                 Parts(end) = Connect;
%             end
        

        function [Approve, Alert] = SplittingCheck(WS,Loc)
            Alert = "not spliting";
            Approve = true;
            ScannedAgent = ~WS.Space.Status(:);
            ScannedAgent = ScanningAgents(WS, ScannedAgent, Loc(1));
%             Approve = ScanningAgentsFast(WS, ScannedAgent);
            if any(~ScannedAgent)
                Alert = "Some agents are not connected to the rest of the system";
                Approve = false;
            end

        end

        function WS = ChangeAgentLoc(WS,Ind,OldInd)
            status = 1;
            if nargin==3
                if ~all(WS.Space.Status(OldInd))
                    error("the ind to move arn't a module location");
                end
                WS.Space.Status(OldInd) = deal(0);
                if WS.Algoritem == "RRT*"
                    status = 2;
                end
                
            end
            
            
                WS.Space.Status(Ind) = deal(status);
            
            %A(length(OldInd)) = Agent;% = WorkSpace.SpaceStructure([1,length(Ind)]);
%             [WS.Space(OldInd).Agent] = mat2cell(A,2);
%             [WS.Space(Ind).Agent] = Temp.Agent;
            
        end

        function [WS, NewInd] = SpaceCentering(WS)
            Size = WS.SpaceSize;
            CM = CenterOfMass(WS);
            SpaceCenter = WS.SpaceSize/2;
            Movment = round(SpaceCenter - CM);
            
            if WS.Space(round(CM(1)),round(CM(2))).Type ~= WS.Space(round(CM(1))+Movment(1),round(CM(2))+Movment(2)).Type
                Movment(2) = Movment(2)+1;
            end

            ind = find([WS.Space.Status]);
            [row,col] = ind2sub(Size,ind);
            
            try
            Ncol = col + Movment(2);
            Nrow = row + Movment(1);
            NewInd = sub2ind(Size,Nrow,Ncol);
            
            catch E
                if strcmp(E.identifier,'MATLAB:sub2ind:IndexOutOfRange')
                    if sum(Ncol <= 0)
                        Ncol = col + Movment(2) + abs(min(Ncol))+1;
                    end
                    if sum(Nrow <= 0)
                        Nrow = row + Movment(1) + abs(min(Nrow))+1;
                    end
                    if sum(Ncol > Size(2))
                        Ncol = col + Movment(2) + (Size(2) - max(Ncol));
                    end 
                    if sum(Nrow > Size(1))
                        Nrow = row + Movment(1) + (Size(1) - max(Nrow));
                    end 
                    NewInd = sub2ind(Size,Nrow,Ncol);
                end
            end
            
%             Temp = WS.Space(ind);
%             A = WorkSpace.SpaceStructure([1,length(ind)]);
%             B = {Temp.Type};
%             [A.Type] = B{:};
%             WS.Space(ind) = A;
%             [WS.Space(NewInd)] = Temp;

            WS = ChangeAgentLoc(WS,NewInd,ind);

        end
            
        function Configuration = GetConfiguration(WS)
            Configuration.Status = WS.Space.Status;
            TypeLoc = find(Configuration.Status,1);
            col = any(Configuration.Status);
            row = any(Configuration.Status,2);
            Configuration.Status = Configuration.Status(row,col);
            
            Configuration.CompleteType = WS.Space.Type(row,col);
            Configuration.Type = WS.Space.Type(TypeLoc);
%             Configuration.FullType = WS.Space.Type(row,col);
%             Configuration.Str = num2str(Configuration.CompleteType(logical(Configuration.Status(:))))';
            LogicalConfig = logical(Configuration.Status(:));
            CompleteConfig = double(LogicalConfig);
            CompleteConfig(LogicalConfig) = Configuration.CompleteType(LogicalConfig);
            Configuration.Str = join(string(CompleteConfig)',"");
            Configuration.Row = size(Configuration.Status,1);
            Configuration.Col = size(Configuration.Status,2);
%             base = 2.^([0:numel(Configuration.Status)-1]);
%             Configuration.Dec = sum(base.*logical(Configuration.Status(:))');
            
        end
        
        function [WS,TagAgentLoc] = SetConfigurationOnSpace(WS,Config,AddTag2Agent)
            Size = size(Config.Status);
            [row,col] = find(Config.Status);
            ShiftCol = round((WS.SpaceSize(2)-Size(2))./2);
%             Col = StartCol:StartCol+Size(2)-1;
            ShiftRow = round((WS.SpaceSize(1)-Size(1))./2);
%             Row = StartRow:StartRow+Size(1)-1;
            Row = row + ShiftRow;
            Col = col + ShiftCol;
%             try
%                 WS.Space(Row(1),Col(1)).Type
%             catch e
%                 d=5;
%             end
            if WS.Space.Type(Row(1),Col(1)) ~= Config.Type
                edge = [min(Row)>1, max(Row)<WS.SpaceSize(1), min(Col)>1, max(Col)<WS.SpaceSize(2)];
                i = find(edge,1);
                switch i
                    case 1
                        Row = Row-1;
                    case 2
                        Row = Row+1;
                    case 3
                        Col = Col-1;
                    case 4
                        Col = Col+1;
                end
            end
            ind = sub2ind(WS.SpaceSize,Row,Col);
            
            WS = ChangeAgentLoc(WS,ind);
            
            if ~isempty(find(Config.Status>1,1))
                [r,c] = find(Config.Status>1);
                TagAgentLoc = ind(ismember([row, col],[r, c],"rows"));
            else
                TagAgentLoc = [];
            end
            if nargin> 2
                WS.Space.Status(TagAgentLoc) = AddTag2Agent;
            end

        end
    end
    
end