function playMovie(frames, figHandle)

[tmp frameDim] = size(frames);
% number of times to play the movie
n = 2;
% frames per second
fps = 15;

% [h, w, p] = size(frames(1).cdata);  % use 1st frame to get dimensions
% hf = figure; 
% resize figure based on frame's w x h, and place at (150, 150)
% set(figHandle, 'position', [150 150 w h]);

axis off
% tell movie command to place frames at bottom left
movie(frames,n,fps);

