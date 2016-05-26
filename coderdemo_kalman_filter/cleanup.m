if isempty(currentFigures), currentFigures = []; end;
close(setdiff(findall(0, 'type', 'figure'), currentFigures))
clear mex
delete *.mexmaci64
[~,~,~] = rmdir('/Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/codegen','s');
clear /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/ObjTrack.m
delete /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/ObjTrack.m
clear /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/kalman_loop.m
delete /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/kalman_loop.m
clear /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/kalmanfilter.m
delete /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/kalmanfilter.m
clear /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/plot_trajectory.m
delete /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/plot_trajectory.m
delete /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/position.mat
clear
load old_workspace
delete old_workspace.mat
delete /Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter/cleanup.m
cd /Users/chenyanghuang/Documents/MATLAB
rmdir('/Users/chenyanghuang/Documents/MATLAB/coderdemo_kalman_filter','s');
