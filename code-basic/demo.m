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

%imlist = dir('C:/Users/Vamsi/Documents/GitHub/ddp_fmop/code-full/TEST/*.jpg');
for i = 1:2000%length(imlist)
    % load and display image
    im = imread(sprintf('C:/Users/Vamsi/Documents/GitHub/ddp_fmop/code-full/TEST/seq_%0.6d.jpg',i));
    clf; imagesc(im); axis image; axis off; drawnow;

    % call detect function
    tic;
    boxes = detect_fast(im, model, min(model.thresh,-1));
    dettime = toc; % record cpu time
    bb_max_height = 45.0 ;
    bb_min_height = 13.0 ;
    %bb_max_width = 65.0 ;
    %bb_min_width = 15.0 ;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    i2 = 1 ;
    for i1 = 1:length(boxes)
        a = (boxes(i1,2) + boxes(i1,4))/2.0 ;
        height = ((bb_max_height - bb_min_height)*a)/479.0 + bb_min_height ;
        %width = ((bb_max_width - bb_min_width)*a)/479.0 + bb_min_width ;
        h1 = boxes(i1,4) - boxes(i1,2) ;
        %w1 = boxes(i1,1) - boxes(i1,3) ;
        if(h1/height < 1.1 && h1/height > 0.9)
            boxes1(i2,:) = boxes(i1,:);
            i2 = i2 +1 ;
        end 
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    boxes = nms(boxes1, .2); % nonmaximal suppression
    colorset = {'g','y'};
    showboxes(im, boxes(:,:),colorset); % show the best detection
    %showboxes(im, boxes,colorset);  % show all detections
    fprintf('detection took %.1f seconds\n',dettime);
    disp('press any key to continue');
    pause;
end

disp('done');
