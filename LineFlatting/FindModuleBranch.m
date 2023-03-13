function ModuleInd = FindModuleBranch(WS, StartModule, NotToScan)

arguments
    WS (1,1) {mustBeA(WS,"WorkSpace")}
    StartModule (:,1) {mustBeVector,mustBeInteger,mustBePositive} = find(WS.Space.Status,1);
    NotToScan (:,1) {mustBeVector,mustBeInteger,mustBePositive} = [];
end

ScannedAgent = ~WS.Space.Status;
ScannedAgent(NotToScan) = true;
[~, ModuleInd] = ScanningAgentsFast(WS, ScannedAgent, StartModule,true);

end
