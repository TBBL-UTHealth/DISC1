function [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers(feature_matrix, class, data_summary, device, percentage_data_testing, plotflag, PCA_flag, target_variance, saveflag)
% Function that will generate the modeling for all, closest and furthest
% whiskers based on the SNR
% feature_matrix, class, Data_Summary(needed to extract closest vs
% furthest whisker), device are the necessary variables
% percentage_data_testing, plotflag, PCA_flag, target_variance are
% optional. If not present, they're set to default values: 20, 1, 1 and 99
% respectively

if ~exist('percentage_data_testing','var') %parameter does not exist, so default it
      percentage_data_testing = 20;
end

 if ~exist('plotflag','var')%parameter does not exist, so default it
      plotflag = 1;
 end

 if ~exist('PCA_flag','var')%parameter does not exist, so default it
      PCA_flag = 1;
 end

 if ~exist('target_variance','var') %parameter does not exist, so default it
     target_variance = 99;
 end
 
 if ~exist('saveflag','var') %parameter does not exist, so default it
     saveflag = 1;
 end
 
 % Initializes variables
 channels_interest=data_summary(1).channels_interest;
 date=data_summary(1).date;
 row_num=1;
 
 % Find closest and furthest whiskers
 %%% 3 closests whiskers
 closest_Whiskers=cell(3,1);
 temp=maxk([data_summary.Amplitude_LFP],3);
 for i=1:3
     temp2=find([data_summary.Amplitude_LFP]==temp(i));
     closest_Whiskers(i)=cellstr(data_summary(temp2).Whisker);
     
     switch string(closest_Whiskers(i))
         case {'Be','be'}
             closest_Whiskers(i)=cellstr('Beta');
             
         case {'De', 'de'}
             closest_Whiskers(i)=cellstr('Delta');
             
         case {'Ga', 'ga'}
             closest_Whiskers(i)=cellstr('Gamma');
     end
 end
 
 %%% 3 furthest whiskers
 furthest_Whiskers=cell(3,1);
 temp=mink([data_summary.Amplitude_LFP],3);
 for i=1:3
     temp2=find([data_summary.Amplitude_LFP]==temp(i));
     furthest_Whiskers(i)=cellstr(data_summary(temp2).Whisker);
     
     switch string(furthest_Whiskers(i))
         case {'Be','be'}
             furthest_Whiskers(i)=cellstr('Beta');
             
         case {'De', 'de'}
             furthest_Whiskers(i)=cellstr('Delta');
             
         case {'Ga', 'ga'}
             furthest_Whiskers(i)=cellstr('Gamma');
     end
 end
 
 
 %%% All recorded whiskers
[testingAccuracy,CM, grpOrder,validationAccuracy, validationCM]=Func_LDA_v4(feature_matrix, class, percentage_data_testing, plotflag, PCA_flag, target_variance);
disp(append('Percentage of missing data in ', device, ' feature matrix: ', num2str(sum(isnan(feature_matrix),'all')*100/numel(feature_matrix)), '%'))
if plotflag==1
    title(char([join({date ' LDA Model'}, ',') join({device ' No denoising'}, ',') {append('Accuracy: ', num2str(testingAccuracy*100), '%')}]));
    temp=char(join({date device 'CM' 'LDA_Gamma_Nodenoising' 'All_Whiskers'},'_'));
    if saveflag==1
        saveas(gcf, strcat(temp,'.jpg'))
        saveas(gcf, strcat(temp,'.fig'))
    end
end  

    
for i=1:length(validationAccuracy)
    model_summary_one_file(row_num).Whisker='Full Model';
    model_summary_one_file(row_num).Device=device;
    model_summary_one_file(row_num).Model='LDA';
    model_summary_one_file(row_num).Classes=join(string(grpOrder), ', '); 
    model_summary_one_file(row_num).Configuration=num2str(size(channels_interest.model));
    model_summary_one_file(row_num).Subject=date;
    model_summary_one_file(row_num).Accuracy=validationAccuracy(i)*100;
    %     model_summary_one_file(row_num).ConfusionMatrix=validationCM(i,:);
    model_summary_one_file(row_num).Notes='All Whiskers';
    model_summary_one_file(row_num).Notes2='Individual k-Fold';
    
    row_num=size(model_summary_one_file,2)+1;
end

% Calculates average cross validated CM
CM=[sum(validationCM)];
temp=length(unique(class)); %Number of whiskers
CM=reshape(CM, temp, temp);
    
for i=1:length(CM)
    temp=CM(i,i)/nansum(CM(i,:))*100; % Calculates the accuracy for whisker i in the confusion matrix
    model_summary_one_file(row_num).Whisker=string(grpOrder(i));
    model_summary_one_file(row_num).Device=device;
    model_summary_one_file(row_num).Model='LDA';
    model_summary_one_file(row_num).Classes=join(string(grpOrder), ', '); 
    model_summary_one_file(row_num).Configuration=num2str(size(channels_interest.model));
    model_summary_one_file(row_num).Subject=date;
    model_summary_one_file(row_num).Accuracy=temp;
    model_summary_one_file(row_num).Notes='All Whiskers';
    model_summary_one_file(row_num).Notes2='Average Cross Validated by Whisker';
    
    row_num=size(model_summary_one_file,2)+1;
end

% %%% Furthest 3 whisker model
% temp=strcmp(class, furthest_Whiskers(1)) + strcmp(class, furthest_Whiskers(2)) + strcmp(class, furthest_Whiskers(3));
% temp=logical(temp);
% 
% [testingAccuracy,CM, grpOrder, validationAccuracy,validationCM]=Func_LDA_v4(feature_matrix(temp',:), class(temp), percentage_data_testing, plotflag, PCA_flag, target_variance);
% 
% if plotflag==1   
%     title(char([join({date ' LDA Model - Furthest Whiskers'}, ',') join({device ' No denoising'}, ',') {append('Accuracy: ', num2str(testingAccuracy*100), '%')}]));
%     temp=char(join({date device 'CM' 'LDA_Gamma_Nodenoising' 'Furthest_Whiskers'},'_'));
%     if saveflag==1
%         saveas(gcf, strcat(temp,'.jpg'))
%         saveas(gcf, strcat(temp,'.fig'))
%     end
% end
% 
% for i=1:length(validationAccuracy)
%     model_summary_one_file(row_num).Whisker='Full Model';
%     model_summary_one_file(row_num).Device=device;
%     model_summary_one_file(row_num).Model='LDA';
%     model_summary_one_file(row_num).Classes=join(string(grpOrder), ', '); 
%     model_summary_one_file(row_num).Configuration=num2str(size(channels_interest.model));
%     model_summary_one_file(row_num).Subject=date;
%     model_summary_one_file(row_num).Accuracy=validationAccuracy(i)*100;
% %     model_summary_one_file(row_num).ConfusionMatrix=validationCM(i,:);
%     model_summary_one_file(row_num).Notes='Furthest Whiskers';
%     model_summary_one_file(row_num).Notes2='Individual k-Fold';
% 
%     row_num=size(model_summary_one_file,2)+1;
% end
% 
% % Calculates average cross validated CM
% CM=[sum(validationCM)];
% temp=3; %Number of whiskers
% CM=reshape(CM, temp, temp);
%     
% for i=1:length(CM)
%     temp=CM(i,i)/nansum(CM(i,:))*100; % Calculates the accuracy for whisker i in the confusion matrix
%     model_summary_one_file(row_num).Whisker=string(grpOrder(i));
%     model_summary_one_file(row_num).Device=device;
%     model_summary_one_file(row_num).Model='LDA';
%     model_summary_one_file(row_num).Classes=join(string(grpOrder), ', '); 
%     model_summary_one_file(row_num).Configuration=num2str(size(channels_interest.model));
%     model_summary_one_file(row_num).Subject=date;
%     model_summary_one_file(row_num).Accuracy=temp;
%     model_summary_one_file(row_num).Notes='Furthest Whiskers';
%     model_summary_one_file(row_num).Notes2='Average Cross Validated by Whisker';
%         row_num=size(model_summary_one_file,2)+1;
% 
% end
% 
% %%% Closest 3 whisker model
% temp=strcmp(class, closest_Whiskers(1)) + strcmp(class, closest_Whiskers(2)) + strcmp(class, closest_Whiskers(3));
% temp=logical(temp);
% 
% [testingAccuracy,CM, grpOrder, validationAccuracy,validationCM]=Func_LDA_v4(feature_matrix(temp',:), class(temp), percentage_data_testing, plotflag, PCA_flag, target_variance);
% 
% 
% if plotflag==1   
%     title(char([join({date ' LDA Model - Closest Whiskers'}, ',') join({device ' No denoising'}, ',') {append('Accuracy: ', num2str(testingAccuracy*100), '%')}]));
%     temp=char(join({date device 'CM' 'LDA_Gamma_Nodenoising' 'Closest_Whiskers'},'_'));
%     if saveflag==1
%         saveas(gcf, strcat(temp,'.jpg'))
%         saveas(gcf, strcat(temp,'.fig'))
%     end
% end
% 
% for i=1:length(validationAccuracy)
%     model_summary_one_file(row_num).Whisker='Full Model';
%     model_summary_one_file(row_num).Device=device;
%     model_summary_one_file(row_num).Model='LDA';
%     model_summary_one_file(row_num).Classes=join(string(grpOrder), ', '); 
%     model_summary_one_file(row_num).Configuration=num2str(size(channels_interest.model));
%     model_summary_one_file(row_num).Subject=date;
%     model_summary_one_file(row_num).Accuracy=validationAccuracy(i)*100;
%     model_summary_one_file(row_num).Notes='Closest Whiskers';
%     model_summary_one_file(row_num).Notes2='Individual k-Fold';
%     
%     row_num=size(model_summary_one_file,2)+1;
% end
% 
% % Calculates average cross validated CM
% CM=[sum(validationCM)];
% temp=3; %Number of whiskers
% CM=reshape(CM, temp, temp);
%     
% for i=1:length(CM)
%     temp=CM(i,i)/nansum(CM(i,:))*100; % Calculates the accuracy for whisker i in the confusion matrix
%     model_summary_one_file(row_num).Whisker=string(grpOrder(i));
%     model_summary_one_file(row_num).Device=device;
%     model_summary_one_file(row_num).Model='LDA';
%     model_summary_one_file(row_num).Classes=join(string(grpOrder), ', '); 
%     model_summary_one_file(row_num).Configuration=num2str(size(channels_interest.model));
%     model_summary_one_file(row_num).Subject=date;
%     model_summary_one_file(row_num).Accuracy=temp;
%     model_summary_one_file(row_num).Notes='Closest Whiskers';
%     model_summary_one_file(row_num).Notes2='Average Cross Validated by Whisker';
%     row_num=size(model_summary_one_file,2)+1;
% 
% end
