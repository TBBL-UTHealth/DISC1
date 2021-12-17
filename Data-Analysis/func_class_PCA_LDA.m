function yfit = func_class_PCA_LDA(Xtrain,ytrain,Xtest)

target_variance=99;

standarize_flag=1; % 1 is yes, 0 is no
% % Standardize the training predictor data. Then, find the 
% % principal components for the standardized training predictor
% % data.
if standarize_flag==1
    [Ztrain,Zmean,Zstd] = zscore(Xtrain);
    [coeff,scoreTrain,~,~,explained,mu] = pca(Ztrain);
else
    % PCA for non standarized data
    Xtrain=Xtrain-mean(Xtrain);
    [coeff,scoreTrain,~,~,explained,mu] = pca(Xtrain);
end
% Find the lowest number of principal components that account
% for the target variability defined on target_variance.
n = find(cumsum(explained)>=target_variance,1);

% Find the n principal component scores for the
% training predictor data. Train a classification LDA
% using only these scores.
scoreTrain = scoreTrain(:,1:n);


classificationDiscriminant = fitcdiscr(...
    scoreTrain,ytrain, ...
    'DiscrimType', 'linear', ...
    'Gamma', 0, ...
    'FillCoeffs', 'off');

% Find the n principal component scores for the transformed
% test data. Classify the test data.
if standarize_flag==1
    Ztest = (Xtest-Zmean)./Zstd;
    scoreTest = (Ztest-mu)*coeff(:,1:n);
else
%     Non standarized
    scoreTest = (Xtest-mu)*coeff(:,1:n);
end
yfit = predict(classificationDiscriminant,scoreTest);

end