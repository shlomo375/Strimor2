%% Run Simple Shape expirements
clear
close all
AddDirToPath
% TestType = "C2C";
TestFile = dir("SimpleShapeAlg\Experiments");
TestFile([TestFile.isdir]) = [];
Num_Problem_In_Batch = 50;

for ii = 1:numel(TestFile)
    if str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_"))) == 100
        load(fullfile(TestFile(ii).folder,TestFile(ii).name),"Exp","Solution")
        if size(Solution,2) == 1 
            Solution = cell(Num_Problem_In_Batch,(numel(Exp)/Num_Problem_In_Batch));
        end
        
        N = str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_")));
        BasicWS = WorkSpace(2*[N,2*N],"RRT*");
        
        % problemSolve = 0;
        for k = 3:(numel(Exp)/Num_Problem_In_Batch)
            % if numel(Exp{k}) == 2
            tempSolution = cell(50, 1);  % Temporary variable to store results
            for jj = 1:50
                stratTime = tic;
                StartNode = Exp{Num_Problem_In_Batch*k+jj}{1};
                TargetNode = Exp{Num_Problem_In_Batch*k+jj}{2};
                
                % if StartNode.ConfigRow < TargetNode.ConfigRow
                [Tree, error,msg] = SimpleShapeAlgorithm(BasicWS, N, StartNode, TargetNode);
                
                if error
                    % NotTested("error!!!!!!!!\n");
                    % beep
                    tempSolution(jj) = {msg};
                    disp(msg)
                    fprintf("batch: %d, problem idx: %d , error!!!!!!!!\n", k+1,jj);
                else
                    tempSolution(jj) = {Tree.Data(1:Tree.LastIndex, :)};
                    % problemSolve = problemSolve+1;
                    fprintf("batch: %d, problem idx: %d , time: %.1f\n", k+1,jj,toc(stratTime));
                end
            end
            Solution(:,k+1) = {tempSolution};  % Assign results outside the parfor loop
        end

                % end
            % else
            %     StartNode = Exp{k}{1};
            %     TargetNode = Exp{k}{2};
            %     [Tree1,error1] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode);
            % 
            % 
            %     StartNode = Exp{k}{3};
            %     TargetNode = Exp{k}{2};
            %     [Tree2,error2] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode);
            % 
            %     if error2 || error1
            %         Solution{k} = "error"
            %     else
            %         Solution{k} = {Tree1.Data(1:Tree.LastIndex,:),Tree2.Data(1:Tree.LastIndex,:);};
            %     end
            % end
        


    end
end
