function Loc = FindConfigInTree(Tree ,ConfigDec)
Loc = ismember(ConfigDec,Tree.Dec);

% AllConfig = [Tree.Config];
% Loc = arrayfun(@(x) ismember(Config.Dec,x.Config.Dec),Tree);
% AllConfigDec = [AllConfig.Dec];
% Loc = ismember(AllConfigDec, Config.Dec);
% Node = Tree(Loc);
% AllConfigDesimal = arrayfun(@(x) bin2dec(strjoin(string(x.Status(:)))),AllConfig,'UniformOutput',false);
end
