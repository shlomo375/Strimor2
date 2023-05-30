function Tree = AddManuversInfo(Tree,Decision,MoveNum)

try
ManuverNum = Tree.Data{Tree.LastIndex-MoveNum,'Manuver_num'}+1;
Tree.Data(Tree.LastIndex-MoveNum+1:Tree.LastIndex,{'Manuver','Manuver_num'}) = repmat({Decision,ManuverNum},MoveNum,1);
catch eeee
    throw(eeee)
end
end
