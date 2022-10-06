function ParentNode = FlipMovmentAndConfig(Node,ParentNode)
Config.Status = Node.ConfigMat{1};
Config.Type = Node.Type;

N = sum(logical(Node.ConfigMat{1}),"all");
Size = [N, 2*N];
BasicWS = WorkSpace(Size,"RRT*");
[ConfigWS,Agent] = SetConfigurationOnSpace(BasicWS,Config);
% figure(1)
% PlotWorkSpace(ConfigWS,[]);
[~, Configuration] = MakeAMove(ConfigWS,Node.Dir,-Node.Step, Agent);
% [ChildWS] = SetConfigurationOnSpace(BasicWS,Configuration);
% figure(2)
% PlotWorkSpace(ChildWS,[]);
% ParentNode{1,"Dir"} = Node.Dir;
ParentNode{1,"Step"} = -Node.Step;
ParentNode{1,"ConfigMat"} = {Configuration.Status};
ParentNode(1,["ParentStr","ParentRow","ParentCol","Dir","ParentMat"]) = Node(1,["ConfigStr","ConfigRow","ConfigCol","Dir","ConfigMat"]);
end