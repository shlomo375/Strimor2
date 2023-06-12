function [WS,Sucsses] = AddAgent(WS,type)
    Sucsses = false;
    [rows,cols] = find((WS.Space.Type ==type & logical(WS.Space.Status)));
    try
    agent = randi(numel(rows),1);
    catch e
        return
    end
    row = rows(agent);
    col = cols(agent);
    
    dir = randi(3,1)-2;
    switch dir
        case 1
            if ~WS.Space.Status(row,col+1)
                WS.Space.Status(row,col+1) = 1;
                Sucsses=true;
            end
           
        case -1
            if ~WS.Space.Status(row,col-1)
                WS.Space.Status(row,col-1) = 1;
                Sucsses=true;
            end
        case 0
            if type==1
                if ~WS.Space.Status(row-1,col)
                    WS.Space.Status(row-1,col) = 1;
                    Sucsses=true;
                end
            else
                if ~WS.Space.Status(row+1,col)
                    WS.Space.Status(row+1,col) = 1;
                    Sucsses=true;
                end
            end
    end


end