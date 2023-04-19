function [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,GroupsNum,ManeuverType)

arguments
    Direction (1,1) {matches(Direction,["Right","Left"])}    
    Edges (:,1) {mustBeA(Edges,"cell")}
    Reletive_Position (:,1) {mustBeInteger} = false;
    GroupsNum (:,1) {mustBePositive,mustBeInteger} = ones(numel(Edges),1);
    ManeuverType (1,1) {matches(ManeuverType,["Reduce","Remove"])} = "Remove";
end


Step = zeros(1,numel(Edges));
% +(Edges{1,GroupsNum(1)}(3,1) ~= Edges{3,GroupsNum(1)}(3,1))
switch Direction
    case "Left"
        for Line = numel(Edges):-1:2
            if ~isempty(Edges{Line})
                Step(Line) = floor((Edges{Line-1,GroupsNum(Line-1)}(2,1) - (Edges{Line,GroupsNum(Line)}(2,1)))/2);
        
            end
        end
    case "Right"
        for Line = 2:numel(Edges)
            if ~isempty(Edges{Line})
                Step(Line) = floor((Edges{Line-1,GroupsNum(Line-1)}(2,2) - Edges{Line,GroupsNum(Line)}(2,2))/2);
                fprintf("ArangeGroupLocations, not tested, pause")
%             pause
            end
        end
end
% Step(3) = Step(3) - Step(2);
NotCare_Buttom = Step(1)>Reletive_Position(1);
NotCare_Top = Step(3)>Reletive_Position(3);

Step = Step + floor(Reletive_Position'/2);
% Step(1) = [];
Axis = ones(size(Step));

if NotCare_Buttom
    Step(1) = 0;
end

if NotCare_Top && matches(ManeuverType,"Reduce")
    Step(3) = 0;
end
end