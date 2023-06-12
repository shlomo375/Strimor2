load("Temp.mat")
for ii =500:numel(Problems)
    ii
    tic
    % if nnz(Problems{ii}{1}.ConfigMat{1})<=350
        [Tree,Error,msg] = SimpleShapeAlgorithm([],[],Problems{ii}{1},Problems{ii}{2},0)
    % end
    if Error
        d=5
    end
    toc
end
