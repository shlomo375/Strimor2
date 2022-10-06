function b = MoveAgent(Map,Agent,Movement)

[y, x] = ind2sub(size(Map.loc),Agent);
%Check if the agents are at the edge of the map

%
Agents = DisplacementApprovalCheck(Map,[x',y'],Movement);





switch abs(Movement.Direction)
    case 1
        EndsOfLine = [min(y), max(y)];
        %Left side check
        NextPoint = JumpToNext("forward",1)
        if Map(x(1),EndsOfLine(1)-1)
            x(end+1) = x(1);
            y(end+1) = EndsOfLine(1)-1;

            if Map(x(1),EndsOfLine(1)-2)
                b = false;
                fprintf("Error! An agent who is supposed to move has not been instructed");
                %Print on the map of the problematic agent
            end
        end
        
        %Right side check
        if Map(x(1),EndsOfLine(2)+1)
            x(end+1) = x(1);
            y(end+1) = EndsOfLine(2)+1;

            if Map(x(1),EndsOfLine(2)+2)
                b = false;
                fprintf("Error! An agent who is supposed to move has not been instructed");
                %Print on the map of the problematic agent
            end
        end




% CounterClockWise motion when 1 is the horizontal axis from right to left.
% -1 is the horizontal axis from left to right.
switch Movement
    case 1
        lowRange = min(y)-1;
        highRange = max(y)+1 : max(y) + 1 + 2*step;
        if (Map(x,lowRange)==1)||(Map(x,highRange)==1)
            fprintf("error! Prohibited action!");
            b = false;
            return
        else
            Map(x,y+2*step) = 1;
        end
    end
%     case 2 
end

% b= true;
% end
