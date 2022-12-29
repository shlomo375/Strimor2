function [OK, Configuration, Movement, WS1, CollidingAgent] = MakeAMove(WS,dir,step, Agent)
    Configuration = [];
    WS1 = [];
    Movement = WorkSpace.MovmentStructure(dir,step,Agent);

    [OK, MoveAgent2Ind, CollidingAgent, Alert] = ApproveMovment(WS,Movement,"Slide");

    if OK

        WS1 = ChangeAgentLoc(WS,MoveAgent2Ind,Movement.Agent);

        try
        [OK, Alert] = SplittingCheck(WS1,MoveAgent2Ind(1));

        catch e
            fprintf(e.identifier);
        end

        if OK
            Configuration = GetConfiguration(WS1);

        end
    end
end
