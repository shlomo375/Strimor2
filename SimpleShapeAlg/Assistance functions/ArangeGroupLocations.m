function Step = ArangeGroupLocations(Direction,Edges,Position_relative_buttom_group,GroupsNum)

arguments
    Direction (1,1) {matches(Direction,["Right","Left"])}    
    Edges (:,1) {mustBeA(Edges,"Cell")}
    Position_relative_buttom_group (:,1) {mustBeInteger} = zeors(numel(Groups,1));
    GroupsNum (:,1) {mustBePositive,mustBeInteger} = ones(numel(Groups),1);
end

Step = zeros(numel(Edges),1);

switch Direction
    case "Left"
        for Line = 2:numel(Edges)
            Step(Line) = (Edges{1,GroupsNum(1)}(2,1)+(Edges{1,GroupsNum(1)}(3,1)==1) - Edges{Line,GroupsNum(Line)}(2,1)+(Edges{Line,GroupsNum(Line)}(3,1)==-1))/2;
        end
    case "Right"
        for Line = 2:numel(Edges)
            Step(Line) = (Edges{1,GroupsNum(1)}(2,1)-(Edges{1,GroupsNum(1)}(3,1)==1) - Edges{Line,GroupsNum(Line)}(2,1)-(Edges{Line,GroupsNum(Line)}(3,1)==-1))/2;
        end
end

Step = Step + Position_relative_buttom_group;
end