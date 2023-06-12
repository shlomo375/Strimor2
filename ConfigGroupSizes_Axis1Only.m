function [GroupsSizes,GroupIndexes,GroupInd] = ConfigGroupSizes_Axis1Only(Config,ConfigType)
    
ReduceConfig = Config;
ColShift = find(~all(~Config,1),1)-1;
ReduceConfig(:,all(~Config,1)) = [];
ReduceConfig(all(~Config,2),:) = [];

GroupIndexes = cell(size(ReduceConfig,1),1);
GroupInd = cell(size(ReduceConfig,1),1);
GroupsSizes = zeros(size(ReduceConfig));
IndConfig = reshape(1:numel(Config),size(Config));
IndConfig(:,all(~Config,1)) = [];
IndConfig(all(~Config,2),:) = [];
StartGroup = true;
for Line = 1:size(ReduceConfig,1)
    GroupNum = 0;
    
    for Col = 1:size(ReduceConfig,2)
       
        if ReduceConfig(Line,Col)
            
            if StartGroup
                StartGroup = false;
                GroupNum = GroupNum + 1;
                StartCol = Col;
            end
            GroupsSizes(Line,GroupNum) = GroupsSizes(Line,GroupNum)+1;
        else
            if ~StartGroup
               
                GroupInd{Line}{GroupNum} = IndConfig(Line,StartCol:Col-1);
                GroupIndexes{Line}{GroupNum} = ColShift + (StartCol:Col-1);
                GroupsSizes(Line,GroupNum) = GroupsSizes(Line,GroupNum)*ConfigType(IndConfig(Line,StartCol));
                
            end
            StartGroup = true;
        end
        if Col == size(ReduceConfig,2) && ReduceConfig(Line,Col)
            if ~StartGroup
                GroupInd{Line}{GroupNum} = IndConfig(Line,StartCol:Col);
                    GroupIndexes{Line}{GroupNum} =  ColShift + (StartCol:Col);
                GroupsSizes(Line,GroupNum) = GroupsSizes(Line,GroupNum)*ConfigType(IndConfig(Line,StartCol));
            end
            StartGroup = true;
        end
        
    end
    StartGroup = true;
        
end
GroupsSizes(:,all(~GroupsSizes,1)) = [];
end