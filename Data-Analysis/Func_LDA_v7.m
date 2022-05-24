function [validationAccuracy, WhiskersAccuracy, CM_Model]=Func_LDA_v6(X, y, target_variance)
% Func_LDA runs the LDA model in our data, and computes PCA for
% dimensionality reduction. Based from LDA_Draft_v3
% -v3 Added crossvalidation. Saves full model accuracy values for each time the -k_fold is being done. 
% Removes first rows of missing data, and then columns with missing data
% -v4 CM for each crossvalidation added
% -v5 Data partitioned first, and then PCA 
% -v6 Gives confusion matrix as an output
% -v7 Improves way to detect and eliminate NaNs values from the matrix

% X: feature matrix 
% y: class labels
% validation_percentage: percentage of data that will be used for
% validation. 100-validation_percentage will be used for training
% PCA_flag: tells you whether to run the model with dimensionality
% reduction or not
% plot_flag: 1 plots CM, 0 doesn't plot anything
% targe_variance: variance percentage that will be used to determine the
% number of principal components
kfold_val=10;
validationAccuracy=[];
WhiskersAccuracy=[];

% Removes NaN from data
[row, col]=find(isnan(X)==1);

while length(unique(row))==size(X,1) ||  length(unique(col))==size(X,2)
    if length(unique(col))==size(X,2)
        [n,bin] = hist(col,unique(col));
        if max(n)==size(X,1)
            temp=find(n==size(X,1));
            X(:,temp)=[]; % columns/channels missing with nan removed
            
        else
            temp=unique(row(1));
            X(temp,:)=[]; % rows with nan removed
            y(temp)=[];
        end
        [row, col]=find(isnan(X)==1);
        break
    end
    
    if length(unique(row))==size(X,1)
        [n,bin] = hist(row,unique(row));
        if max(n)==size(X,2)
            temp=find(n==size(X,2));
            X(temp,:)=[]; % rows with nan removed
            y(temp)=[];
        else 
            temp=unique(col(1));
            X(:,temp)=[]; % columns/channels missing with nan removed
        end
        
        [row, col]=find(isnan(X)==1);

    end

end

%temp=[row(1) row(2)];
if ~isempty(row)
    temp=unique(row(1:10));
    X(temp,:)=[]; % rows with nan removed
    y(temp)=[];
end
[row, col]=find(isnan(X)==1);
if ~isempty(col)
    temp=unique(col);
    X(:,temp)=[]; % columns/channels missing with nan removed
end


 % Runs denoising
%  X_noisy=X;
%  y_noisy=y;
%  [X,y] = TrialDenoise(X_noisy,y_noisy');

% % Perform cross-validation
% cvp = cvpartition(y,'KFold',10);
% 
% cvError = crossval('mcr',X,y,'Predfun',@func_class_PCA_LDA,'Partition',cvp)
% validationAccuracy=1-cvError;


%%%% Implemented CV for individual accuracies 
y=y';
indices=crossvalind('Kfold', y,kfold_val);
cp=classperf(y);

for j=1:kfold_val
    test = (indices==j);
    train = ~test;
    y_prediction = func_class_PCA_LDA(X(train,:),y(train),X(test,:)); %y predictions
%     classperf(cp,y_prediction, test);
    grpOrder=unique(y);
    [CM_Model] = confusionmat(y(test)',y_prediction, 'Order', grpOrder);
    
    for i=1:size(CM_Model)
        temp=nansum(CM_Model(i,:));
        CM_Model_prob(i,:)=CM_Model(i,:)./temp;
    end
    % Compute testing accuracy
    temp=sum(diag(CM_Model))/sum(CM_Model,'all');
    validationAccuracy=[validationAccuracy temp];
    WhiskersAccuracy=[WhiskersAccuracy; diag(CM_Model_prob)'];
end


end
