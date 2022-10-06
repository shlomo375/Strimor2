function p=WaitProgress(Progress, id, total,wait)
persistent TOTAL COUNT WAIT ID
if nargin == 4
    % initialisation mode
    WAIT = [WAIT wait];
    TOTAL = [TOTAL total];
    COUNT = [COUNT 0];
    ID = [ID id];
else
    if nargin == 0
        for ii = 1:numel(WAIT)
            delete(WAIT(ii));
        end
        WAIT = [];
        TOTAL = [];
        COUNT = [];
        ID = [];
        
    else
        % afterEach call, increment COUNT
        Loc = (Progress{1}==ID);
        COUNT(Loc) = Progress{2} + COUNT(Loc);
        p = COUNT(Loc) / TOTAL(Loc);
        WAIT(Loc).Visible = "on";
        waitbar(p, WAIT(Loc),num2str(COUNT(Loc))+"/"+num2str(TOTAL(Loc)));
        if p>=0.9
            delete(WAIT(Loc));
        end


    end
end

end
