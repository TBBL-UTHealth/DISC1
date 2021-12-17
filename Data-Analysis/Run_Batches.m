% Run_Batches will run the code dates and trial number in batches. 
close all
% clearvars -except data_summary model_summary
trial_num=450;
WindowDuration=.100; % 100 ms
model_flag=1;
CAR_Flag=0; % 1 if we want to do CAR in the LFP and gamma data

% dates={'1-11-21', '1-13-21', '1-15-21', '1-27-21', '1-28-21', '10-31-20', '11-01-20','11-03-20'}; % Recording date
dates={'1-11-21', '1-13-21', '1-15-21', '1-27-21', '1-28-21', '8-27-21', '9-7-21', '9-29-21','10-05-21'}; % Recording date
% dates={'9-9-21'}
% dates={'03-02-21','11-12-20'};
device='DISC'; % Device type
num_ch_RV=4;
num_ch=1; % 128, 64, 88, 44, 24, 12, 8, 4, 1

% device='Tetrode';
% num_ch_RV=4;
% num_ch=4; % 128, 64, 88, 44, 24, 12, 8, 4, 1

%% For running just all dates with a set number of trials and window duration
for i=1:length(dates)
    date=char(dates(i));
    [model_summary_one_file, data_summary_one_file, number_trials]=Func_Data_Preprocessing_v14(date, device, WindowDuration, trial_num, model_flag, CAR_Flag,num_ch_RV, num_ch);
    % Concatanate model_summary_one and model_summary structure
    for row_num=1:length(model_summary_one_file)
        model_summary_one_file(row_num).WindowStart=0;
        
        model_summary_one_file(row_num).WindowEnd=WindowDuration;
        model_summary_one_file(row_num).Number_Trials=number_trials;
        model_summary_one_file(row_num).CAR_Flag=CAR_Flag;


    end
    if exist('model_summary', 'var')==1
        model_summary=[model_summary, model_summary_one_file];
    else
        model_summary=model_summary_one_file;
    end
    
    data_summary_one_file(1)=[];
    for row_num=1:length(data_summary_one_file)
        data_summary_one_file(row_num).WindowStart=0;
        
        data_summary_one_file(row_num).WindowEnd=WindowDuration;
        data_summary_one_file(row_num).Number_Trials=number_trials;
        data_summary_one_file(row_num).BinSize=22.5;

    end
    if exist('data_summary', 'var')==1
         data_summary=[data_summary, data_summary_one_file];
    else
        data_summary=data_summary_one_file;
    end
end

%% For different trial numbers
% for i=1:9%:length(dates)
%     date=char(dates(i));
%      for trial_num=30:30:450
% %          trial_num=90;
% % %         for WindowDuration=.01250:.0125:.200
%         [model_summary_one_file, data_summary_one_file, number_trials]=Func_Data_Preprocessing_v14(date, device, WindowDuration, trial_num, model_flag, CAR_Flag,num_ch_RV, num_ch);
%         % Concatanate model_summary_one and model_summary structure
%         for row_num=1:length(model_summary_one_file)
%             model_summary_one_file(row_num).WindowStart=0;
%             model_summary_one_file(row_num).WindowEnd=WindowDuration;
%             model_summary_one_file(row_num).Number_Trials=number_trials;
%             model_summary_one_file(row_num).CAR_Flag=CAR_Flag;
%             
%         end
%         if exist('model_summary', 'var')==1
%             model_summary=[model_summary, model_summary_one_file];
%         else
%             model_summary=model_summary_one_file;
%         end
%         %         end
%         
%         data_summary_one_file(1)=[];
%         for row_num=1:length(data_summary_one_file)
%             data_summary_one_file(row_num).WindowStart=0;
%             
%             data_summary_one_file(row_num).WindowEnd=WindowDuration;
%             data_summary_one_file(row_num).Number_Trials=number_trials;
%             data_summary_one_file(row_num).BinSize=22.5;
%             
%         end
%         if exist('data_summary', 'var')==1
%             data_summary=[data_summary, data_summary_one_file];
%         else
%             data_summary=data_summary_one_file;
%         end
%         
%      end
% end

%% For different window durations
% trial_num=450;
% for i=1:length(dates)
%     date=char(dates(i));
%     for WindowDuration=.01250:.0125:.200
%         [model_summary_one_file, ~, number_trials]=Func_Data_Preprocessing_v9(date, device, WindowDuration, trial_num);
%         % Concatanate model_summary_one and model_summary structure
%         for row_num=1:length(model_summary_one_file)
%             model_summary_one_file(row_num).WindowStart=0;
%             
%             model_summary_one_file(row_num).WindowEnd=WindowDuration;
%             model_summary_one_file(row_num).Number_Trials=number_trials;
%         end
%         if exist('model_summary', 'var')==1
%             model_summary=[model_summary, model_summary_one_file];
%         else
%             model_summary=model_summary_one_file;
%         end
%     end
% end

%%
% 
if model_flag==1
    
    temp=struct2table(model_summary);
    writetable(temp,'C:\Users\Public\Programming\Matlab\Data\ModelandDataSummaries_ImplementedCVPCA_NoDenoising_NoCAR_1200umDepth.csv');
    
end
% temp=data_summary;
% temp = rmfield(temp, {'Amplitude_Gamma_Trials', 'Amplitude_LFP_Trials', 'SNR_Gamma_Trials', 'SNR_LFP_Trials',...
%      'DC_Gamma', 'DC_LFP', 'DC_Gamma_Smoothed', 'DC_LFP_Smoothed', 'DC_offset', 'LFP_Waveforms', 'Gamma_Waveforms', 'Time_Trials'});
% temp=struct2table(temp);writetable(temp,'C:\Users\Public\Programming\Matlab\Data\Data_Summary_NoCAR_DISC_1200umDepth.csv');

% if model_flag==1
% 
%     temp=struct2table(model_summary);
%     writetable(temp,'ModelandDataSummaries_ImplementedCVPCA_NoDenoising.csv');
%     
% end

%  data_DC=data_summary;
%  save('All_Data_DirectionalCurves.mat', 'data_DC');
% 
    

% %% Individual trials are extracted and each amplitude value saved as a separate row - copying the previous one
% data_trials=data_summary;
% temp=struct();
% temp(1)=[];
% for j=1:length(data_trials)
%     for i=1:length(data_trials(j).Amplitude_Gamma_Trials)
%         n=length(temp)+1;
%         temp(n).Whisker=data_trials(j).Whisker;
%         temp(n).Device=data_trials(j).Device;
%         temp(n).Configuration=data_trials(j).Configuration;
%         temp(n).Subject=data_trials(j).Subject;
%         temp(n).Amplitude_Gamma_Trial=data_trials(j).Amplitude_Gamma_Trials(i);
%         temp(n).Amplitude_LFP_Trial=data_trials(j).Amplitude_LFP_Trials(i);
%         temp(n).SNR_Gamma_Trial=data_trials(j).SNR_Gamma_Trials(i);
%         temp(n).SNR_LFP_Trial=data_trials(j).SNR_LFP_Trials(i);
%         temp(n).WindowStart=data_trials(j).WindowStart;
%         temp(n).WindowEnd=data_trials(j).WindowEnd;
%         temp(n).Trial_Number=i;
%         temp(n).BinSize=data_trials(j).BinSize;
%         temp(n).CAR_Flag=data_trials(j).CAR_Flag;
% 
%     end
% end
% 
% temp=struct2table(temp);writetable(temp,'C:\Users\Public\Programming\Matlab\Data\11x4_DataTrials.csv');
