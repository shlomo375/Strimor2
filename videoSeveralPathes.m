clear
SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);


load("ArticleMovie\FullPath_IM_tree_8.mat","NewPath","Path");
Frames_Path_IM_8_a = MakeVideoOfPath(Path(1:8,:), 23, 60, "ArticleMovie\Path_IM_8_a.avi");
save("Frames_Path_IM_8_a.mat","Frames_Path_IM_8_a","-v7.3")
clear("Frames_Path_IM_8_a")
Frames_Path_IM_8_b = MakeVideoOfPath(Path(9:end,:), 23, 60, "ArticleMovie\Path_IM_8_b.avi");
save("Frames_Path_IM_8_b.mat","Frames_Path_IM_8_b","-v7.3")
clear("Frames_Path_IM_8_b")

load("ArticleMovie\Results-23N-uniform_3-tree_8.mat","Path");
Frames_Path_8_a = MakeVideoOfPath(Path(1:18,:), 23, 60, "ArticleMovie\Path_8_a.avi");
save("Frames_Path_8_a.mat","Frames_Path_8_a","-v7.3")
clear("Frames_Path_8_a")
Frames_Path_8_b = MakeVideoOfPath(Path(19:end,:), 23, 60, "ArticleMovie\Path_8_b.avi");
save("Frames_Path_8_b.mat","Frames_Path_8_b","-v7.3")
clear("Frames_Path_8_b")



load("ArticleMovie\FullPath_IM_tree_8.mat","Path");
Frames_Path_IM_8_a = MakeVideoOfPath(Path(1:8,:), 23, 60, "ArticleMovie\Path_IM_8_a.avi",[],1);
save("Frames_Path_IM_8_a_shade.mat","Frames_Path_IM_8_a","-v7.3")
clear("Frames_Path_IM_8_a")
Frames_Path_IM_8_b = MakeVideoOfPath(Path(9:end,:), 23, 60, "ArticleMovie\Path_IM_8_b.avi",[],1);
save("Frames_Path_IM_8_b_shade.mat","Frames_Path_IM_8_b","-v7.3")
clear("Frames_Path_IM_8_b")

load("ArticleMovie\Results-23N-uniform_3-tree_8.mat","Path");
Frames_Path_8_a = MakeVideoOfPath(Path(1:18,:), 23, 60, "ArticleMovie\Path_8_a.avi",[],1);
save("Frames_Path_8_a_shade.mat","Frames_Path_8_a","-v7.3")
clear("Frames_Path_8_a")
Frames_Path_8_b = MakeVideoOfPath(Path(19:end,:), 23, 60, "ArticleMovie\Path_8_b.avi",[],1);
save("Frames_Path_8_b_shade.mat","Frames_Path_8_b","-v7.3")
clear("Frames_Path_8_b")






% video = VideoWriter("ArticleMovie\Path_8_Full.avi");
% video.Quality = 100;
% video.FrameRate = 30;
% open(video);
% writeVideo(video,flip(frames,4));
% close(video);
% 
% 
% 
% video = VideoWriter("ArticleMovie\Path_IM_8_Full.avi");
% video.Quality = 100;
% video.FrameRate = 30;

% load("ArticleMovie\FullPath_IM_tree_6.mat","NewPath","Path");
% MakeVideoOfPath(Path(1:6,:), 23, 30, "ArticleMovie\Path_IM_6_a.avi")
% MakeVideoOfPath(Path(7:end,:), 23, 30, "ArticleMovie\Path_IM_6_b.avi")
% 
% load("ArticleMovie\Results-23N-uniform_3-tree_6.mat","Path");
% MakeVideoOfPath(Path(1:10,:), 23, 30, "ArticleMovie\Path_6_a.avi")
% MakeVideoOfPath(Path(11:end,:), 23, 30, "ArticleMovie\Path_6_b.avi")