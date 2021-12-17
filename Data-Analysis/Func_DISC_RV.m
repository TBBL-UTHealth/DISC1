function [feature_matrix_one_file, class_one_file]=Func_DISC_RV(NeuralData, channels_interest,feature_flag)
%% FEATURE EXTRACTIONS - Creates feature matrix based on snippets, and the class as a vector. This only works for DISC
% I've implemented a feature_flag to indicate if we're only doing snippets,
% snippets+DC, or snippets+RV. It does not do only RVs
% Based from Data_FeatureExtract_v4
% Feature_flag will indicate whether we will have no DC (0), DC(1) or RV (2)
channel_numbers=reshape(channels_interest.model,1,numel(channels_interest.model));
feature_matrix_one_file=[];

switch feature_flag
    case 0
        end_mat=0;
        size_features=0;
    case 1
        end_mat=8;
        size_features=8;
    case 2
        end_mat=2;
        size_features=2;
end

for i=1:length(channel_numbers)
    channel_number=channel_numbers(i);
    position_struct=find([NeuralData.Channel_Number]==channel_number);
    
    if ~isempty(position_struct)
        for trial_num=1:size(NeuralData(position_struct).Trials,1)%length(NeuralData(position_struct).PSD_trials)
            whisker_ID=char(NeuralData(position_struct).Whisker_ID);            
            switch whisker_ID
                case {'B1', 'B2', 'C1', 'C2', 'D1', 'D2'}
                    class_one_file(trial_num)=cellstr(whisker_ID);
                    
                case {'E1','e1'}
                    class_one_file(trial_num)=cellstr('E1');
                    
                case {'Be','be', 'Beta', 'beta'}
                    class_one_file(trial_num)=cellstr('Beta');
                    
                case {'De', 'de', 'delta', 'Delta'}
                    class_one_file(trial_num)=cellstr('Delta');
                    
                case {'Ga', 'ga', 'Gamma', 'gamma'}
                    class_one_file(trial_num)=cellstr('Gamma');
                    
                    
            end
            
%             if ismember(channel_number,channels_interest.RV)
%                 
%                 %%%% GAMMA RESULTANT VECTORS
%                 switch feature_flag
%                     case 1
%                         %%% GAMMA TUNING CURVES
%                         if size(NeuralData(position_struct).Directional_Trials_Gamma(trial_num,:),2)==size_features
%                             feature_matrix_one_file(trial_num, 1:size_features)=NeuralData(position_struct).Directional_Trials_Gamma(trial_num,:)
%                         else
%                             feature_matrix_one_file(trial_num,1:7)=NeuralData(position_struct).Directional_Trials_Gamma(trial_num,:);
%                             feature_matrix_one_file(trial_num,8)=NaN;
%                         end
%                     case 2
%                         feature_matrix_one_file(trial_num,1) = magnitude_trials(trial_num);
%                         feature_matrix_one_file(trial_num,2) = direction_trials(trial_num);
%                 end
%             end
            %%% Gamma SNIPPETS
            temp=NeuralData(position_struct).Trials_Gamma(trial_num,:);
            time_snippet=NeuralData(position_struct).Time_Trial;
            
%             %%% Uncomment if using data above 15 ms
% %             temp2=find(time_snippet>=15);
% %             temp=temp(temp2);
% 
            %%% Uncomment if using data above 0 ms
             temp2=find(time_snippet>=0);
             temp=temp(temp2);

            temp=reshape(temp,1, numel(temp));
            end_vec=size(temp,2);
            %%% Uncomment if using data above 0 ms
            
            %%% When using RV
            if trial_num>1
                end_mat=size_features+end_vec*(i-1);
            end
            
            feature_matrix_one_file(trial_num,end_mat+1:end_mat+end_vec)=temp;
        end
    else
        for trial_num=1:size(NeuralData(1).Trials,1)%length(NeuralData(position_struct).PSD_trials)
%             end_vec=201; % this is true if we're getting features from 0 to 100 ms
            end_mat=size_features+end_vec*(i-1);
            feature_matrix_one_file(trial_num,end_mat+1:end_mat+end_vec)=NaN;
        end
        
    end
    
end
end

