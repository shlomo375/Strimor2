%% simple shape creator
AddDirToPath()
ProblemNum = 2e3;
N = 100;
TEMP = cell(7,1);

for N = 50
  
    BasicWS = WorkSpace([N,N*2],"RRT*");
    % TEMP(NN) = {BasicWS};
    % save(join(["BasicWS",string(N)],"_"),"BasicWS");
    GroupSize = Create_GroupSize(N,ProblemNum);
    % timeit(@()Create_GroupSize(N,ProblemNum))
    
    Nodes = CreateNode(size(GroupSize,2));
    for Col = 1:size(GroupSize,2)
        
        Nodes(Col,:) = GroupMatrix2Configuration(Nodes(Col,:),GroupSize(:,Col),BasicWS);
        fprintf("N: %d, Config: %d\n",N,Col);
    end
    Folder = fullfile("configuration\SimpleConfiguration_Nodes");
    mkdir(Folder);
    save(fullfile(Folder,join(["N",string(N)],"_")),"Nodes");
end
% save("BasicWS");
% save(join(["BasicWS",string(N)],"_"),"BasicWS");


function GroupSize = Create_GroupSize(ModuleNum,ProblemNum)
GroupSize = [];    
for ii = linspace(ModuleNum/10,ModuleNum*9/10,9)
    GroupSize = [GroupSize, 1+randi(round(ii),ModuleNum/2,round(ProblemNum/8))];
end
Total_Module_In_Config = cumsum(GroupSize,1);
GroupSize(Total_Module_In_Config>ModuleNum) = 0;


one = ones(size(GroupSize,1),1);
for Col = 1:size(GroupSize,2)
    num_Line = find(GroupSize(:,Col),1,"last")+1;
    GroupSize(num_Line,Col) = ModuleNum-max(cumsum(GroupSize(:,Col)));
    
    num_Of_Beta_Edge = randi(num_Line);
    Beta_Edge = randperm(num_Line,num_Of_Beta_Edge);
    Beta_Edge(Beta_Edge==num_Line & (GroupSize(Beta_Edge,Col)==1)') = [];

    GroupSize(Beta_Edge,Col) = -GroupSize(Beta_Edge,Col);
    TypeDiff = 0;
    for Row = 1:num_Line
        if mod(GroupSize(Row,Col),2)
            if GroupSize(Row,Col)>0
                TypeDiff = TypeDiff+1;
            else
                TypeDiff = TypeDiff-1;
            end
        end
    end
    AlphaEdge = GroupSize(1:num_Line,Col)>0 & mod(GroupSize(1:num_Line,Col),2);
    while TypeDiff
        if TypeDiff>0
            AlphaLoc = find(AlphaEdge);
            Loc = randi(numel(AlphaLoc));
            if GroupSize(AlphaLoc(Loc),Col) == 1
                continue
            end
            GroupSize(AlphaLoc(Loc),Col) = -GroupSize(AlphaLoc(Loc),Col);
            AlphaEdge(AlphaLoc(Loc)) = 0;
            TypeDiff = TypeDiff-2;
        else
            BetaLoc = find(~AlphaEdge);
            Loc = randi(numel(BetaLoc));
            if GroupSize(BetaLoc(Loc),Col) == 1
                continue
            end

            GroupSize(BetaLoc(Loc),Col) = -GroupSize(BetaLoc(Loc),Col);
            AlphaEdge(BetaLoc(Loc)) = 2;
            TypeDiff = TypeDiff+1;
        end
    end
end
deleteGroup = randperm(size(GroupSize,2),abs(ProblemNum-size(GroupSize,2)));
GroupSize(:,deleteGroup) = [];
end