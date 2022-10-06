function Cost = GetCost2Target(Target, Config)
    Target = logical(Target.Status);
    Config = logical(Config.Status);

    t = ones(size(Target,1),1);
    t(1:2:end)=-1;
    if t(find(Target,1)) == Target.Type

end