function [GroupsSizes, GroupIndexes, GroupInd] = ConfigGroupSizesNew(Config, ConfigType, R)
    [rows, cols] = find(Config);
    num_lines = max(rows);
    GroupIndexes = accumarray(rows, cols, [], @(x) {x});
    GroupsSizes = zeros(num_lines, numel(GroupIndexes{1}));
    GroupInd = cell(num_lines, 1);

    for i = 1:num_lines
        if isempty(GroupIndexes{i})
            continue;
        end
        
        GroupIndexes{i} = unique(GroupIndexes{i});
        group_size = numel(GroupIndexes{i});
        group_type = ConfigType(i, GroupIndexes{i}(1));
        GroupsSizes(i, 1:group_size) = group_size * group_type;

        if nargin == 3
            GroupIndexes{i} = sort(GroupIndexes{i});
            GroupInd{i} = R(sub2ind(size(R), i * ones(1, group_size), GroupIndexes{i}));
        end
    end
    
    non_empty_rows = any(GroupsSizes, 2);
    GroupsSizes = GroupsSizes(non_empty_rows, :);
    GroupInd = GroupInd(non_empty_rows);
    GroupIndexes = GroupIndexes(non_empty_rows);
end
