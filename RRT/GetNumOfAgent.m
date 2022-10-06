function Agent = GetNumOfAgent(Config)
    Agent = cellfun(@(x) sum(logical(x),"all"),Config);

end
