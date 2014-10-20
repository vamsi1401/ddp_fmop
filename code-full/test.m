clc; close all; clear;
globals;
name = 'TEST';
% --------------------
% specify model parameters
% number of mixtures for 26 parts
K = [1 5]; 
% Tree structure for 26 parts: pa(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (PARSE_data.m) and evaluation (PARSE_eval_pcp)
pa = [0 1];
% Spatial resolution of HOG cell, interms of pixel width and hieght
% The PARSE dataset contains low-res people, so we use low-res parts
sbin = 4;
% --------------------
% Prepare training and testing images and part bounding boxes
% You will need to write custom *_data() functions for your own dataset
[pos neg test] = test_data(name);
disp('done test_data') ;
%----mod----pos = point2box(pos,pa);
% --------------------
% training
[model,K] = trainmodel(name,pos,neg,K,pa,sbin);
load cache/TEST_cluster_15 ;
for i=1:3000
    arr(i,:,:) = pos(i).point(:,:) ;
end    
gscatter(arr(:,2,1)-arr(:,1,1),arr(:,1,2)-arr(:,2,2),idx{2}) ;