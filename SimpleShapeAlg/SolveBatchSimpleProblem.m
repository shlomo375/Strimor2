function [Solution,ErrorProblem] = SolveBatchSimpleProblem(Exp,BasicWS,N,Batch_idx,Ploting,SolutionFolder)
Num_Problem_In_Batch = size(Exp,1);
Solution = cell(Num_Problem_In_Batch,1);
ErrorProblem = cell(1,1);
ii = 1;

SolutionFiles = dir(SolutionFolder);

for jj = 1:Num_Problem_In_Batch
    if any(matches({SolutionFiles.name},join(["N_",string(N),"_Batch_",string(Batch_idx),"p",string(jj),".mat"],"")))
        continue
    end
    stratTime = tic;
    StartNode = Exp{jj}{1};
    TargetNode = Exp{jj}{2};
    
    % if StartNode.ConfigRow < TargetNode.ConfigRow
    [Tree, error,msg] = SimpleShapeAlgorithm( N,BasicWS, StartNode, TargetNode,Ploting);

    if error 
        Solution = {msg};
        ErrorProblem = {{StartNode,TargetNode}};
        ii = ii + 1;
        disp(msg)
        fprintf("batch: %d, problem idx: %d , error!!!!!!!!\n", Batch_idx,jj);
    else
        Solution = {Tree.Data(1:Tree.LastIndex, :)};
        % problemSolve = problemSolve+1;
        fprintf("batch: %d, problem idx: %d , time: %.1f\n", Batch_idx,jj,toc(stratTime));
    

    end
        save(fullfile(SolutionFolder,join(["N_",string(N),"_Batch_",string(Batch_idx),"p",string(jj),".mat"],"")),"Solution","ErrorProblem");

end


end
