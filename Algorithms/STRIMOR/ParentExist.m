function [OK, ParentLoc] = ParentExist(ConfigIndex,Parent,tree)
temp = tree.Data(ConfigIndex,["ParentRow","ParentCol","ParentStr"]);
temp.Properties.VariableNames = ["ConfigRow","ConfigCol","ConfigStr"];
[ParentExist,ParentLoc] = ismember(temp,tree.Data(Parent,["ConfigRow","ConfigCol","ConfigStr"]));
OK = any(ParentExist);

end