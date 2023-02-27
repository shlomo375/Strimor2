function V = ShowValume(Volume,V)
if nargin < 2
    intensity = [0 20 40 120 220 1024];
    alpha = [0 0 0.10 0.25 0.33 0.45];
    color = ([0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255])/ 255;
    queryPoints = linspace(min(intensity),max(intensity),256);
    amap = interp1(intensity,alpha,queryPoints)';
    cmap = interp1(intensity,color,queryPoints);

    V = volshow(Volume,Colormap=cmap,Alphamap=amap);
    V.OverlayColormap = [0,0,0;1,0,0; 0,1,0; 0,0,1];
    V.OverlayAlphamap = [0,1,1,1];
    V.OverlayRenderingStyle = "LabelOverlay";
    
else
    Volume([1:2,end-1:end],:,:) = 0;
    Volume(:,[1:2,end-1:end],:) = 0;
    Volume(:,:,[1:2,end-1:end]) = 0;
    
    V.OverlayData = Volume;
    
    

end

end
