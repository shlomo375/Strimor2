function [OK, tree] = MoveAgentGroup(WS,dir,Comb,step,Agent,tree,Parent)
[OK, Configuration, Movment] = MakeAMove(WS,dir,step,Agent{dir}{Comb}');
if OK
    
    if WS.Algoritem == "RRT*"
        
        [~, ParentCost, ParentLevel] = Get(tree,Parent,"Cost","Level");
%         a = tree.Data{Parent,["Cost","Level"]};
%         ParentCost = a(1);
%         ParentLevel = a(2);
        [Level, Cost] = CostFunction(Movment, ParentCost, ParentLevel);
%% overlap cost target 
%         CostToTarget = Cost2Target(Configuration.Status,Configuration.Type,tree.EndConfig.ConfigMat{:},tree.EndConfig.Type);
%% group cost target
%         CostToTarget = Cost2TargetLines(Configuration,tree);
%% without cost taget
        CostToTarget = 1;
%%
WS1=WS;
WS1.Space.Status = zeros(WS.SpaceSize);
WS1=SetConfigurationOnSpace(WS1,Configuration);
figure(2)
PlotWorkSpace(WS1,[])
try
        [tree,~,ConfigIndex] = UpdateTree(tree, Parent, Configuration, Movment, Level, Cost,CostToTarget);
catch ME_UpdateTree
    ME_UpdateTree
    throw(ME_UpdateTree)
end
%         if tree.LastIndex > size(unique(tree.Data(1:tree.LastIndex,["ConfigStr","ConfigRow","ConfigCol"])),1)
%             fprintf("Problem");
%             d=5
%         end
        
        if ~isnan(tree.NumOfIsomorphismAxis)
            IsomorphisemStrs = tree.Data{ConfigIndex,["IsomorphismStr1","IsomorphismStr2","IsomorphismStr3"]};
            IsomorphisemMatrices = tree.Data{ConfigIndex,["IsomorphismMatrices1","IsomorphismMatrices2","IsomorphismMatrices3"]};
            EndConfigIsomorphismStr = [tree.EndConfig.IsomorphismStr1,tree.EndConfig.IsomorphismStr2,tree.EndConfig.IsomorphismStr3];
            
            try
                finish = CompareIsomorphism(IsomorphisemStrs,IsomorphisemMatrices,EndConfigIsomorphismStr,tree.EndConfig_IsomorphismMetrices);
            catch ME_CompareIsomorphism
                ME_CompareIsomorphism
            end
            if finish
                tree = SetEndConfig(tree,tree.Data(ConfigIndex,:));
            end
        else
            finish = strcmp(Configuration.Str,tree.EndConfig.ConfigStr) &&...
                (Configuration.Row == tree.EndConfig.ConfigRow) &&...
                (Configuration.Col == tree.EndConfig.ConfigCol);
        end
        if (finish)

            fprintf("sulotion found!!!");
            OK = 2;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            return
        end
    end
end

end
