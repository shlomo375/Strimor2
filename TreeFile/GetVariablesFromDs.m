function [data, FileIndex] = GetVariablesFromDs(ds,Variables,ConfigIndex,FileIndex)
data = [];
LastTotalIndex = 0;
if nargin<4
   try
       [FileName, Files.Visits, Files.Cost2Target] = LoadInfoFile(ds);
   catch
       Files.Visits = ones(sum(contains(ds.Files,"size")),1);
   end
   if ~isempty(Files.Visits)
       
       file_index = TreeClass.RandConfig(Files,[],4); %4 file
%        file_index = randi(numel(ds.Files),[4,1]);
       FileLocInDs = @(index) find(contains(ds.Files,FileName(index)));
       FileIndex = arrayfun(FileLocInDs,file_index,'UniformOutput',false);
       FileIndex = unique(cell2mat(FileIndex));

   else
       FileIndex = 2+randperm(size(ds.Files,1)-2,round(size(ds.Files,1)*0.1)+1);
   end
end
if nargin >= 3
    ConfigIndex = unique(ConfigIndex);
end
for ii = FileIndex
    Table = LoadTableFromMATPreview(ds.Files{ii});
try
    if nargin >= 3
        TotalIndex = LastTotalIndex + size(Table,1);
        while TotalIndex>=ConfigIndex(1)
            data = [data; Table(ConfigIndex(1)-LastTotalIndex,:)];
            ConfigIndex(1) = [];
            if isempty(ConfigIndex)
                return
            end
        end
        if isempty(ConfigIndex)
            return
        end
        LastTotalIndex = TotalIndex;
    else
        data = [data ;Table{:,Variables}];
    end
    clear Table; 
catch e
    d=1
end
end
    

end
