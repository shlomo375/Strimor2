%% Solve multiple Line flattning problem

clear
close all
SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);

load("Problems18.mat","TotalProblem","Solutions","Flat");
% Solutions = cell(size(TotalProblem,1),1);
N = sum(TotalProblem{1,"ConfigMat"}{:},"all");
Size = [N,2*N];
BesicWS = WorkSpace(Size,"RRT*");
BesicWS.Space.Status(1,1:N-1) = 1;
BesicWS.Space.Status(2,1) = 1;
Config = GetConfiguration(BesicWS);
Flat = ConfigStruct2Node(Config);
Flat = AddIsomorphismMatToConfig(Flat);
disp("start")
StartFrom = find(cellfun(@isempty,Solutions),1);
for idx = 1223:1057:numel(Solutions)
    
    idx = 10736 

    t = tic;
    [Problem.Sucsses, Problem.Path] = OneGroupLineFlatteningAlgorithm(TotalProblem(idx,:),Flat);
    Problem.Runtime = toc(t);
    Problem.StartConfig = TotalProblem(idx,:);
    Solutions{idx} = Problem;

    if ~Problem.Sucsses
        fprintf("error in problem: %d",inx);
    end

    if ~mod(idx,50)
        disp("ProblemNum: "+string(idx)+" "+string(datetime)+"left: "+ string(numel(Solutions)-idx));
    end
    if ~mod(idx,1000)
        save("Problems18.mat","TotalProblem","Solutions","Flat");
    end
end