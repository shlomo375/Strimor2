function [Step, Axis, Direction] = ArangeLinePostion_For_ReduceModule(Direction, Edges,GroupsNum)
arguments
    Direction (1,1) {matches(Direction,["Right","Left","Both"])}
    Edges
    GroupsNum (:,1) {mustBePositive,mustBeInteger} = ones(numel(Edges),1);
end

if Edges{2,GroupsNum(2)}(3,1) == 1 && Edges{3,GroupsNum(3)}(3,1) == 1
    Reletive_Position = [1;-1;2];

elseif Edges{2,GroupsNum(2)}(3,1) == -1 && Edges{3,GroupsNum(3)}(3,1) == 1
    Reletive_Position = [-1;-2;2];

elseif Edges{2,GroupsNum(2)}(3,1) == 1 && Edges{3,GroupsNum(3)}(3,1) == -1
    Reletive_Position = [-inf;0;1];

elseif Edges{2,GroupsNum(2)}(3,1) == -1 && Edges{3,GroupsNum(3)}(3,1) == -1
    Reletive_Position = [0;-3;1];
end


if matches(Direction,"Both")
    [Step_Right, Axis_Right] = ArangeGroupLocations("Right",Edges,Reletive_Position,GroupsNum);
    [Step_Left, Axis_Left] = ArangeGroupLocations("Left",Edges,Reletive_Position,GroupsNum);
    
    if sum(abs(Step_Left)) > sum(abs(Step_Right))
        Step = Step_Right;
        Axis = Axis_Right;
        Direction = "Right";
    else
        Step = Step_Left;
        Axis = Axis_Left;
        Direction = "Left";
    end

else
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,GroupsNum);
end



end