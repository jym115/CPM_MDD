%load connectivity edges (named "all_conn_valid") and behavior data (named "score") from all subjects

total= size(all_conn_valid, 1)
YFit=zeros(1,total);
thr = [0.001:0.001:0.01];%edge selection threshold
  R_all=zeros(1,length(thr));
  P_all=zeros(1,length(thr));
  R2_all=zeros(1,length(thr));
for m = 1:length(thr)
    thresh=thr(m);
  for i = 1:total
    
    train = all_conn_valid;
    train(i, :) = [];
    
    train_score = score;
    train_score(i) = [];
    
    [r, p] = corr( train, train_score);

    pos_edge = find( p<thresh & r>0);
    neg_edge = find( p<thresh & r<0);
    
    pos_sum = sum( train(:, pos_edge), 2);
    neg_sum = sum( train(:, neg_edge), 2);
    
    test_pos_sum = sum(all_conn_valid(i, pos_edge));
    test_neg_sum = sum(all_conn_valid(i, neg_edge));
    
    %linear regression model
        b = regress( train_score, [ones(total-1, 1), pos_sum, neg_sum]);
        YFit(i) = [1 test_pos_sum test_neg_sum] *b;
    end 

[r, p] = corr( YFit', score);
mse = sum((YFit' - score).^2) / length(score);
R2 = 1 - mse / var(score, 1);
R_all(m)=r;
P_all(m)=p;
R2_all(m)=R2;


end
%% permutation test
% load R2_true under the selected edge selection threshold(from the above R2_all).
%load connectivity edges (named "all_conn_valid") and behavior data (named "score") from all subjects

thresh = 0.002;%edge selection threshold
total=size(all_conn_valid,1);

N_iteration = 5000;
R2_per = zeros(N_iteration, 1);

for it = 1:N_iteration
    no_per = [randperm(total)]';
    score=scorehamd(no_per,:);
    
    predict = zeros(1, total);
 
 for i = 1:total
    
    train = all_conn_valid;
    train(i, :) = [];
    
    train_score = score;
    train_score(i) = [];
    
    [r, p] = corr( train, train_score);
    pos_edge = find( p<thresh & r>0);
    neg_edge = find( p<thresh & r<0);
    
    pos_sum = sum( train(:, pos_edge), 2);
    neg_sum = sum( train(:, neg_edge), 2);
    
    test_pos_sum = sum(all_conn_valid(i, pos_edge));
    test_neg_sum = sum(all_conn_valid(i, neg_edge));
    
    %linear regression model
        b = regress( train_score, [ones(total-1, 1), pos_sum, neg_sum]);
        YFit(i) = [1 test_pos_sum test_neg_sum] *b;
    end 

mse = sum((YFit' - score).^2) / length(score);
R2 = 1 - mse / var(score, 1);
R2_per(it,1)=R2;

end
p_permutation=length(find(R2_per>R2_ture))/it;
