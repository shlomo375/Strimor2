%% Run Simple Shape expirements
clear
close all
AddDirToPath
% TestType = "C2C";
TestFile = dir("SimpleShapeAlg\Experiments");
SolutionFolder = fullfile(pwd,"Solutions");
mkdir(SolutionFolder);
TestFile([TestFile.isdir]) = [];
Num_Problem_In_Batch = 50;
Ploting = 0;

for ii = 1:numel(TestFile)
    File_N(ii) = str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_")));
end
[~,loc] = sort(File_N);
SortedTestFile = TestFile(loc);

for ii = 1:numel(SortedTestFile)
    % if str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_"))) == 100
        load(fullfile(SortedTestFile(ii).folder,SortedTestFile(ii).name),"Exp","Solution")
        if size(Solution,2) == 1 
            Solution = cell(Num_Problem_In_Batch,(numel(Exp)/Num_Problem_In_Batch));
        end
        
        N = str2double(cell2mat(extractBetween(SortedTestFile(ii).name,"N_","_")));
        BasicWS = WorkSpace(2*[N,2*N],"RRT*");

        % problemSolve = 0;
        parfor k = 0:(numel(Exp)/Num_Problem_In_Batch)
            % if numel(Exp{k}) == 2
            tempSolution = cell(50, 1);  % Temporary variable to store results
            for jj = 1:50
                stratTime = tic;
                StartNode = Exp{Num_Problem_In_Batch*k+jj}{1};
                TargetNode = Exp{Num_Problem_In_Batch*k+jj}{2};
                
                % if StartNode.ConfigRow < TargetNode.ConfigRow
                [Tree, error,msg] = SimpleShapeAlgorithm(BasicWS, N, StartNode, TargetNode,Ploting);
                
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

    
        save(fullfile(SolutionFolder,join(["N",string(N),".mat"])),"Solution");
   
end
