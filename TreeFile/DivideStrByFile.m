function StrGroup = DivideStrByFile(Strs,ConfigSize,info)
[~,~,ci] = unique(ConfigSize,"rows");
StrGroup = accumarray(ci,1:size(Strs,1),[],@(x){{ConfigSize(x,:),Strs(x),info(x,:)}});

end
