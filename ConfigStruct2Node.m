function Node = ConfigStruct2Node(Node,Config,dir,step)
% VarName = {'time','Index','ParentIndex','Type','Level','Cost','Dir','Step','ConfigRow','ConfigCol','ParentRow','ParentCol','Visits','Cost2Target','ConfigStr','ParentStr','ConfigMat','ParentMat','Childs'};
% VarType = {'duration','double','double','double','double','double','double','double','double','double','double','double','double','double','string','string','cell','cell','cell'};
% Node = CreateNode(1);

Node.ConfigMat = {Config.Status};
Node.ConfigRow = Config.Row;
Node.ConfigStr = Config.Str;
Node.ConfigCol = Config.Col;
Node.Type = Config.Type;

if nargin>2
    Node.Dir = dir;
    Node.Step = step;
end


end
