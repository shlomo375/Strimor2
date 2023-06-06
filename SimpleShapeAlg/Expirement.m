%% Expirements Creator
files = dir("configuration\SimpleConfiguration_Nodes");
files([files.isdir],:) =[];
t=CreateNode(2000);
ProblemNum = 50;
Solution = cell(1000,1);
for N = 100:50:1000
    
    % load(fullfile(files(file_idx).folder,files(file_idx).name),"Nodes");
    % Nodes = [Nodes,t(:,["Manuver","Manuver_num"])];
    % N = nnz(Nodes.ConfigMat{1});
    Size = [N,N*2];
    BasicWS = WorkSpace(Size,"RRT*");

    %% Config to Config
    Exp = [];

    
    
    PosibleDiff = 0:round(N/6-4);
    SumDiffProblem = cell(size(PosibleDiff));
    SumDiffProblem_size = cellfun(@(x)numel(x),SumDiffProblem);
    
    while any(SumDiffProblem_size < ProblemNum) && all(SumDiffProblem_size<1000)
        
        Nodes = SimpleShapeCreator(N,2e3);
        Nodes = Nodes(randperm(size(Nodes,1)),:);
        for k = 1:(size(Nodes,1)/2)
            if Nodes{2*k-1,"ConfigRow"}<2 || Nodes{2*k,"ConfigRow"}<2
                continue
            end
            l = abs(Nodes{2*k-1,"ConfigRow"}-Nodes{2*k,"ConfigRow"});
            SumDiffProblem{l+1}{end+1} = {Nodes(2*k-1,:),Nodes(2*k,:),l};
            SumDiffProblem_size(l+1) = SumDiffProblem_size(l+1)+1;
            
        end 
       SumDiffProblem_size = cellfun(@(x)numel(x),SumDiffProblem)
       fprintf("N module %d\n",N);

    end
    for ii = 1:numel(SumDiffProblem)
        try
            Exp = [Exp,SumDiffProblem{ii}(1:100)'];
        catch
            % Exp = [Exp;SumDiffProblem{ii}(:)];
        end
    end
    Solution = cell(numel(Exp),1);
    save(fullfile("SimpleShapeAlg","Experiments",join(["N",string(N),".mat"],"_")),"SumDiffProblem","Exp","BasicWS","Solution");
    
    

    % for k = 1:numel(Exp)
    %     Exp{k} = {Nodes(2*k-1,:),Nodes(2*k,:)};
    %     fprintf("%s: %d\n",files(file_idx).name,k);
    % end
    % save(fullfile("SimpleShapeAlg","Experiments",join([extractBefore(files(file_idx).name,".mat"),"C2C.mat"],"_")),"Exp","BasicWS","Solution");
    
    % %% Config to Line to Config
    % 
    % FlatWS = BasicWS;
    % FlatWS.Space.Status(1,1:N-1) = 1;
    % FlatWS.Space.Status(2,1) = 1;
    % Config = GetConfiguration(FlatWS);
    % Node = CreateNode(1);
    % Flat = ConfigStruct2Node(Node,Config);
    % Exp = cell(size(Nodes,1)/2,1);
    % for k = 1:numel(Exp)
    %     Exp{k} = {Nodes(2*k-1,:),Flat,Nodes(2*k,:)};
    %     fprintf("%s: %d\n",files(file_idx).name,k);
    % end
    % save(fullfile("SimpleShapeAlg","Experiments",join([extractBefore(files(file_idx).name,".mat"),"C2F.mat"],"_")),"Exp","BasicWS","Solution");
end