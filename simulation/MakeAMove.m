function [OK, Configuration, Movment, WS1, CollidingAgent,Alert] = MakeAMove(WS,dir,step, Agent)
    Configuration = [];
    
    Movment = WorkSpace.MovmentStructure(dir,step,Agent);

    [OK, MoveAgent2Ind, CollidingAgent, Alert] = ApproveMovment(WS,Movment,"Slide");
    % if matches(Alert,"movment outside workspace area.")
    %     disp(Alert);
    % end
    if OK
        NewInd = UpdateLinearIndex(WS.SpaceSize,Movment.Agent,Movment.dir,Movment.step);
        WS1 = ChangeAgentLoc(WS,NewInd',Movment.Agent);

        try
        [OK, Alert] = SplittingCheck(WS1,MoveAgent2Ind(1));

        catch e
            fprintf(e.identifier);
        end

        if OK
            Configuration = GetConfiguration(WS1);

        end
    else
        WS1=WS;
    end
    WS1.Space.Status(WS1.Space.Status>1) = 1;
end
