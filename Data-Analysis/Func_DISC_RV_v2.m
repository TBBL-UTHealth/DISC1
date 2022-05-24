function [feature_matrix_one_file, class_one_file]=Func_DISC_RV_v2(NeuralData, channels_interest,gammaflag,feature_flag)
%% FEATURE EXTRACTIONS - Creates feature matrix based on snippets, and the class as a vector. This only works for DISC
% I've implemented a feature_flag to indicate if we're only doing snippets,
% snippets+DC, or snippets+RV. It does not do only RVs
% Based from Data_FeatureExtract_v4. Works for gamma band only
% Feature_flag will indicate whether we will have wavefoms only (0),
% wavefoms with DC(1), wavefoms with RV (2) or CSD gamma (3)
% -v2 now has option (3) of feature flag: CSD for the rows and
% columns given. It also added gammaflag. CSD can be computed for gamma or
% LFP based on the gammaflag value given
channel_numbers=reshape(channels_interest.model,1,numel(channels_interest.model));
feature_matrix_one_file=[];

switch feature_flag
    case {0,3}
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
            if gammaflag==1
                %%% Gamma SNIPPETS
                temp=NeuralData(position_struct).Trials_Gamma(trial_num,:);
            else
                temp=NeuralData(position_struct).Trials(trial_num,:);

            end
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

% Converts raw waveforms to CSD
if feature_flag==3 
    % Convert feature_matrix_one (11x (201x4)) variables to matrices that keep the row x col values order    
    length_trials=end_vec;
    [num_rows, num_columns]=size(channels_interest.model);
    [num_trials,~]=size(feature_matrix_one_file);
    % splits feature_matrix_one_file in number of columns
    CSD_feature_matrix_one_file=[];
    for i=1:num_trials    
        temp2=[]; % new matrix that will replace the old feature_matrix one
        feature_matrix_copy=feature_matrix_one_file(i,:);
        feature_matrix_copy=reshape(feature_matrix_copy,length_trials,num_rows,num_columns);
        for j=1:num_columns
            LFP_matrix=feature_matrix_copy(:,:,j); % time is in the rows, and electrode row number in the column.
            CSD=diff(LFP_matrix,2,2); % If we're going to plot this, we need to transpose it. 
            CSD=reshape(CSD,1, numel(CSD));
            temp2=[temp2 CSD];
        end
        CSD_feature_matrix_one_file=[CSD_feature_matrix_one_file; temp2];

    end
    feature_matrix_one_file=CSD_feature_matrix_one_file;
end

end

