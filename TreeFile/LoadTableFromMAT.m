function Table = LoadTableFromMAT(FileName)
% FileLock = replace(FileName,".mat",".txt");
% FileLock = insertAfter(FileLock,"Tree\","Locks\");
% FileFree = @(Name) ~exist(Name, 'file');

Table = load(FileName);
f = fieldnames(Table);
Table = Table.(f{:});
% while true
% 
%     if FileFree(FileLock) 
%         
%         fclose(fopen(FileLock, 'a'));
%         
%         Table = load(FileName);
%         f = fieldnames(Table);
%         Table = Table.(f{:});
%         
%         return
%     else
%         pause(.1); 
%     end
%     
% end


end
