function Table = LoadTableFromMATPreview(FileName,prop)
try
Table = load(FileName);
f = fieldnames(Table);
Table = Table.(f{:});
catch
    Table = [];
end
end