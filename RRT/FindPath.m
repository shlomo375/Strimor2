function Path = FindPath(tree, ConfigTarget)
Path = FindConfigInTree(tree, ConfigTarget);
if isempty(Path)
    return
end
while Path(end).Index ~= 1
    Path(end+1) = tree(Path(end).parent);
end
Path = flip(Path)
end
