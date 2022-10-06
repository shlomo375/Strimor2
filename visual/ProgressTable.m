function ProgressTable(Data)
persistent Table
persistent CPS
persistent ConfigNum

if isstring(Data)
    VarType = {'string','double','double','double','double','string'};
    VarNames = {'Status','Loop','Config','MaxConfig','ConfigPerSec','ConfigNum'};
    Data = [extractAfter(Data,"N\"),"Total"];
    Table = table('Size',[5,6],'VariableTypes',VarType,'VariableNames',VarNames,...
        'RowNames',Data);
else 
    if isnumeric(Data)
        if numel(Data)>1
            ConfigNum = Data;
            Table{1:4,"ConfigNum"} = string(ConfigNum');
            Table{5,"ConfigNum"} = string(sum(ConfigNum))
        else
            CPS = Data;
            Table{"Total","ConfigPerSec"} = CPS;
        end
    else
        TreeName = Data{1};
        if matches(Data{2},"search")
            Table(TreeName,1:5) = Data(2:end);
        else
            Table(TreeName,[1 3 4]) = Data(2:end);
        end
        
            Table{"Total",3:end-2} = sum(Table{1:end-1,["Config","MaxConfig"]})
       
    end
end

end
