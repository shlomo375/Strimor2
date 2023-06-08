function [Steps,Dir] = Get_Step_To_Remove_Module(Edges,GroupNum,BaseNum_1st,BaseNum_2nd,Dir)

arguments
    Edges
    GroupNum
    BaseNum_1st
    BaseNum_2nd
    Dir {matches(Dir,["Both","Left","Right"])}= "Both";
end

switch Dir
    case "Both"
        StepsLeft(1) = floor((Edges{2,BaseNum_1st}(2,1)+(Edges{2,BaseNum_1st}(3,1)==1) - Edges{3,GroupNum}(2,1)-(Edges{3,GroupNum}(3,1)==-1))/2);
        if Edges{3,GroupNum}(3,1) ~= -1 || Edges{2,GroupNum}(3,1) ~= 1
            StepsLeft(1) = StepsLeft(1) - 1;
            StepsLeft(2) = floor((Edges{1,BaseNum_2nd}(2,1)+(Edges{1,BaseNum_2nd}(3,1)==1) - Edges{2,BaseNum_1st}(2,1)+(Edges{3,BaseNum_1st}(3,1)==-1))/2);
        else
            StepsLeft(2) = 0;
        end

        StepsRight(1) = floor((Edges{2,BaseNum_1st}(2,2) - (Edges{2,BaseNum_1st}(3,2)==1) - Edges{3,GroupNum}(2,2) - (Edges{3,GroupNum}(3,2)==-1))/2);
        if Edges{3,GroupNum}(3,2) ~= -1 || Edges{2,GroupNum}(3,2) ~= 1
            StepsRight(1) = StepsRight(1) + 1;
            StepsRight(2) = floor((Edges{1,BaseNum_2nd}(2,2)-(Edges{1,BaseNum_2nd}(3,2)==1) - Edges{2,BaseNum_1st}(2,2)-(Edges{3,BaseNum_1st}(3,2)==-1))/2);
        else
            StepsRight(2) = 0;
        end

        if StepsRight(2)<0
            StepsRight(2) = 0;
        end
        
        if StepsLeft(2)>0
            StepsLeft(2) = 0;
        end

        if sum(abs(StepsRight))>sum(abs(StepsLeft))
            Steps = StepsLeft;
            Dir = "Left";
        else
            Steps = StepsRight;
            Dir = "Right";
        end
    
    case "Left"
         
        Steps(1) = floor((Edges{2,BaseNum_1st}(2,1)+(Edges{2,BaseNum_1st}(3,1)==1) - Edges{3,GroupNum}(2,1)+(Edges{3,GroupNum}(3,1)==-1))/2);
        if Edges{3,GroupNum}(3,1) ~= -1 || Edges{2,GroupNum}(3,1) ~= 1
            Steps(1) = Steps(1) - 1;
            Steps(2) = floor((Edges{1,BaseNum_2nd}(2,1)+(Edges{1,BaseNum_2nd}(3,1)==1) - Edges{2,BaseNum_1st}(2,1)+(Edges{3,BaseNum_1st}(3,1)==-1))/2);
        else
            Steps(2) = 0;
        end

        if Steps(2)>0
            Steps(2) = 0;
        end
    case "Right"
        Steps(1) = floor((Edges{2,BaseNum_1st}(2,2) - (Edges{2,BaseNum_1st}(3,2)==1) - Edges{3,GroupNum}(2,2) - (Edges{3,GroupNum}(3,2)==-1))/2);
        if Edges{3,GroupNum}(3,2) ~= -1 || Edges{2,GroupNum}(3,2) ~= 1
            Steps(1) = Steps(1) + 1;
            Steps(2) = floor((Edges{1,BaseNum_2nd}(2,2)-(Edges{1,BaseNum_2nd}(3,2)==1) - Edges{2,BaseNum_1st}(2,2)-(Edges{3,BaseNum_1st}(3,2)==-1))/2);
        else
            Steps(2) = 0;
        end

        if Steps(2)<0
            Steps(2) = 0;
        end
end


end
