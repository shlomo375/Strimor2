function [next, nextType] = JumpToNext(side,direction,current,type)

%Reversing direction back and forth
if direction<0
    direction = abs(direction);
    if side == "forward"
        side = "backward";
    else
        side = "forward";
    end
end

switch direction
    case 1
        if side == "forward"
                next = [current(1)+1,current(2)];
                nextType = ~type;
            else
                next = [current(1)-1,current(2)];
                nextType = ~type;
        end
    case 2
        if type == 1 %active=>Base down...
            if side == "forward"
                next = [current(1)-1,current(2)];
                nextType = ~type;
            else
                next = [current(1),current(2)-1];
                nextType = ~type;
            end
        else
            if side == "forward"
                next = [current(1),current(2)+1];
                nextType = ~type;
            else
                next = [current(1)+1,current(2)];
                nextType = ~type;
            end
        end
    
    
    case 3
        if type == 1 %active=>Base down...
            if side=="forward"
                next = [current(1),current(2)-1];
                nextType = ~type;
            else
                next = [current(1)+1,current(2)];
                nextType = ~type;
            end
        else
            if side=="forward"
                next = [current(1)-1,current(2)];
                nextType = ~type;
            else
                next = [current(1),current(2)+1];
                nextType = ~type;
            end
        end
end
