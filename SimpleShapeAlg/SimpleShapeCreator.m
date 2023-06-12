%% simple shape creator
% AddDirToPath()
% ProblemNum = 2e3;
% N = 100;
% TEMP = cell(7,1);

function [Nodes] = SimpleShapeCreator(N,ProblemNum)
  
    BasicWS = WorkSpace([N,N*2],"RRT*");

    GroupSize = Create_GroupSize(N,ProblemNum);
    % timeit(@()Create_GroupSize(N,ProblemNum))
    
    Nodes = CreateNode(size(GroupSize,2));
    
    for Col = 1:size(GroupSize,2)
        
        Nodes(Col,:) = GroupMatrix2Configuration(Nodes(Col,:),GroupSize(:,Col),BasicWS);
        % NewConfig = AddIsomorphismMatToConfig(Nodes(Col,:),false,RotationMatrices);
        % if ~isequal(NewConfig{1,"IsomorphismMatrices1"}{1},GroupSize(GroupSize(:,Col)~=0,Col))
        %     error("problem. matrix group not match\n")
        % end
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

for ii = [linspace(ModuleNum/10,ModuleNum*5/10,7),linspace(ModuleNum*6/10,ModuleNum*9/10,2)]
    GroupSize = [GroupSize, 5+randi(round(ii),ModuleNum/2,round(ProblemNum/8))];
end
Total_Module_In_Config = cumsum(GroupSize,1);
GroupSize(Total_Module_In_Config>ModuleNum) = 0;


% one = ones(size(GroupSize,1),1);
for Col = 1:size(GroupSize,2)
    num_Line = find(GroupSize(:,Col),1,"last");
    Missing = ModuleNum-max(cumsum(GroupSize(:,Col)));
    if Missing>=6
        num_Line = num_Line +1;
        GroupSize(num_Line,Col) = Missing;
    else
        GroupSize(num_Line,Col) = GroupSize(num_Line,Col) + Missing;
    end
    num_Of_Beta_Edge = randi(num_Line);
    Beta_Edge = randperm(num_Line,num_Of_Beta_Edge);
    % Beta_Edge(Beta_Edge==num_Line & (GroupSize(Beta_Edge,Col)==1)') = [];

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
    Beta_Edge = GroupSize(1:num_Line,Col)<0 & mod(GroupSize(1:num_Line,Col),2);
    while TypeDiff
        if TypeDiff>0
            AlphaLoc = find(AlphaEdge);
            Loc = randi(numel(AlphaLoc));
            if GroupSize(AlphaLoc(Loc),Col) == 1
                continue
            end
            GroupSize(AlphaLoc(Loc),Col) = -GroupSize(AlphaLoc(Loc),Col);
            AlphaEdge(AlphaLoc(Loc)) = 0;
            Beta_Edge(AlphaLoc(Loc)) = 1;
            TypeDiff = TypeDiff-2;
        else
            BetaLoc = find(Beta_Edge);
            Loc = randi(numel(BetaLoc));
            if GroupSize(BetaLoc(Loc),Col) == 1
                continue
            end

            GroupSize(BetaLoc(Loc),Col) = -GroupSize(BetaLoc(Loc),Col);
            AlphaEdge(BetaLoc(Loc)) = 1;
            Beta_Edge(BetaLoc(Loc)) = 0;
            TypeDiff = TypeDiff+2;
        end
    end

    %% test
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
    if TypeDiff
        error("not equalt number of alpha and beta")
    end
end
deleteGroup = randperm(size(GroupSize,2),abs(ProblemNum-size(GroupSize,2)));
GroupSize(:,deleteGroup) = [];
Shafle = randperm(size(GroupSize,2));
GroupSize = GroupSize(:,Shafle);
end