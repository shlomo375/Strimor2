function [Step, Axis, Direction] = Select_Direction_Compute_Step(Direction,Edges,Reletive_Position)

if matches(Direction,"Both")
    [Step_Right, Axis_Right] = ArangeGroupLocations("Right",Edges,Reletive_Position,"Reduce");
    [Step_Left, Axis_Left] = ArangeGroupLocations("Left",Edges,Reletive_Position,"Reduce");
    
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
    [Step, Axis] = ArangeGroupLocations(Direction,Edges,Reletive_Position,"Reduce");
end

end
