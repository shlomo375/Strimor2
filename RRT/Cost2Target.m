function Cost = Cost2Target(Config,ConfigType,Target,TargetType)
ConfigType = GetFullType(Config,ConfigType);
TargetType = GetFullType(Target,TargetType);
Cost = max(conv2(logical(Config).*ConfigType,logical(Target).*TargetType,'same'),[],'all');

end
