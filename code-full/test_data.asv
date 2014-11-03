function [pos, neg, test] = test_data(name)
% this function is very dataset specific, you need to modify the code if
% you want to apply the pose algorithm on some other dataset

% it converts the various data format of different dataset into unique
% format for pose detection 
% the unique format for pose detection contains below data structure
%   pos:
%     pos(i).im: filename for the image containing i-th human 
%     pos(i).point: pose keypoints for the i-th human
%   neg:
%     neg(i).im: filename for the image contraining no human
%   test:
%     test(i).im: filename for i-th testing image
% This function also prepares flipped images and slightly rotated images for training.

globals;
   
cls = [name '_data'];
try
	load([cachedir cls]);
catch
  trainfrs_pos = 1:3000; % training frames for positive
  testfrs_pos = 3001:6285; % testing frames for positive
  trainfrs_neg = 615:1832; % training frames for negative 

  % -------------------
  % grab positive annotation and image information
  load TEST/data.mat;
  posims = 'TEST/seq_%.6d.jpg';
  pos = [];
  numpos = 0;
  for fr = trainfrs_pos
    temp(1,:) = data(fr,6:7) + data(fr,8:9)/2 ;
    temp(2,:) = data(fr,2:3) + data(fr,4:5)/2 ;
    pos(numpos).point = temp;
    if temp(2,2) < 140
        continue ;
    end
    numpos = numpos + 1;
    n = data(fr,1) ;
    pos(numpos).im = sprintf(posims,n);
    pos(numpos).x1(1,1) = data(fr,6);
    pos(numpos).x1(2,1) = data(fr,2);
    pos(numpos).y1(1,1) = data(fr,7);
    pos(numpos).y1(2,1) = data(fr,3);
    pos(numpos).x2(1,1) = data(fr,6) + data(fr,8);
    pos(numpos).x2(2,1) = data(fr,2) + data(fr,4);
    pos(numpos).y2(1,1) = data(fr,7) + data(fr,9);
    pos(numpos).y2(2,1) = data(fr,3) + data(fr,5);
  end


  % -------------------
  % grab neagtive image information
  negims = 'INRIA/%.5d.jpg';
  neg = [];
  numneg = 0;
  for fr = trainfrs_neg
    numneg = numneg + 1;
    neg(numneg).im = sprintf(negims,fr);
  end

  % -------------------
  % grab testing image information 
  testims = 'TEST/seq_%.6d.jpg';
  test = [];
  numtest = 0;
  for fr = testfrs_pos
    numtest = numtest + 1;
    n = data(fr,1) ;
    test(numtest).im = sprintf(testims,n);
    temp1(1,:) = data(fr,6:7) + data(fr,8:9)/2 ;
    temp1(2,:) = data(fr,2:3) + data(fr,4:5)/2 ;
    test(numtest).point = temp1;
  end
  
  save([cachedir cls],'pos','neg','test');
end
