pno = 1;
model_this = importdata(['cache/TEST_part_' num2str(pno) '_mix_5.mat']);
for i=1:min(16,numel(model_this.components))
    subplot(4,4,i);
    myvisualizemodel(model_this,i);
end
suptitle(['part: ' num2str(pno)]);