function Steps = Get_Step_To_Remove_Module(Edges,GroupNum,BaseNum_1st,BaseNum_2nd,Dir)

arguments
    Edges
    GroupNum
    BaseNum_1st
    BaseNum_2nd
    Dir {matches(Dir,["Both","Left","Right"])}= "Both";
end

switch Dir
    case "Both"
        StepsLeft(3) = floor((Edges{2}{BaseNum_1st}(2,1)+(Edges{3}{BaseNum_1st}(2,1)==1) - Edges{3}{GroupNum}(2,1)+(Edges{3}{GroupNum}(2,1)==-1))/2);
        if Edges{3}{GroupNum}(3,1) ~= -1 && Edges{2}{GroupNum}(3,1) ~= 1
            StepsLeft(3) = StepsLeft(3) - 1;
            StepsLeft(2) = 0;
        else
            StepsLeft(2) = floor((Edges{1}{BaseNum_2nd}(2,1)+(Edges{3}{BaseNum_2nd}(2,1)==1) - Edges{2}{BaseNum_1st}(2,1)+(Edges{3}{BaseNum_1st}(2,1)==-1))/2);
        end

        StepsRight(3) = floor((Edges{2}{BaseNum_1st}(2,2)+(Edges{3}{BaseNum_1st}(2,2)==1) - Edges{3}{GroupNum}(2,2)+(Edges{3}{GroupNum}(2,2)==-1))/2);
        if Edges{3}{GroupNum}(3,1) ~= -1 && Edges{2}{GroupNum}(3,1) ~= 1
            StepsRight(3) = StepsRight(3) + 1;
            StepsRight(2) = 0;
        else
            StepsRight(2) = floor((Edges{1}{BaseNum_2nd}(2,2)+(Edges{3}{BaseNum_2nd}(2,2)==1) - Edges{2}{BaseNum_1st}(2,2)+(Edges{3}{BaseNum_1st}(2,2)==-1))/2);
        end
        
        if sum(abs(StepsRight))>sum(abs(StepsLeft))
            Steps = StepsLeft;
        else
            Steps = StepsRight;
        end
    
    case "Left"
         
        Steps(3) = floor((Edges{2}{BaseNum_1st}(2,1)+(Edges{3}{BaseNum_1st}(2,1)==1) - Edges{3}{GroupNum}(2,1)+(Edges{3}{GroupNum}(2,1)==-1))/2);
        if Edges{3}{GroupNum}(3,1) ~= -1 && Edges{2}{GroupNum}(3,1) ~= 1
            Steps(3) = Steps(3) - 1;
            Steps(2) = floor((Edges{1}{BaseNum_2nd}(2,1)+(Edges{3}{BaseNum_2nd}(2,1)==1) - Edges{2}{BaseNum_1st}(2,1)+(Edges{3}{BaseNum_1st}(2,1)==-1))/2);
        else
            Steps(2) = 0;
        end
    case "Right"
        Steps(3) = floor((Edges{2}{BaseNum_1st}(2,2)+(Edges{3}{BaseNum_1st}(2,2)==1) - Edges{3}{GroupNum}(2,2)+(Edges{3}{GroupNum}(2,2)==-1))/2);
        if Edges{3}{GroupNum}(3,1) ~= -1 && Edges{2}{GroupNum}(3,1) ~= 1
            Steps(3) = Steps(3) + 1;
            Steps(2) = 0;
        else
            Steps(2) = floor((Edges{1}{BaseNum_2nd}(2,2)+(Edges{3}{BaseNum_2nd}(2,2)==1) - Edges{2}{BaseNum_1st}(2,2)+(Edges{3}{BaseNum_1st}(2,2)==-1))/2);
        end
end


end
