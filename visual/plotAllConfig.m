function plotAllConfig(TreeArray, Size)
BasicWS = WorkSpace(Size,"RRT*");
for i=1:size(TreeArray,2)
    i
    figure(i);
  
    WS = SetConfigurationOnSpace(BasicWS,TreeArray(i).Config);
    PlotWorkSpace(WS);
%     drawnow

%     figure(3);
%   
%     WS = SetConfigurationOnSpace(BasicWS,TreeArray(i+1).Config);
%     PlotWorkSpace(WS);
% %     drawnow
% 
%     figure(4);
%   
%     WS = SetConfigurationOnSpace(BasicWS,TreeArray(i+2).Config);
%     PlotWorkSpace(WS);
% %     drawnow
% 
%     figure(5);
%   
%     WS = SetConfigurationOnSpace(BasicWS,TreeArray(i+3).Config);
%     PlotWorkSpace(WS);
%     drawnow

end
end
