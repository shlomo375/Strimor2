function [OK, Configuration, Movment, WS1, CollidingAgent] = MakeAMove(WS,dir,step, Agent)
    Configuration = [];
    
    WS1 = WS;
    Movment = WorkSpace.MovmentStructure(dir,step,Agent);
%     q =tic;
    [OK, MoveAgent2Ind, CollidingAgent, Alert] = ApproveMovment(WS,Movment,"Slide");
%     fprintf('%s\n',toc(q)+" approve   ");

    if OK
%         e = tic;
        WS1 = ChangeAgentLoc(WS,MoveAgent2Ind,Movment.Agent);
%         fprintf('%s\n',toc(e)+" change   ");
%          PlotWorkSpace(WS);
%          drawnow;
%          pause(2);
%         w = tic;
        try
        [OK, Alert] = SplittingCheck(WS1,MoveAgent2Ind(1));
%         OK = SplittingCheckSlow(WS);
        catch e
            fprintf(e.identifier);
        end
%         fprintf('%s\n',toc(w)+" split   ");
        if OK
            Configuration = GetConfiguration(WS1);
            if size(Configuration.Status,2)>35
                Configuration.Status
            end
%             if GetNumOfAgent({Configuration.Status})<50
%                 d=5;
%             end
        end
    end
end
