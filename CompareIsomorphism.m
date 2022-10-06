function Connect = CompareIsomorphism(StrsA,MatricesA,StrsB,MatricesB)
if numel(StrsB) <=3
%     IsomorphisemStrs = tree.Data{ConfigIndex,["IsomorphismStr1","IsomorphismStr2","IsomorphismStr3"]};
%     EndConfigIsomorphismStr = [tree.EndConfig.IsomorphismStr1,tree.EndConfig.IsomorphismStr2,tree.EndConfig.IsomorphismStr3];
    StrComp = strcmp(StrsA,StrsB)';
    SizeComp = all([size(MatricesA{1});size(MatricesA{2});size(MatricesA{3})] ==...
        [size(MatricesB{1});size(MatricesB{2});size(MatricesB{3})],2);
    Connect = any(StrComp & SizeComp);
else



end



end
