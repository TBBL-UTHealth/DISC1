function [feature_matrix_one_file, class_one_file]=Func_MacroDISC(NeuralData, channels_interest_macro, gammaflag)
%% FEATURE EXTRACTIONS FOR SIMULATED DISC MACRO
channel_numbers=reshape(channels_interest_macro,1,numel(channels_interest_macro));
class_one_file={};
feature_matrix_one_file=[];

for trial_num=1:size(NeuralData(1).Trials,1)
    temp=[];
    for i=1:length(channel_numbers)
        channel_number=channel_numbers(i);
        position_struct=find([NeuralData.Channel_Number]==channel_number);
        if ~isempty(position_struct)
            whisker_ID=char(NeuralData(position_struct).Whisker_ID);                
            switch whisker_ID
                case {'B1', 'B2', 'C1', 'C2', 'D1', 'D2'}
                    class_one_file(trial_num)=cellstr(whisker_ID);
                    
                case {'E1','e1'}
                    class_one_file(trial_num)=cellstr('E1');
                    
                case {'Be','be', 'beta', 'Beta'}
                    class_one_file(trial_num)=cellstr('Beta');
                    
                case {'De', 'de', 'delta', 'Delta'}
                    class_one_file(trial_num)=cellstr('Delta');
                    
                case {'Ga', 'ga', 'gamma', 'Gamma'}
                    class_one_file(trial_num)=cellstr('Gamma');
                    
            end
            if gammaflag==1
                temp=[temp; NeuralData(position_struct).Trials_Gamma(trial_num,:)]; % stores the data in a matrix size #channels x #timepoints
            else
                temp=[temp; NeuralData(position_struct).Trials(trial_num,:)]; % stores the data in a matrix size #channels x #timepoints
            end
        end
    end
    temp=nanmean(temp,1); % Obtains mean of all values in time
    end_vec=size(temp,2);
    
    %feature_matrix_DISC_macro(feature_matrix_start+trial_num,1:end_vec)=temp;
    feature_matrix_one_file(trial_num,1:end_vec)=temp;
    
end
end

