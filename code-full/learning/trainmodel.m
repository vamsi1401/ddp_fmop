function [model, K] = trainmodel(name,pos,neg,K,pa,sbin)

globals;

file = [cachedir name '.log'];
delete(file);
diary(file);

cls = [name '_cluster_' num2str(K')'];
try
  load([cachedir cls]);
catch
  model = initmodel(pos,sbin);
  disp('done init') ;
  def = data_def(pos,model);
  disp('done def') ;
  idx = clusterparts(def,K,pa);
  disp('done clust') ;
  save([cachedir cls],'def','idx');
end

for p = 1:length(pa)
  cls = [name '_part_' num2str(p) '_mix_' num2str(K(p))];
  try
    load([cachedir cls]);
  catch
    sneg = neg(1:min(length(neg),100));
    model = initmodel(pos,sbin);
    models = cell(1,K(p));
    for k = 1:K(p)
      spos = pos(idx{p} == k);
      for n = 1:length(spos)
        spos(n).x1 = spos(n).x1(p);
        spos(n).y1 = spos(n).y1(p);
        spos(n).x2 = spos(n).x2(p);
        spos(n).y2 = spos(n).y2(p);
      end
      models{k} = train(cls,model,spos,sneg,1,1);
    end
    model = mergemodels(models);
    save([cachedir cls],'model');
  end
end

% cls = [name '_final1_' num2str(K')'];
% try
%   load([cachedir cls]);
% catch
%   model = buildmodel(name,model,def,idx,K,pa);
%   for p = 1:length(pa)
% 		for n = 1:length(pos)
% 			pos(n).mix(p) = idx{p}(n);
% 		end
% 	end
%   model = train(cls,model,pos,neg,0,1);
%   save([cachedir cls],'model');
% end

%clear model ;

K = [6,5] ;
try
 load('cache/TEST_part_1_mix_6.mat');
catch
clear model ;
load('cache/TEST_part_2_mix_5.mat') ;
filters(1:5) = model.filters(1:5) ;
bias(1:5) = model.bias(1:5) ;
load('cache/TEST_part_1_mix_1.mat') ;
model.bias(2:6)= bias(1:5);
model.filters(2:6) = filters(1:5);
model.len = model.len * 6 ;
for i1=2:6
    model.filters(i1).i = model.filters(i1).i +513 ;
    model.bias(i1).i = model.bias(i1).i +513 ;
end
save('cache/TEST_part_1_mix_6.mat', 'model') ;
end

model = buildmodel(name,model,def,idx,K,pa);
save('cache/TEST_tempmodel.mat','model') ;

cls = [name '_final_' num2str(K')'];
try
 load([cachedir cls]);
catch
 if isfield(pos,'mix')
   pos = rmfield(pos,'mix');
 end
 model = train(cls,model,pos,neg,0,1);
 save([cachedir cls],'model');
end
