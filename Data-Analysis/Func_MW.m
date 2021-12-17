function [feature_matrix_one_file, class_one_file]=Func_MW(NeuralData, channels_interest,)
%% FEATURE EXTRACTIONS
% Feature_flag will indicate whether we will have no DC (0), DC(1) or RV (2)
feature_matrix_one_file=[];
class_one_file=[];
position_struct=1

for trial_num=1:size(NeuralData(position_struct).Trials,1)
    whisker_ID=(NeuralData(position_struct).Whisker_ID);
    switch whisker_ID
        case {'B1', 'B2', 'C1', 'C2', 'D1', 'D2'}
            class_one_file(trial_num)=cellstr(whisker_ID);
            
        case {'E1','e1'}
            class_one_file(trial_num)=cellstr('E1');
            
        case {'Be','be'}
            class_one_file(trial_num)=cellstr('Beta');
            
        case {'De', 'de'}
            class_one_file(trial_num)=cellstr('Delta');
            
        case {'Ga', 'ga'}
            class_one_file(trial_num)=cellstr('Gamma');
            
            
    end
    
    temp=NeuralData(position_struct).Trials_Gamma(trial_num,:);
    
    temp=reshape(temp,1, numel(temp));
    end_vec=size(temp,2);
    
    %%% When using RV
    if trial_num>1
        end_mat=size_features+end_vec*(i-1);
    end
    
    feature_matrix_one_file(trial_num,end_mat+1:end_mat+end_vec)=temp;
end



