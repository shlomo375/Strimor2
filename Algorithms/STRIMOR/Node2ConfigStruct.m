function [Config,Movement] = Node2ConfigStruct(Node)
Config.Status = Node{:,"ConfigMat"}{1};
Config.Row = Node{:,"ConfigRow"};
Config.Col = Node{:,"ConfigCol"};
Config.Str = Node.ConfigStr;
Config.Type = Node.Type;

Movement.dir = Node.Dir;
Movement.step = Node.Step;




end
