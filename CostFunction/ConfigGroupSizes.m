function [GroupsSizes,GroupIndexes,GroupInd] = ConfigGroupSizes(Config,ConfigType,R)
    Groups = num2cell(zeros(size(Config,1),1))';
    [row,col] = find(Config);
    try
        GroupIndexes = accumarray(row,col,[],@(x) {x});
        for Line_idx = 1:numel(GroupIndexes)
            if ~isempty(GroupIndexes{Line_idx})
                StartLine = Line_idx;
                GroupIndexes(1:StartLine-1) = [];
                break
            end

        end
    catch e
        e
        d=5;
    end
%     GroupType = zeros(numel(Group),1);
%     for Line_idx = 1:numel(Group)
%         GroupType(Line_idx) = ConfigType(Line_idx,Group{Line_idx}(1));
%     end

    func = @(x) accumarray(1+cumsum([0; (diff(x)~=1)]),x,[],@(y) {y});
    
    GroupIndexes = cellfun(func,GroupIndexes,'UniformOutput',false)';
    Groups(StartLine:StartLine-1+numel(GroupIndexes)) = GroupIndexes;
    
    MaxGroup = max(cellfun(@numel,Groups));
    NumberOfLines = numel(Groups);
    
    GroupsSizes = zeros(NumberOfLines,MaxGroup);
    
    GroupInd = cell(length(GroupIndexes),1);
    for Line_idx = StartLine:StartLine-1+numel(GroupIndexes)
        temp = cellfun(@numel,Groups{Line_idx})';
        tempType = cellfun(@(G) ConfigType(Line_idx,G(1)),Groups{Line_idx})';
        GroupsSizes(Line_idx,1:numel(temp)) = temp.*tempType;
        
        if nargin == 3
            GroupInd{Line_idx} = cellfun(@(col)R(sub2ind(size(R),repmat(Line_idx,[numel(col),1]),col)),GroupIndexes{Line_idx-StartLine+1},"UniformOutput",false);
        end
    end
    GroupIndexes = [cell(1,StartLine-1),GroupIndexes];

    if nargin==3
        GroupInd(1:StartLine-1) = [];
        GroupsSizes(~any(GroupsSizes,2),:) = [];
        GroupIndexes(1:StartLine-1) = [];
    end
end
