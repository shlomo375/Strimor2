function Childs = GetAllConfigChilds(C,fileName,extintion)
if istable(C)
    Config = C;
    Configuration.Status = Config.ConfigMat{1};
    Configuration.Type = Config.Type;
    Configuration.Row = Config.ConfigRow;
    Configuration.Col = Config.ConfigCol;
else
    Config = ConfigStruct2Node(C);
    Configuration = C;
end

N = sum(logical(Configuration.Status),'all');
if mod(N,2)
    N= N+1;
end
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");

tree = TreeClass("ff", N,500, Config,Config);

WS = SetConfigurationOnSpace(BasicWS, Configuration);
Parts =  AllSlidingParts(WS);
tree = MovingEachIndividualPartPCDepth(tree, WS, Parts, 11);

Childs = tree.Data(1:tree.LastIndex,:);
if nargin>1
    plotAllConfig(Childs, N,[],fileName,extintion);
end
close all
