function Table = LockAndLoadDS(FileName,prop)

if LockAndOpenFile(FileName,"Lock")
    try
        Table = load(FileName);
        f = fieldnames(Table);
        Table = Table.(f{:});
    catch
        Table = [];
    end
    LockAndOpenFile(FileName,"Open");
else
    errorInLockAndLoad
end

end