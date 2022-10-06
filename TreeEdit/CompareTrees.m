function [connected, WorkerList] = CompareTrees(trees, WorkerList, NumWorkers)
connected = false;
t = tic;
Sizes1 = cell2mat(cellfun(@(x)size(x),trees{1}.Config.Mat(1:trees{1}.LastIndex),'UniformOutput',false));
Sizes2 = cell2mat(cellfun(@(x)size(x),trees{2}.Config.Mat(1:trees{2}.LastIndex),'UniformOutput',false));

WorkerList = Taskmaster(trees, WorkerList,NumWorkers);
if CompareStr2Tree(trees{1}.Config.Str(trees{1}.LastCompareIndex:trees{1}.LastIndex), ...
                    Sizes1(trees{1}.LastCompareIndex:trees{1}.LastIndex,:), ...
                    trees{2}.Config.Str, ...
                    Sizes2)
    connected = true;
    return
end

WorkerList = Taskmaster(trees, WorkerList,NumWorkers);
if CompareStr2Tree(trees{2}.Config.Str(trees{2}.LastCompareIndex:trees{2}.LastIndex), ...
                    Sizes2(trees{2}.LastCompareIndex:trees{2}.LastIndex,:), ...
                    trees{1}.Config.Str, ...
                    Sizes1)
    connected = true;
    return
end
fprintf("Compare time: "+ toc(t));

end
