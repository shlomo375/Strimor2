%% Solve multiple Line flattning problem

clear
close all
SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);
load("Problems18.mat","TotalProblem","Solutions","Flat");

N = sum(TotalProblem{1,"ConfigMat"}{:},"all");
size = [N,2*N];
BesicWS = WorkSpace(size,"RRT*");
BesicWS.Space.Status(1,1:N-1) = 1;
BesicWS.Space.Status(2,1) = 1;
Config = GetConfiguration(BesicWS);
Flat = ConfigStruct2Node(Config);

disp("start")
StartFrom = find(cellfun(@isempty,Solutions),1);
for idx = StartFrom:numel(Solutions)
    idx
    [Sucsses, Path] = OneGroupLineFlatteningAlgorithm(TotalProblem(idx,:),Flat);
    if ~mod(idx,100)
        disp("ProblemNum: "+string(idx)+" "+string(datetime)+"left: "+ string(numel(Solutions)-idx)) 
    end
end