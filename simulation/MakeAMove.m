function [OK, Configuration, Movment, WS1, CollidingAgent] = MakeAMove(WS,dir,step, Agent)
    Configuration = [];
    
    Movment = WorkSpace.MovmentStructure(dir,step,Agent);

    [OK, MoveAgent2Ind, CollidingAgent, Alert] = ApproveMovment(WS,Movment,"Slide");


    if OK

        WS1 = ChangeAgentLoc(WS,MoveAgent2Ind,Movment.Agent);

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
end
