%% Solve multiple Line flattning problem
% 81
clear
close all
SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);
% Solutions{:}.Sucsses
load("Problems18.mat","TotalProblem","Solutions","Flat");
Solutions = cell(size(TotalProblem,1),1);



N = sum(TotalProblem{1,"ConfigMat"}{:},"all");
Size = [N,2*N];
BesicWS = WorkSpace(Size,"RRT*");
BesicWS.Space.Status(1,1:N-1) = 1;
BesicWS.Space.Status(2,1) = 1;
Config = GetConfiguration(BesicWS);
Flat = ConfigStruct2Node(Config);
Flat = AddIsomorphismMatToConfig(Flat);
disp("start")
% StartFrom = find(cellfun(@isempty,Solutions),1);


Slices = SliceCellVector(TotalProblem,ceil(size(TotalProblem,1)/100));
Slices=Slices([1,2])
% Create a parallel pool
delete(gcp('nocreate'));
pool = parpool(5);
for i = 1:numel(Slices)
    future(i) = parfeval(pool, @SolveBatch, 4, Slices{i},Flat,i+80);
% [Sucsses,BatchIdx, ProblemIdx,Problem] = SolveBatch(Slices{i},Flat,i)
 end
fprintf("Working... start at: %s\n",string(datetime))
% Collect the results from the parallel pool
for BatchFinish = 1:numel(Slices)
    [idx,Sucsses,BatchIdx, ProblemIdx,Problem] = fetchNext(future);
    fprintf("sucsses: %s, Batch : %d/%d, time: %s\n",string(Sucsses),idx,numel(Slices),future(idx).RunningDuration);
end


function [Sucsses,BatchIdx, ProblemIdx,Problem] = SolveBatch(TotalProblem,Flat,BatchIdx)
ProblemIdx = 0;
Sucsses = true;
Solutions = cell(size(TotalProblem,1),1);

N_Solution = numel(Solutions);

for idx = 1:N_Solution
%     idx = 601+100
    t = tic;
    Problem = [];
    

    [Problem.Sucsses, Problem.Path] = OneGroupLineFlatteningAlgorithm(TotalProblem(idx,:),Flat,5);
    
    Problem.Runtime = toc(t);
    Problem.StartConfig = TotalProblem(idx,:);
    Solutions{idx} = Problem;
    if ~Problem.Sucsses
        Sucsses = false;
        ProblemIdx = idx;
        StartConfig = Problem.StartConfig;
        save(fullfile("C:\Users\shlom\OneDrive\Documents\GitHub\Strimor2\LineFlatting\LineFlating_Solution","Problems18_Batch"+string(BatchIdx)+".mat"),"TotalProblem","Solutions","Flat","StartConfig");

        return
    end

%     if ~Problem.Sucsses
%         fprintf("error in problem: %d",idx);
%         pause
%     else
%         fprintf("Time: %d ProblemNum: %d, ToatlTime: %s, Problemleft: %d\n",Problem.Runtime,idx,string(duration(0,0,toc(TotalTime))),numel(Solutions)-idx);
%     end
end
save(fullfile("C:\Users\shlom\OneDrive\Documents\GitHub\Strimor2\LineFlatting\LineFlating_Solution","Problems18_Batch"+string(BatchIdx)+".mat"),"TotalProblem","Solutions","Flat");

end


function Slices = SliceCellVector(Vector,NumInSlice)


% Determine the number of slices needed
numSlices = ceil(size(Vector,1) / NumInSlice);

% Create an empty cell array to hold the slices
Slices = cell(numSlices, 1);

% Slice the cell array into pieces of size 5000 or less
for i = 1:numSlices
    startIndex = (i-1)*NumInSlice + 1;
    endIndex = min(i*NumInSlice, size(Vector,1));
    Slices{i} = Vector(startIndex:endIndex,:);
end

% Display the slices
disp(Slices);

end
