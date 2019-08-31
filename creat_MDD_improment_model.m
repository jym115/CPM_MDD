
%create MDD improvement model

%% select consensus edge
%load connectivity edges (named "all_conn_valid") and behavior data (named "score") from all subjects

total= size(all_conn_valid, 1);
    pos=ones(1,length(all_conn_valid));%store positive consensus edge
    neg=ones(1,length(all_conn_valid));%store negative consensus edge
    
YFit=zeros(1,total);
thresh = 0.002;
 for i = 1:total
    
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
    pos_mask = zeros(1,length(all_conn_valid));
    pos_mask(pos_edge) = 1;
    neg_mask=zeros(1,length(all_conn_valid));
    neg_mask(neg_edge)=1;
    pos=pos_mask.*pos;
    neg=neg_mask.*neg;

end
%% create MDD improvement model
edge_pos_id=find(pos>0);
edge_neg_id=find(neg>0);

pos_sum = sum( all_conn_valid(:,edge_pos_id), 2);
neg_sum = sum( all_conn_valid(:,edge_neg_id), 2);
   

b = regress( score, [ones(size(all_conn_valid,1), 1),pos_sum neg_sum]);


