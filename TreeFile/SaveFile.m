function NewFileName = SaveFile(FileName,Data)
MaxConfigInFile = 5e5;
ii = 1;
while ~isempty(Data)
    NewFileName = FileName + "_p"+string(ii)+".mat";
    ii = ii + 1;
    if size(Data,1)>MaxConfigInFile
        FileData = Data(1:MaxConfigInFile,:);
        Data(1:MaxConfigInFile,:) = [];
    else
        FileData = Data;
        Data = [];
    end
    save(NewFileName,"FileData");
end

end
