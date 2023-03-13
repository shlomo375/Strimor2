function FrontLineModule = Temp(StartModule, GroupInd, Axis)

if Axis == 3
    mask = cellfun(@(x) any(x{1} == StartModule), GroupInd);
    FrontLineModule = GroupInd{mask}{1};
else
    mask = cellfun(@(x) any(x{end} == StartModule), GroupInd);
    FrontLineModule = GroupInd{mask}{end};
end

end
