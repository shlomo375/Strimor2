function Data2Send = MovingEachIndividualPartPC( WS, Agent, Parent)

Data2Send ={[],[]};
for dir = 1:length(Agent)
    for Comb = 1:length(Agent{dir})
        OK = true;
        step = 0;
        while OK
            step = step + 1;
            [OK, Configuration, Movment] = MakeAMove(WS,dir,step,Agent{dir}{Comb}');
            if OK
                if WS.Algoritem == "RRT*"
                    Data2Send(end+1,:) = {[Configuration.Dec,Configuration.Type,Parent,Movment.dir,Movment.step,numel(Movment.Agent)],Configuration};
                    
                end
            end
        end
        
        OK = true;
        step = 0;
        while OK
            step = step - 1;
            [OK, Configuration, Movment] = MakeAMove(WS,dir,step,Agent{dir}{Comb}');
            if OK
                
                if WS.Algoritem == "RRT*"

                    Data2Send(end+1,:) = {[Configuration.Dec,Configuration.Type,Parent,Movment.dir,Movment.step,numel(Movment.Agent)],Configuration};
                    
                end
            end
        end
    
    end
end

end
