%% Run Simple Shape expirements
clear
close all
AddDirToPath

TestFile = dir("SimpleShapeAlg\Experiments");
SolutionFolder = fullfile(pwd,"SimpleShapeAlg\Solutions");
mkdir(SolutionFolder);
TestFile([TestFile.isdir]) = [];
Num_Problem_In_Batch = 100;
Ploting = 0;
FevalArray = 100;

File_N=[];
for ii = 1:numel(TestFile)
    File_N(ii) = str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_")));
end
[~,loc] = sort(File_N);
SortedTestFile = TestFile(loc);

f(1:FevalArray) = parallel.FevalFuture;
LastTask = 1;
F_idx = 1;
for ii = 1:numel(SortedTestFile)
    if str2double(cell2mat(extractBetween(SortedTestFile(ii).name,"N_","_"))) == 100
    load(fullfile(SortedTestFile(ii).folder,SortedTestFile(ii).name),"Exp","Solution")
    if size(Solution,2) == 1 
        Solution = cell(Num_Problem_In_Batch,(numel(Exp)/Num_Problem_In_Batch));
    end
    
    N = str2double(cell2mat(extractBetween(SortedTestFile(ii).name,"N_","_")));
    BasicWS = WorkSpace(2*[N,2*N],"RRT*");
    
    if F_idx+size(Exp,2) > size(f,1)
        f(end+1:end+FevalArray) = parallel.FevalFuture;
    end
    
    for idx = 1:size(Exp,2)
        
        f(F_idx) = parfeval(@SolveBatchSimpleProblem,0,Exp(:,idx),BasicWS,N,F_idx,Ploting,SolutionFolder);
        % [Solution,ErrorProblem] = SolveBatchSimpleProblem(Exp(:,idx),BasicWS,N,F_idx,Ploting,SolutionFolder);
        F_idx = F_idx + 1
    end
    end
end
f(F_idx:end) = [];

% magicResults = cell(1,10);
for idx = 1:F_idx
    completedIdx = fetchNext(f);
    disp(f)
    fprintf('Got result with index: %d/%d, working time: %s.\n', completedIdx,F_idx,f(completedIdx).RunningDuration);
end