%Check if the desired movement is possible and if all the active agents
%needed to perform the movement have received an order.
%In addition, if a passive agent who is not on the list moves in this
% movement he is also added to the list of agents

function [Agents,success] = DisplacementApprovalCheck(Map,Agents,Movement)
addedPasive = 0;
%Check if all relevant agents have been ordered to move
Edges = GetLineEdge(Agents,Movement.Direction);
type = [Map.Type(Edges(1,1),Edges(1,2)); Map.Type(Edges(2,1),Edges(2,2))];

[Front1, Front1Type] = JumpToNext("forward",Movement.Direction,Edges(1,:),type(1));
if Map.loc(Front1(2),Front1(1))
    if Front1Type
        success = false;
        fprintf("Error! An agent who is supposed to move has not been instructed");
    else
        Agents(end+1,:) = Front1;
        addedPasive = 1;
    end
end
Front2 = JumpToNext("forward",Movement.Direction,Front1,Front1Type);
if(Map.loc(Front2(2),Front2(1)))
    if addedPasive
        success = false;
        fprintf("Error! An agent who is supposed to move has not been instructed");
    else
        success = false;
        fprintf("Error! This movement will cause a collision with the agent \n");
        %print collition allert;
    end
end


[Back1, Back1Type] = JumpToNext("backward",Movement.Direction,Edges(2,:),type(2));
if Map.loc(Back1(2),Back1(1))
    if Back1Type
        success = false;
        fprintf("Error! An agent who is supposed to move has not been instructed \n");
    else
        Agents(end+1,:) = Back1;

        Back2 = JumpToNext("backward",Movement.Direction,Back1,Back1Type);
        if Map.loc(Back2(2),Back2(1))
            success = false;
            fprintf("Error! An agent who is supposed to move has not been instructed \n");
        end
    end
end

Agents = sortrows(Agents);

end
