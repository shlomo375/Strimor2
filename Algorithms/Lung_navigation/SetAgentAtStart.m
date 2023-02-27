function Agents = SetAgentAtStart(Space,StartSliceNum)
if StartSliceNum < 3
    StartSliceNum = 3;
end
figure(2)
imshow(Space(:,:,StartSliceNum),[]);

hold on;
[x,y] = ginput(1);
plot(x,y,"o");

Agents = [x,y,StartSliceNum];



end
