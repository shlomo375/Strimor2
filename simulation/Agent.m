classdef Agent < matlab.mixin.SetGet
    properties 
        Name %{mustBeText}
        ID %{mustBeNumeric}
        Type = 0; %{mustBeNumeric} %Target=-1, ampty=0, active=1, pasive=2;
        Status = 0;%Target=-1, ampty=0, occupied=1, selected=2;
        Dir %{mustBeNumeric}
        Step %{mustBePositive}
    end
    methods
        
        function agent = Agent(name,id,type)
            if nargin~=0
                agent.Name = name;
                agent.ID = id;
                agent.Type = type;
            end
        end

        function obj = SetMovment(obj,dir,step)
            obj.Dir = dir;
            obj.Step = step;
        end
    end
end
