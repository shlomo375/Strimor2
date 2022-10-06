function Str = NewConfigStr(ConfigMat,Type)
CompleteType = GetFullType(ConfigMat,Type);    
LogicalConfig = logical(ConfigMat);
CompleteConfig = double(LogicalConfig);
CompleteConfig(LogicalConfig) = CompleteType(LogicalConfig);
Str = join(string(CompleteConfig)',"");
end
