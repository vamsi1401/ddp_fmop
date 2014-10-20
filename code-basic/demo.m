addpath visualization;
if isunix()
  addpath mex_unix;
elseif ispc()
  addpath mex_pc;
end

compile;

% load and display model
load('TEST_final_65');
visualizemodel(model);
disp('model template visualization');
disp('press any key to continue'); 
pause;
visualizeskeleton(model);
disp('model tree visualization');
disp('press any key to continue'); 
pause;

imlist = {};%dir('images/*.jpg');
for i = 1%:length(imlist)
    % load and display image
    im = imread('seq_002000.jpg');
    clf; imagesc(im); axis image; axis off; drawnow;

    % call detect function
    tic;
    boxes = detect_fast(im, model, min(model.thresh,-1));
    dettime = toc; % record cpu time
    boxes = nms(boxes, .1); % nonmaximal suppression
    colorset = {'g','y'};
    showboxes(im, boxes(1:8,:
    ),colorset); % show the best detection
    %showboxes(im, boxes,colorset);  % show all detections
    fprintf('detection took %.1f seconds\n',dettime);
    disp('press any key to continue');
    pause;
end

disp('done');
