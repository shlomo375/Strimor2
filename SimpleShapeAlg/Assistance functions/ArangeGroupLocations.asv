function [Step, Axis] = ArangeGroupLocations(Direction,Edges,Displacement_Reqierd,ManeuverType)

arguments
    Direction (1,1) {matches(Direction,["Right","Left"])}    
    Edges (4,2,:) {mustBeInteger}
    Displacement_Reqierd (:,1) = false;
    ManeuverType (1,1) {matches(ManeuverType,["Reduce","Remove"])} = "Remove";
end


Displacment = zeros(1,size(Edges,3));
% +(Edges{1,GroupsNum(1)}(3,1) ~= Edges{3,GroupsNum(1)}(3,1))
switch Direction
    case "Left"
        for Line = size(Edges,3):-1:2
            if Edges(1,1,Line-1)
                if Edges(1,1,Line)
                    Displacment(Line) = floor((Edges(2,1,Line))) - (Edges(2,1,Line-1));
            
                else
                    Displacment(Line) = inf;
                end
            end
        end
%         if matches(ManeuverType,"Reduce")
            
%         else
%             Displacment(1) = [];
%         end
        % if numel(Displacement_Reqierd) == 1 && Displacement_Reqierd
            Displacment(1) = [];
            NotCare_Buttom = Displacment(1) < Displacement_Reqierd(1);
            NotCare_Top = Displacment(3) > Displacement_Reqierd(3);
            Step = (Displacement_Reqierd' - Displacment)/2; 
            Step = ceil(abs(Step)).* sign(Step);
        % else
        %     Step = Displacment;
        % end


    case "Right"
        
        for Line = 2:size(Edges,3)
            if Edges(1,1,Line-1)
                if Edges(1,1,Line)
                    Displacment(Line) = floor(Edges(2,2,Line) - (Edges(2,2,Line-1)));
                else
                    Displacment(Line) = -inf;
                end
            end
             
        end
        % if numel(Displacement_Reqierd) == 1 && Displacement_Reqierd
            Displacment(1) = [];
    
            Displacement_Reqierd = -Displacement_Reqierd;
            NotCare_Buttom = Displacment(1) > Displacement_Reqierd(1);
            NotCare_Top = Displacment(3) < Displacement_Reqierd(3);
            Step = (Displacement_Reqierd' - Displacment)/2; 
            Step = -ceil(abs(Step)).* sign(Step); %minus sign will flip again in ComuteManuver function... 
        % else
        %     Step = Displacment;
        % end
end



if NotCare_Buttom
    Step(1) = 0;
end

if NotCare_Top && matches(ManeuverType,"Reduce")
    Step(3) = 0;
end

Axis = ones(size(Step));
end