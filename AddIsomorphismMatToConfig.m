function NewConfig = AddIsomorphismMatToConfig(Config,ZoneMatrix,RotationMatrices)
arguments
    Config
    ZoneMatrix = true
    RotationMatrices = [];
end
ConfigFullType = GetFullType(Config{1,"ConfigMat"}{:},Config.Type);

[StartConfigIsomorphism, StartConfigIsomorphismStr,IsomorpSizes] = CreatIsomorphismMetrices(Config{1,"ConfigMat"}{:},ConfigFullType,RotationMatrices,"ZoneMatrix",ZoneMatrix);

try
    NewConfig = [Config(1,1:end-1), table(StartConfigIsomorphism(1)...
                       ,StartConfigIsomorphism(2),StartConfigIsomorphism(3),...
                       StartConfigIsomorphismStr(1),StartConfigIsomorphismStr(2),StartConfigIsomorphismStr(3),IsomorpSizes(1,1),IsomorpSizes(1,2),IsomorpSizes(2,1),IsomorpSizes(2,2),IsomorpSizes(3,1),IsomorpSizes(3,2),...
                       'VariableNames',{'IsomorphismMatrices1','IsomorphismMatrices2'...
                       ,'IsomorphismMatrices3','IsomorphismStr1','IsomorphismStr2','IsomorphismStr3','IsoSiz1r','IsoSiz1c','IsoSiz2r','IsoSiz2c','IsoSiz3r','IsoSiz3c'})];
catch
    Config{1,"IsomorphismMatrices1"} = StartConfigIsomorphism(1);
    NewConfig = Config;
end

end
