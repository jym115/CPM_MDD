
%load connectivity edges (named "test") and behavior data (named "score_test") from testing dataset.


no_test=size(test,1);
predict= zeros(1, no_test);
    test_neg_sum = sum(test(:,edge_neg_id), 2);
    test_pos_sum = sum(test(:,edge_pos_id), 2);

for i = 1:no_test
    predict(i) = [1 test_pos_sum(i) test_neg_sum(i) ] *b;
    
end

   [r,p]=corr( predict', score_test)
   SSresidual=0;
    SStotal=0;
    for ii=1:length(score_test)
    SSresidual=SSresidual+(score_test(ii,1)-predict2(1,ii))^2;
    SStotal=SStotal+(score_test(ii,1)-mean(score))^2;
    end
    R2_ture=1-SSresidual/SStotal
    
    %% permutation test

it=5000;
r2=zeros(it,1);
for i=1:it    
SSresidual=0;
SStotal=0;
shuffle_id=randperm(length(score_test))';
score_test_it=score_test(shuffle_id);
for ii=1:length(score_test_it)
    SSresidual=SSresidual+(score_test_it(ii,1)-predict2(1,ii))^2;
    SStotal=SStotal+(score_test_it(ii,1)-mean(score))^2;
end
R2=1-SSresidual/SStotal;
r2(i)=R2;
end
p_permutation=length(find(r2>R2_ture))/it


