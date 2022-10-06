function finish = IsConnected(TreeFolder,ConnectedToStartChecked)
% OthersTreesFolders(matches(OthersTreesFolders,""))=[];
finish = false;
% if isempty(OthersTreesFolders) || ~any(~strcmp(OthersTreesFolders,""))
%     return
% end

InfoFile = fullfile(extractBefore(TreeFolder,"\tree"),"ConnectedTree.mat");
try
    load(InfoFile,"info","ConnectedToStart");
catch e
    e
    info = table();
    ConnectedToStart = "";
end
Tree2Check = ConnectedToStart(~matches(ConnectedToStart,ConnectedToStartChecked));
if isempty(Tree2Check)
    return
end
[Node, Path,PathLength, Connected2Tree] = IsTreeConnected(TreeFolder, Tree2Check);
if ~isempty(Connected2Tree)
    ConnectedToStart = unique([ConnectedToStart; TreeFolder])
    temp = table(TreeFolder,{Connected2Tree(:)},{Node},{PathLength}, {Path},'VariableNames',["TreeFolder","ConnectedTo","Node","PathLength","Path"]);
    info = [info;temp];
    

    save(TreeFolder+"\success.mat","Path","PathLength","ConnectedToStartChecked");
    SuccessDir = fullfile(extractBefore(TreeFolder,digitsPattern+"N\"),"MultyTreesResult");
    mkdir(SuccessDir);
    ResultFileName = replace(extractAfter(TreeFolder,"RRTtree\"),"\","-")+".mat";
    save(fullfile(SuccessDir,ResultFileName),"ResultFileName","Path","PathLength");
    
    
    save(InfoFile,"info","ConnectedToStart");
    if any(matches(ConnectedToStart,"1002"))
        finish = true;
    end
    return
end

ConnectedToStartChecked = ConnectedToStart;
save(TreeFolder+"\success.mat","ConnectedToStartChecked");

end
