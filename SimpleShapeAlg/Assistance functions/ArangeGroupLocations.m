function [Step, Axis] = ArangeGroupLocations(Direction,Edges,Displacement_Reqierd,GroupsNum,ManeuverType)

arguments
    Direction (1,1) {matches(Direction,["Right","Left"])}    
    Edges (:,1) {mustBeA(Edges,"cell")}
    Displacement_Reqierd (:,1) = false;
    GroupsNum (:,1) {mustBePositive,mustBeInteger} = ones(numel(Edges),1);
    ManeuverType (1,1) {matches(ManeuverType,["Reduce","Remove"])} = "Remove";
end


Displacment = zeros(1,numel(Edges));
% +(Edges{1,GroupsNum(1)}(3,1) ~= Edges{3,GroupsNum(1)}(3,1))
switch Direction
    case "Left"
        for Line = numel(Edges):-1:2
            if ~isempty(Edges{Line})
                Displacment(Line) = floor((Edges{Line,GroupsNum(Line)}(2,1))) - (Edges{Line-1,GroupsNum(Line-1)}(2,1));
        
            else
                Displacment(Line) = inf;
            end
        end
        if matches(ManeuverType,"Reduce")
            Displacment(1) = [];
        else
            Displacment(4) = [];
        end
        NotCare_Buttom = Displacment(1) < Displacement_Reqierd(1);
        NotCare_Top = Displacment(3) > Displacement_Reqierd(3);
        Step = (Displacement_Reqierd' - Displacment)/2; 
        Step = ceil(abs(Step)).* sign(Step);


    case "Right"
        
        for Line = 2:numel(Edges)
            if ~isempty(Edges{Line})
                Displacment(Line) = floor(Edges{Line,GroupsNum(Line)}(2,2) - (Edges{Line-1,GroupsNum(Line-1)}(2,2)));
            else
                Displacment(Line) = -inf;
            end
        end
        if matches(ManeuverType,"Reduce")
            Displacment(1) = [];
        else
            Displacment(4) = [];
        end
        Displacement_Reqierd = -Displacement_Reqierd;
        NotCare_Buttom = Displacment(1) > Displacement_Reqierd(1);
        NotCare_Top = Displacment(3) < Displacement_Reqierd(3);
        Step = (Displacement_Reqierd' - Displacment)/2; 
        Step = -ceil(abs(Step)).* sign(Step); %minus sign will flip again in ComuteManuver function... 
end



if NotCare_Buttom
    Step(1) = 0;
end

if NotCare_Top && matches(ManeuverType,"Reduce")
    Step(3) = 0;
end

% if matches(ManeuverType,"Remove")
%     Step(4) = [];
% end
% Step(~Step) = [];
Axis = ones(size(Step));
end