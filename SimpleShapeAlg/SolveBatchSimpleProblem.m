function [Solution,ErrorProblem] = SolveBatchSimpleProblem(Exp,BasicWS,N,Batch_idx,Ploting,SolutionFolder)
Num_Problem_In_Batch = size(Exp,1);
Solution = cell(Num_Problem_In_Batch,1);
ErrorProblem = cell(1,1);
ii = 1;
for jj = 1:Num_Problem_In_Batch
    stratTime = tic;
    StartNode = Exp{jj}{1};
    TargetNode = Exp{jj}{2};
    
    % if StartNode.ConfigRow < TargetNode.ConfigRow
    [Tree, error,msg] = SimpleShapeAlgorithm(BasicWS, N, StartNode, TargetNode,Ploting);

    if error 
        Solution(jj) = {msg};
        ErrorProblem(ii) = {StartNode;TargetNode};
        ii = ii + 1;
        disp(msg)
        fprintf("batch: %d, problem idx: %d , error!!!!!!!!\n", Batch_idx,jj);
    else
        Solution(jj) = {Tree.Data(1:Tree.LastIndex, :)};
        % problemSolve = problemSolve+1;
        fprintf("batch: %d, problem idx: %d , time: %.1f\n", Batch_idx,jj,toc(stratTime));
    end
end

save(fullfile(SolutionFolder,join(["N_",string(N),"_Batch_",string(Batch_idx),".mat"],"")),"Solution","ErrorProblem");

end
