function NewPoints = Cost(NewPointStruct,Point,Target, Param)
NewPoints = zeros(numel(NewPointStruct.Ind),Param.MatrixSize(2));
NewPoints(:,Param.PathLength) = NewPoints(:,Param.PathLength) + abs((NewPointStruct(:,Param.Sub) - Point(:,Param.Sub))*ones(3,1));
NewPoints(:,Param.TargetDis) = abs((NewPoints(:,Param.Sub) - Target)*ones(3,1));
fieldnames(Param)
end
