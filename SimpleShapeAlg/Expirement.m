%% Expirements Creator
files = dir("configuration\SimpleConfiguration_Nodes");
files([files.isdir],:) =[];
t=CreateNode(2000);
Solution = cell(1000,1);
for file_idx = 1:size(files,1)
    load(fullfile(files(file_idx).folder,files(file_idx).name),"Nodes");
    Nodes = [Nodes,t(:,["Manuver","Manuver_num"])];
    N = nnz(Nodes.ConfigMat{1});
    Size = [N,N*2];
    BasicWS = WorkSpace(Size,"RRT*");

    %% Config to Config
    Exp = cell(size(Nodes,1)/2,1);
    for k = 1:numel(Exp)
        Exp{k} = {Nodes(2*k-1,:),Nodes(2*k,:)};
        fprintf("%s: %d\n",files(file_idx).name,k);
    end
    save(fullfile("SimpleShapeAlg","Experiments",join([extractBefore(files(file_idx).name,".mat"),"C2C.mat"],"_")),"Exp","BasicWS","Solution");
    
    %% Config to Line to Config
    
    FlatWS = BasicWS;
    FlatWS.Space.Status(1,1:N-1) = 1;
    FlatWS.Space.Status(2,1) = 1;
    Config = GetConfiguration(FlatWS);
    Node = CreateNode(1);
    Flat = ConfigStruct2Node(Node,Config);
    Exp = cell(size(Nodes,1)/2,1);
    for k = 1:numel(Exp)
        Exp{k} = {Nodes(2*k-1,:),Flat,Nodes(2*k,:)};
        fprintf("%s: %d\n",files(file_idx).name,k);
    end
    save(fullfile("SimpleShapeAlg","Experiments",join([extractBefore(files(file_idx).name,".mat"),"C2F.mat"],"_")),"Exp","BasicWS","Solution");
end