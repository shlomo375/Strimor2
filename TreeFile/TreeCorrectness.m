function Ok = TreeCorrectness(trees)
AgentNum = cellfun(@(x) sum(logical(x),'all'),trees{ii}.Config.Mat);
if sum(AgentNum ~= trees{ii}.N)
    Ok = "Tree not correct";
    return
end



end
