function [model_summary, data_summary, number_trials]= Func_Data_Preprocessing_v14(date, device, windowduration, target_trial_num, model_flag,CAR_Flag, num_ch_RV,num_ch)
%Default channel number is 11x4
% Based on Data_Preprocessing_v9 for DISC, Macro and Macros
%Data_Preprocessing Loads .mat files in a specific path and separates it in trials with the window
%duration specified. It will then create the matrix required for the
%analysis
%INPUTS:
%windowduration: time in seconds, it's the time before and after the pulse.
% %                 A .200 window would have analysis span from -200 to 200 ms.
% Date
% Device, DISC or tetrode 
% Window duration: time in seconds, it's the time before and after the pulse.
% %                 A .200 window would have analysis span from 0 to 200 ms.
% Target_trial_num, is the number of trials that will be used
% Model_flag, to indicate if model will be run (1) or not (0)
% CAR_Flag, indicates if common average referencing by subtracting mean of all channels will be performed (1) or not (0).
% Num_ch_RV, is a vector with the number of channels that will be used to generate the directional curve and resultant vector
% Num_ch is the number of channels that will be used for the analysis. This is a predetermined DISC electrode configuration. Values accepted:
%       o	128 (16 rows x 8 columns)
%       o	64 (16 x 4)
%       o	88 (11 x 8)
%       o	44 (11 x 4)
%       o	24 (3 x 8)
%       o	12 (3 x 4)
%       o	8 (1 x 8)
%       o	4 (1 x 4)
%       o	1 (1 x 1) . This is the best channel with highest amplitude.
%   Tetrode device only accepts 4 and 1 electrodes

% -v10 adds a model flag as a function input
% -v11 adds tuning curves using power spectrum values at 25, 50, 75, 100.
% -v12 removed power spectrum directional curves and now computes the
% smoothed LFP and gamma directional curves instead of one or the other.
% CAR is added as a flag. All denoising removed. SNR now calculated based
% based on the RMS and not amplitude
% Trial amplitude and SNR saved in the data_summary structure
% -v13 RMS values saved individualy in the model_summary structure. Number
% of channels added as a variable so it's automatically selected in
% ChooseChannels_v2
% -v14 index of channels where the max amplitude, SNR and RMS are from is
% added to the data_summary. Average waveform for channel with max
% amplitude saved. Mean amplitude of -100 to 0 on the column where the best
% channel is also saved


% figure;
%default values
binsize=22.5; % Degree difference between interpolated angles for DC
gammaflag=1; % If 0, we're analyzing LFP data. If 1, it's gamma
saveflag=1; % If 0, confusion matrices not being saved
plotflag=0; % If 0 we are not plotting RV/DC, if 1 we are plotting them
MacroFlag=0; % If 0, the modeling and feature matrix for DISC macro are not created
keep_stdev=3; % Used to define the value of data that will be thrown out data
target_variance=99;
save_indvidual_DC=1; % if 1, it will save the directional curves in the data_summary 
polarplotflag=0; % 0 it doesn't plot polar plots of the directional curve
% CAR_Flag=1; % 1 if we want to do CAR in the LFP and gamma data


plot_colors=[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];...
    [0.4660 0.6740 0.1880]; [0.3010 0.7450 0.9330]; [0.6350 0.0780 0.1840];[1.0000 0.7109 0.7568];...
    [0.5000 0.5000 0.5000];[1.0000 0.0784 0.5764];[0.5000 0      1.0000];[0.5000 0.2350 0.0000] ];

ChooseDirectory;
ChooseChannels_v2;
All_Channels=temp; % This define a matrix with all channels 
% Looks for all data in the folder
filelist=dir('*.mat');
labels_whisker=string();

feature_matrix_DISC_RV=[];
class_DISC_RV=[];
feature_matrix_DISC_DC=[];
class_DISC_DC=[];
feature_matrix_DISC_Macro_2mm=[];
class_DISC_Macro_2mm=[];
feature_matrix_DISC_Macro_400um=[];
class_DISC_Macro_400um=[];
feature_matrix_DISC=[];
class_DISC=[];
feature_matrix_MW=[];
class_MW=[];
Subject_Data_Summary=struct();
if ~exist('data_summary', 'var')
    data_summary=struct();
    row_num=0;
end
row_num_subject_summary=1;
Features=struct();
%peak_mag_dir=zeros(length(filelist),2);

    
for file_num=1:(length(filelist)) %9
    load(filelist(file_num).name);

    color=plot_colors(file_num, :);
    
    threshold=max(NeuralData(1).Pulse_Signal);
    if threshold==1
        threshold=0.9999;
    else
        threshold=2.99;
    end
    
    LFP_Mat=[];
    for i=1:numel(channels_interest.model)
        position_struct=find([NeuralData.Channel_Number]==channels_interest.model(i));
        if isempty(position_struct)==0        
            temp=NeuralData(position_struct).LFP;
            LFP_Mat=cat(1,LFP_Mat,temp);
        end
    end
    CAR_Average=mean(LFP_Mat,1, 'Omitnan');

    for ch_num=1:length(NeuralData)
        %%% LFP
        LFP=NeuralData(ch_num).LFP;
        if CAR_Flag==1
            LFP=LFP-CAR_Average; % CAR
        end

        pulse_signal=NeuralData(ch_num).Pulse_Signal;
        Fsdown=NeuralData(ch_num).Sampling_Rate;
        
%         %% Removes 60 Hz noise
%         d = designfilt('bandstopiir','FilterOrder',2, ...
%             'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
%             'DesignMethod','butter','SampleRate',Fsdown);
%         fvtool(d,'Fs',Fsdown);
%         LFP = filtfilt(d,LFP);
%         
%         
%         %% Removes 120 Hz noise
%         d = designfilt('bandstopiir','FilterOrder',2, ...
%             'HalfPowerFrequency1',119,'HalfPowerFrequency2',121, ...
%             'DesignMethod','butter','SampleRate',Fsdown);
%         fvtool(d,'Fs',Fsdown);
%         LFP = filtfilt(d,LFP);
%         
%         %% Removes 180 Hz noise
%         d = designfilt('bandstopiir','FilterOrder',2, ...
%             'HalfPowerFrequency1',179,'HalfPowerFrequency2',181, ...
%             'DesignMethod','butter','SampleRate',Fsdown);
%         fvtool(d,'Fs',Fsdown);
%         LFP = filtfilt(d,LFP);

        [Snippet,time_snippet, TrialNumbers] = Func_GetSnippets_v2(LFP, pulse_signal, threshold,windowduration, Fsdown);

        %%% GAMMA
        Gamma=NeuralData(ch_num).LFP_Gamma;

        [Snippet_Gamma,time_snippet, TrialNumbers] = Func_GetSnippets_v2(Gamma, pulse_signal, threshold,windowduration, Fsdown);

%         % Regularize data
%         temp=Snippet(:,time_snippet<0);
%         temp = nanmean(temp,2);
%         Snippet=Snippet-temp;
%         
%         temp=Snippet_Gamma(:,time_snippet<0);
%         temp = nanmean(temp,2);
%         Snippet_Gamma=Snippet_Gamma-temp;
                
        if target_trial_num<size(Snippet,1)% Randomly chooses target_trial_num from the full trial list
            if ~exist('temp_trial_numbers','var')
                temp_trial_numbers=randperm(size(Snippet,1)-1, target_trial_num);
            else
                
            end
            
            if max(temp_trial_numbers)>size(Snippet,1)
                temp=find(temp_trial_numbers>size(Snippet,1));
                temp_trial_numbers(temp)=max(temp_trial_numbers)-1;
            else
                Snippet=Snippet(temp_trial_numbers, :);
                Snippet_Gamma=Snippet_Gamma(temp_trial_numbers, :);
            end
            

            number_trials=target_trial_num;
            
        else
            number_trials=length(TrialNumbers);
        end
        
        %%% Average snippets
        Average_LFP=nanmean(Snippet);
        %StDev_LFP=nanstd(Snippet);
        %SE_LFP= Average_LFP/sqrt(length(Average_LFP));
        Average_Gamma=nanmean(Snippet_Gamma);
        %StDev_LFP=nanstd(Snippet);
        %SE_LFP= Average_LFP/sqrt(length(Average_LFP));
        
        %%%  Amplitude by taking the distance between the highest peak and
        %%% the lowest through post stimulation
        Amplitude_LFP=abs(min(Average_LFP(time_snippet>=0&time_snippet<=100))-max(Average_LFP(time_snippet>=0&time_snippet<=100)));
        RMS_noise_LFP=rms(Average_LFP(time_snippet<0));
        RMS_signal_LFP= rms(Average_LFP(time_snippet>=0&time_snippet<=100));
        SNR_LFP=10*log10(RMS_signal_LFP/RMS_noise_LFP);

        Amplitude_Gamma=abs((min(Average_Gamma(time_snippet>=0&time_snippet<=100))-max(Average_Gamma(time_snippet>=0&time_snippet<=100))));
        RMS_noise_Gamma=rms(Average_Gamma(time_snippet<0));
        RMS_signal_Gamma= rms(Average_Gamma(time_snippet>=0&time_snippet<=100));
        SNR_Gamma=10*log10(RMS_signal_Gamma/RMS_noise_Gamma);
        
        %%% Save trial data into the NeuralData structure
        NeuralData(ch_num).Amplitude=Amplitude_LFP;
        NeuralData(ch_num).SNR=SNR_LFP;
        
        NeuralData(ch_num).Trials=Snippet;
        NeuralData(ch_num).Time_Trial=time_snippet;
        
        NeuralData(ch_num).Amplitude_Gamma=Amplitude_Gamma;
        NeuralData(ch_num).SNR_Gamma=SNR_Gamma;
        NeuralData(ch_num).Trials_Gamma=Snippet_Gamma;
        NeuralData(ch_num).RMS_noise_LFP=RMS_noise_LFP;
        NeuralData(ch_num).RMS_signal_LFP=RMS_signal_LFP;
        
        NeuralData(ch_num).RMS_noise_Gamma=RMS_noise_Gamma;
        NeuralData(ch_num).RMS_signal_Gamma=RMS_signal_Gamma;

        % INDIVIDUAL TRIAL AMPLITUDE and SNR AND TUNING CURVE
        temp=-windowduration:(windowduration*2)/(length(Average_LFP)-1):(windowduration);
        Amplitude_LFP=zeros(length(Snippet),1);
        Amplitude_Gamma=zeros(length(Snippet),1);
        SNR_LFP=zeros(length(Snippet),1);
        SNR_Gamma=zeros(length(Snippet),1);
        
        for trial_num=1:size(Snippet,1)
            if isnan(Snippet(trial_num, :))
                Amplitude_LFP(trial_num)=NaN;
                Amplitude_Gamma(trial_num)=NaN;
                SNR_LFP(trial_num)=NaN;
                SNR_Gamma(trial_num)=NaN;

            else
                temp_LFP=Snippet(trial_num, :);
                Amplitude_LFP(trial_num)=abs(min(temp_LFP(time_snippet>=0&time_snippet<=100))-max(temp_LFP(time_snippet>=0&time_snippet<=100)));
                temp_Gamma=Snippet_Gamma(trial_num, :);
                Amplitude_Gamma(trial_num)=abs(min(temp_Gamma(time_snippet>=0&time_snippet<=100))-max(temp_Gamma(time_snippet>=0&time_snippet<=100)));
                SNR_LFP(trial_num)=10*log10(rms(temp_LFP(time_snippet>=0&time_snippet<=100))/rms(temp_LFP(time_snippet<0)));
                SNR_Gamma(trial_num)=10*log10(rms(temp_Gamma(time_snippet>=0&time_snippet<=100))/rms(temp_Gamma(time_snippet<0)));
                
                RMS_signal_LFP(trial_num)=rms(temp_LFP(time_snippet>=0&time_snippet<=100));
                RMS_noise_LFP(trial_num)=rms(temp_LFP(time_snippet<0));                
                RMS_signal_Gamma(trial_num)=rms(temp_Gamma(time_snippet>=0&time_snippet<=100));
                RMS_noise_Gamma(trial_num)=rms(temp_Gamma(time_snippet<0));
            end
            NeuralData(ch_num).Amplitude_LFP_Trials=Amplitude_LFP;
            NeuralData(ch_num).Amplitude_Gamma_Trials=Amplitude_Gamma;
            NeuralData(ch_num).SNR_LFP_Trials=SNR_LFP;
            NeuralData(ch_num).SNR_Gamma_Trials=SNR_Gamma;
            
            NeuralData(ch_num).RMS_signal_LFP_Trials=RMS_signal_LFP;
            NeuralData(ch_num).RMS_noise_LFP_Trials=RMS_noise_LFP;
            NeuralData(ch_num).RMS_signal_Gamma_Trials=RMS_signal_Gamma;
            NeuralData(ch_num).RMS_noise_Gamma_Trials=RMS_noise_Gamma;
            
            % TUNING CURVES INDIVIDUAL TRIALS
            [row, col]=find(channels_interest.RV==NeuralData(ch_num).Channel_Number);
            for j=1:size(channels_interest.RV,2) %columns
                channel_number=channels_interest.RV(row,j);
                position_struct=find([NeuralData.Channel_Number]==channel_number);
                if isempty(position_struct)==0
                    NeuralData(position_struct).Directional_Trials_LFP(trial_num,col)=Amplitude_LFP(trial_num);
                    NeuralData(position_struct).Directional_Trials_Gamma(trial_num,col)=Amplitude_Gamma(trial_num);
                end
                
                
            end
        end
        % INDIVIDUAL TRIAL AMPLITUDE AND TUNING CURVE
    end

%         
        %%% Takes number of trials needed
        

    
    clear Amplitude Amplitude_LFP temp_LFP Snippet Average_LFP SNR_LFP RMS_LFP
    clear Amplitude_Gamma temp_Gamma Snippet_Gamma  Average_Gamma
    clear col row i j type Fsdown threshold pulse_signal Gamma LFP direction_trials
    if strcmp(device,'DISC')
        
        %Changes tuning curves to NaN if column is missing
        
        for i=1:numel(channels_interest.RV)
            position_struct=find([NeuralData.Channel_Number]==channels_interest.RV(i));
            if ~isempty(position_struct)
                NeuralData(position_struct).Directional_Trials_LFP([NeuralData(position_struct).Directional_Trials_LFP]==0)=NaN;
                NeuralData(position_struct).Directional_Trials_Gamma([NeuralData(position_struct).Directional_Trials_Gamma]==0)=NaN;
                if size(NeuralData(position_struct).Directional_Trials_Gamma,2)==7
                    NeuralData(position_struct).Directional_Trials_LFP(:,8)=NaN;
                    NeuralData(position_struct).Directional_Trials_Gamma(:,8)=NaN;
                end
            end
        end
        
        % Changes tuning curves to NaN if column is missing

        % RESULTANT VECTOR
        if save_indvidual_DC==1
            [magnitude_trials, direction_trials, ~, ~, tuning_matrix_smoothed_Trials_Gamma, pval_rayleigh, pval_omni]=Func_RV_v3(NeuralData, channels_interest, keep_stdev, binsize, polarplotflag, color, 1, date);
            [magnitude_trials, direction_trials, ~, ~, tuning_matrix_smoothed_Trials_LFP, pval_rayleigh, pval_omni]=Func_RV_v3(NeuralData, channels_interest, keep_stdev, binsize, polarplotflag, color, 0, date);
        end

%        FEATURE MATRIX DISC, no DC, no denoising
        [feature_matrix_one_file, class_one_file]=Func_DISC_RV(NeuralData, channels_interest,0);
        
        feature_matrix_DISC=[feature_matrix_DISC; feature_matrix_one_file];
        class_DISC=[class_DISC class_one_file];
        
        row_num=size(data_summary,2)+1;
      
        temp=NeuralData(1).Whisker_ID;
        data_summary(row_num).Whisker=temp; % do this by default, and change name if whisker name
        % is abbreviated. This is what the switch does
        switch string(temp)
            case {'Be','be'}
                data_summary(row_num).Whisker=cellstr('Beta');
                
            case {'De', 'de'}
                data_summary(row_num).Whisker=cellstr('Delta');
                
            case {'Ga', 'ga'}
                data_summary(row_num).Whisker=cellstr('Gamma');
            
        end
        data_summary(row_num).Device='DISC';
        data_summary(row_num).Configuration=num2str(size(channels_interest.model));
        
        data_summary(row_num).Subject=date;
        temp=[];
        for i=1:numel(channels_interest.model)
            temp=[temp find([NeuralData.Channel_Number]==channels_interest.model(i))];
        end
        
        temp2=find([NeuralData.Amplitude_Gamma] == max([NeuralData(temp).Amplitude_Gamma]));
        data_summary(row_num).Amplitude_Gamma=NeuralData(temp2).Amplitude_Gamma;
        data_summary(row_num).Amplitude_Gamma_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).Amplitude_Gamma_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).Amplitude_Gamma_Trials=NeuralData(temp2).Amplitude_Gamma_Trials;
        data_summary(row_num).Gamma_Waveform=nanmean(NeuralData(temp2).Trials_Gamma);

        temp2=find([NeuralData.Amplitude] == max([NeuralData(temp).Amplitude]));
        data_summary(row_num).Amplitude_LFP=NeuralData(temp2).Amplitude;
        data_summary(row_num).Amplitude_LFP_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).Amplitude_LFP_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).Amplitude_LFP_Trials=NeuralData(temp2).Amplitude_LFP_Trials; 
        data_summary(row_num).LFP_Waveform=nanmean(NeuralData(temp2).Trials);
        data_summary(row_num).Time_Trials=NeuralData(temp2).Time_Trial;

        % Saves mean values from waveform -100 to 0 for the column where
        % Amplitude_LFP_Ch_Impedance is
        DC_offset=[];
        [~, temp2]=find(All_Channels==NeuralData(temp2).Channel_Number);
        temp2=All_Channels(:,temp2);
        for i=1:length(temp2)
            temp4=find([NeuralData.Channel_Number]==temp2(i));
            if ~isempty(temp4)
                temp3=nanmean(NeuralData(temp4).Trials);
                temp3=mean(temp3(1:201));
            else
                temp3=NaN;
            end
            DC_offset=[DC_offset temp3];

        end
        data_summary(row_num).DC_offset=DC_offset';

        temp2=find([NeuralData.SNR_Gamma] == max([NeuralData(temp).SNR_Gamma]));
        data_summary(row_num).SNR_Gamma=NeuralData(temp2).SNR_Gamma;
        data_summary(row_num).SNR_Gamma_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).SNR_Gamma_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).SNR_Gamma_Trials=NeuralData(temp2).SNR_Gamma_Trials;   
                
        temp2=find([NeuralData.SNR] == max([NeuralData(temp).SNR]));
        data_summary(row_num).SNR_LFP=NeuralData(temp2).SNR;
        data_summary(row_num).SNR_LFP_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).SNR_LFP_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).SNR_LFP_Trials=NeuralData(temp2).SNR;  
        
        data_summary(row_num).RMS_noise_LFP=mean([NeuralData(temp).RMS_noise_LFP]);
        temp2=find([NeuralData.RMS_signal_LFP] == max([NeuralData(temp).RMS_signal_LFP]));
        data_summary(row_num).RMS_signal_LFP=NeuralData(temp2).RMS_signal_LFP;        
        data_summary(row_num).RMS_signal_LFP_ChNum=NeuralData(temp2).Channel_Number;
        
        data_summary(row_num).RMS_noise_Gamma=mean([NeuralData(temp).RMS_noise_Gamma]);     
        temp2=find([NeuralData.RMS_signal_Gamma] == max([NeuralData(temp).RMS_signal_Gamma]));
        data_summary(row_num).RMS_signal_Gamma=NeuralData(temp2).RMS_signal_Gamma;
        data_summary(row_num).RMS_signal_Gamma_ChNum=NeuralData(temp2).Channel_Number;
        
        
%         temp2=find([NeuralData.RMS_noise_LFP] == max([NeuralData(temp).RMS_noise_LFP]));
%         data_summary(row_num).RMS_noise_LFP_Trials=NeuralData(temp2).RMS_noise_LFP_Trials;
%         temp2=find([NeuralData.RMS_signal_LFP] == max([NeuralData(temp).RMS_signal_LFP]));
%         data_summary(row_num).RMS_signal_LFP_Trials=NeuralData(temp2).RMS_signal_LFP_Trials;
         
%         temp2=find([NeuralData.RMS_noise_Gamma] == max([NeuralData(temp).RMS_noise_Gamma]));
%         data_summary(row_num).RMS_noise_Gamma_Trials=NeuralData(temp2).RMS_noise_Gamma_Trials;
%         temp2=find([NeuralData.RMS_signal_Gamma] == max([NeuralData(temp).RMS_signal_Gamma]));
%         data_summary(row_num).RMS_signal_Gamma_Trials=NeuralData(temp2).RMS_signal_Gamma_Trials;       
%         data_summary(row_num).CAR_Flag=CAR_Flag;

        if save_indvidual_DC==1
            for i=1:numel(channels_interest.RV)
                temp=find([NeuralData.Channel_Number]==channels_interest.RV(i));
                if ~isnan(temp)
                    data_summary(row_num).DC_Gamma=NeuralData(temp).Directional_Trials_Gamma;
                    data_summary(row_num).DC_LFP=NeuralData(temp).Directional_Trials_LFP;
                    data_summary(row_num).DC_Gamma_Smoothed=tuning_matrix_smoothed_Trials_Gamma;
                    data_summary(row_num).DC_LFP_Smoothed=tuning_matrix_smoothed_Trials_LFP;
     
                    break
                end
            end
        end
        
        temp=NeuralData(1).Whisker_ID;
        Subject_Data_Summary(row_num_subject_summary).Whisker=temp; % do this by default, and change name if whisker name
        % is abbreviated. This is what the switch does
        switch string(temp)
            case {'Be','be'}
                Subject_Data_Summary(row_num_subject_summary).Whisker='Beta';
                
            case {'De', 'de'}
                Subject_Data_Summary(row_num_subject_summary).Whisker='Delta';
                
            case {'Ga', 'ga'}
                Subject_Data_Summary(row_num_subject_summary).Whisker='Gamma';
                
        end
        Subject_Data_Summary(row_num_subject_summary).Device='DISC';
        temp=[];
        for i=1:numel(channels_interest.model)
            temp=[temp find([NeuralData.Channel_Number]==channels_interest.model(i))];
        end
        
        Subject_Data_Summary(row_num_subject_summary).Amplitude_Gamma=max([NeuralData(temp).Amplitude_Gamma]);
        Subject_Data_Summary(row_num_subject_summary).SNR_Gamma=max([NeuralData(temp).SNR_Gamma]);
        Subject_Data_Summary(row_num_subject_summary).Amplitude_LFP=max([NeuralData(temp).Amplitude]);
        Subject_Data_Summary(row_num_subject_summary).SNR_LFP=max([NeuralData(temp).SNR]);
        Subject_Data_Summary(row_num_subject_summary).RMS_noise_LFP=mean([NeuralData(temp).RMS_noise_LFP]);
        Subject_Data_Summary(row_num_subject_summary).RMS_signal_LFP=max([NeuralData(temp).RMS_signal_LFP]);
        Subject_Data_Summary(row_num_subject_summary).RMS_noise_Gamma=mean([NeuralData(temp).RMS_noise_Gamma]);
        Subject_Data_Summary(row_num_subject_summary).RMS_signal_Gamma=max([NeuralData(temp).RMS_signal_Gamma]);
%         Subject_Data_Summary(row_num_subject_summary).Amplitude_Gamma_average=mean([NeuralData(temp).Amplitude_Gamma]);
%         Subject_Data_Summary(row_num_subject_summary).SNR_Gamma_average=mean([NeuralData(temp).SNR_Gamma]);
%         Subject_Data_Summary(row_num_subject_summary).Amplitude_LFP_average=mean([NeuralData(temp).Amplitude]);
%         Subject_Data_Summary(row_num_subject_summary).SNR_LFP_average=mean([NeuralData(temp).SNR]);
        row_num_subject_summary=row_num_subject_summary+1;
        
        if MacroFlag==1
            % FEATURE MATRIX 2mm MACRO
            
            channels_interest_macro=channels_interest.DISCMacro;
            row_num=size(data_summary,2)+1;
            for gamma_macro_flag=0:1
            [feature_matrix_one_file, class_one_file]=Func_MacroDISC(NeuralData, channels_interest_macro,gamma_macro_flag);
            
            if gamma_macro_flag== gammaflag
                feature_matrix_DISC_Macro_2mm=[feature_matrix_DISC_Macro_2mm; feature_matrix_one_file];
                class_DISC_Macro_2mm=[class_DISC_Macro_2mm class_one_file];
            end

            Average_Macro=nanmean(feature_matrix_one_file);
            
            Amplitude_Macro=abs(min(Average_Macro(time_snippet>=0&time_snippet<=100))-max(Average_Macro(time_snippet>=0&time_snippet<=100)));
            SNR_Macro=10*log10(rms(Average_Macro(time_snippet>=0&time_snippet<=100))/rms(Average_Macro(time_snippet<0)));

            temp=NeuralData(1).Whisker_ID;
            data_summary(row_num).Whisker=temp; % do this by default, and change name if whisker name
            % is abbreviated. This is what the switch does
            Subject_Data_Summary(row_num_subject_summary).Whisker=temp; % do this by default, and change name if whisker name
            % is abbreviated. This is what the switch does
            switch string(temp)
                case {'Be','be'}
                    data_summary(row_num).Whisker=cellstr('Beta');
                    Subject_Data_Summary(row_num_subject_summary).Whisker='Beta';
                    
                case {'De', 'de'}
                    data_summary(row_num).Whisker=cellstr('Delta');
                    Subject_Data_Summary(row_num_subject_summary).Whisker='Delta';
                    
                case {'Ga', 'ga'}
                    data_summary(row_num).Whisker=cellstr('Gamma');
                    Subject_Data_Summary(row_num_subject_summary).Whisker='Gamma';
                    
            end
            data_summary(row_num).Device='Macro, 2mm';
            data_summary(row_num).Configuration=num2str(size(channels_interest.model));
            data_summary(row_num).Subject=date;
            Subject_Data_Summary(row_num_subject_summary).Device='Macro, 2mm';
            data_summary(row_num).CAR_Flag=CAR_Flag;

            
            if gamma_macro_flag==1
                data_summary(row_num).Amplitude_Gamma=Amplitude_Macro;
                data_summary(row_num).Amplitude_Gamma_ChNum=1;
                data_summary(row_num).Amplitude_Gamma_Trials=abs(min(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),[],2)-max(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),[],2));
                
                data_summary(row_num).SNR_Gamma=SNR_Macro;
                data_summary(row_num).SNR_Gamma_ChNum=1;
                data_summary(row_num).SNR_Gamma_Trials=10.*log10(rms(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),2)./rms(feature_matrix_one_file(:,time_snippet<0),2));
                   
                data_summary(row_num).RMS_noise_Gamma=rms(Average_Macro(time_snippet<0));
                data_summary(row_num).RMS_signal_Gamma=rms(Average_Macro(time_snippet>=0&time_snippet<=100));
                data_summary(row_num).RMS_signal_Gamma_ChNum=1;

                %                 data_summary(row_num).RMS_noise_Gamma_Trials=rms(feature_matrix_one_file(:,time_snippet<0),2);
%                 data_summary(row_num).RMS_signal_Gamma_Trials=rms(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),2);
                
                Subject_Data_Summary(row_num_subject_summary).Amplitude_Gamma=Amplitude_Macro;
                Subject_Data_Summary(row_num_subject_summary).SNR_Gamma=SNR_Macro;
                %             Subject_Data_Summary(row_num_subject_summary).Amplitude_Gamma_average=Amplitude_Macro;
                %             Subject_Data_Summary(row_num_subject_summary).SNR_Gamma_average=SNR_Macro;
                Subject_Data_Summary(row_num_subject_summary).RMS_noise_Gamma=rms(Average_Macro(time_snippet<0));
                Subject_Data_Summary(row_num_subject_summary).RMS_signal_Gamma=rms(Average_Macro(time_snippet>=0&time_snippet<=100));
                
                
            else
                if gamma_macro_flag==0
                    data_summary(row_num).Amplitude_LFP=Amplitude_Macro;
                    data_summary(row_num).Amplitude_LFP_ChNum=1;
                    data_summary(row_num).Amplitude_LFP_Trials=abs(min(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),[],2)-max(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),[],2));
                    
                    data_summary(row_num).SNR_LFP=SNR_Macro;
                    data_summary(row_num).SNR_LFP_ChNum=1;
                    data_summary(row_num).SNR_LFP_Trials=10.*log10(rms(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),2)./rms(feature_matrix_one_file(:,time_snippet<0),2));
                    
                    data_summary(row_num).RMS_noise_LFP=rms(Average_Macro(time_snippet<0));                    
                    data_summary(row_num).RMS_signal_LFP=rms(Average_Macro(time_snippet>=0&time_snippet<=100));
                    data_summary(row_num).RMS_signal_LFP_ChNum=1;

%                     data_summary(row_num).RMS_noise_LFP_Trials=rms(feature_matrix_one_file(:,time_snippet<0),2);
%                     data_summary(row_num).RMS_signal_LFP_Trials=rms(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),2);
%                 
                    Subject_Data_Summary(row_num_subject_summary).Amplitude_LFP=Amplitude_Macro;
                    Subject_Data_Summary(row_num_subject_summary).SNR_LFP=SNR_Macro;
                    
                    %             Subject_Data_Summary(row_num_subject_summary).Amplitude_LFP_average=Amplitude_Macro;
                    %             Subject_Data_Summary(row_num_subject_summary).SNR_LFP_average=SNR_Macro;
                    Subject_Data_Summary(row_num_subject_summary).RMS_noise_LFP=rms(Average_Macro(time_snippet<0));
                    Subject_Data_Summary(row_num_subject_summary).RMS_signal_LFP=rms(Average_Macro(time_snippet>=0&time_snippet<=100));
                    
                    
                end
            end
            end
            row_num_subject_summary=row_num_subject_summary+1;
            
            % FEATURE MATRIX 400 MACRO
             row_num=size(data_summary,2)+1;
            for gamma_macro_flag=0:1
            temp=[];
            Amplitude_Macro=[];
            SNR_Macro=[];
            RMS_noise_Macro=[];
            RMS_signal_Macro=[];
            Amplitude_Trials_Macro=[];
            SNR_Trials_Macro=[];
            RMS_noise_Trials_Macro=[];
            RMS_signal_Trials_Macro=[];
            
            for macro_num=1:3
                switch macro_num
                    case 1
                        channels_interest_macro=channels_interest.DISCMacro(1:3,:);
                    case 2
                        channels_interest_macro=channels_interest.DISCMacro(5:7,:);
                    case 3
                        channels_interest_macro=channels_interest.DISCMacro(9:11,:);
                end
                [feature_matrix_one_file, class_one_file]=Func_MacroDISC(NeuralData, channels_interest_macro,gamma_macro_flag);
                temp=[temp feature_matrix_one_file];
                Average_Macro=nanmean(feature_matrix_one_file);
                temp2=abs((min(Average_Macro(time_snippet>=0&time_snippet<=100))-max(Average_Macro(time_snippet>=0&time_snippet<=100))));
                Amplitude_Macro=[Amplitude_Macro temp2];
                temp2=abs(min(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),[],2)-max(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),[],2));
                Amplitude_Trials_Macro=[Amplitude_Trials_Macro temp2];

                temp2=10*log10(rms(Average_Macro(time_snippet>=0&time_snippet<=100))/rms(Average_Macro(time_snippet<0)));
                SNR_Macro=[SNR_Macro temp2];
                temp2=10.*log10(rms(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),2)./rms(feature_matrix_one_file(:,time_snippet<0),2));
                SNR_Trials_Macro=[SNR_Trials_Macro temp2];

                temp2=rms(Average_Macro(time_snippet<0));
                RMS_noise_Macro=[RMS_noise_Macro temp2];
                temp2=rms(feature_matrix_one_file(:,time_snippet<0),2);
                RMS_noise_Trials_Macro=[RMS_noise_Trials_Macro temp2];

                temp2=rms(Average_Macro(time_snippet>=0&time_snippet<=100));
                RMS_signal_Macro=[RMS_signal_Macro temp2];
                temp2=rms(feature_matrix_one_file(:,time_snippet>=0&time_snippet<=100),2);
                RMS_signal_Trials_Macro=[RMS_noise_Trials_Macro temp2];

            end
            if gamma_macro_flag== gammaflag
                
                feature_matrix_DISC_Macro_400um=[feature_matrix_DISC_Macro_400um; temp];
                class_DISC_Macro_400um=[class_DISC_Macro_400um class_one_file];
            end
            
            temp=NeuralData(1).Whisker_ID;
            data_summary(row_num).Whisker=temp; % do this by default, and change name if whisker name
            Subject_Data_Summary(row_num_subject_summary).Whisker=temp; % do this by default, and change name if whisker name
            % is abbreviated. This is what the switch does
            switch string(temp)
                case {'Be','be'}
                    data_summary(row_num).Whisker=cellstr('Beta');
                                        Subject_Data_Summary(row_num_subject_summary).Whisker='Beta';

                case {'De', 'de'}
                    data_summary(row_num).Whisker=cellstr('Delta');
                                        Subject_Data_Summary(row_num_subject_summary).Whisker='Delta';

                case {'Ga', 'ga'}
                    data_summary(row_num).Whisker=cellstr('Gamma');
                                        Subject_Data_Summary(row_num_subject_summary).Whisker='Gamma';

                    
            end
            data_summary(row_num).Device='Macro, 400um';
            data_summary(row_num).Configuration=num2str(size(channels_interest.model));
            data_summary(row_num).Subject=date;
            data_summary(row_num).CAR_Flag=CAR_Flag;
            Subject_Data_Summary(row_num_subject_summary).Device='Macro, 400um';
            
            if gamma_macro_flag==1
                temp2=find(Amplitude_Macro == max(Amplitude_Macro));
                data_summary(row_num).Amplitude_Gamma=Amplitude_Macro(temp2);
                data_summary(row_num).Amplitude_Gamma_ChNum=temp2;
                data_summary(row_num).Amplitude_Gamma_Trials=Amplitude_Trials_Macro(:,temp2);
 
                temp2=find(SNR_Macro == max(SNR_Macro));
                data_summary(row_num).SNR_Gamma=SNR_Macro(temp2);
                data_summary(row_num).SNR_Gamma_ChNum=temp2;
                data_summary(row_num).SNR_Gamma_Trials=SNR_Trials_Macro(:,temp2);
                %             data_summary(row_num).Amplitude_Gamma_average=mean(Amplitude_Macro);
                %             data_summary(row_num).SNR_Gamma_average=mean(SNR_Macro);
                data_summary(row_num).RMS_noise_Gamma=mean(RMS_noise_Macro);
%                 data_summary(row_num).RMS_noise_Gamma_Trials=mean(RMS_noise_Trials_Macro,[],2);
                
                temp2=find(RMS_signal_Macro == max(RMS_signal_Macro));
                data_summary(row_num).RMS_signal_Gamma=RMS_signal_Macro(temp2);
                data_summary(row_num).RMS_signal_Gamma_ChNum=temp2;
%                 data_summary(row_num).RMS_signal_Gamma_Trials=max(RMS_signal_Trials_Macro,[],2);
                
                Subject_Data_Summary(row_num_subject_summary).Amplitude_Gamma=max(Amplitude_Macro);
                Subject_Data_Summary(row_num_subject_summary).SNR_Gamma=max(SNR_Macro);
                %             Subject_Data_Summary(row_num_subject_summary).Amplitude_Gamma_average=mean(Amplitude_Macro);
                %             Subject_Data_Summary(row_num_subject_summary).SNR_Gamma_average=mean(SNR_Macro);
                Subject_Data_Summary(row_num_subject_summary).RMS_noise_Gamma=mean(RMS_noise_Macro);
                Subject_Data_Summary(row_num_subject_summary).RMS_signal_Gamma=max(RMS_signal_Macro);
                
            else
                if gamma_macro_flag==0
                    temp2=find(Amplitude_Macro == max(Amplitude_Macro));
                    data_summary(row_num).Amplitude_LFP=Amplitude_Macro(temp2);
                    data_summary(row_num).Amplitude_LFP_ChNum=temp2;
                    data_summary(row_num).Amplitude_LFP_Trials=Amplitude_Trials_Macro(:,temp2);
                    
                    temp2=find(SNR_Macro == max(SNR_Macro));
                    data_summary(row_num).SNR_LFP=SNR_Macro(temp2);
                    data_summary(row_num).SNR_LFP_ChNum=temp2;
                    data_summary(row_num).SNR_LFP_Trials=SNR_Trials_Macro(:,temp2);
                    
                    
                    %             data_summary(row_num).Amplitude_LFP_average=mean(Amplitude_Macro);
                    %             data_summary(row_num).SNR_LFP_average=mean(SNR_Macro);
                    data_summary(row_num).Configuration=num2str(size(channels_interest.model));
                    data_summary(row_num).RMS_noise_LFP=mean(RMS_noise_Macro);
%                     data_summary(row_num).RMS_noise_LFP_Trials=mean(RMS_noise_Trials_Macro,[],2);
                    
                    temp2=find(RMS_signal_Macro == max(RMS_signal_Macro));
                    data_summary(row_num).RMS_signal_LFP=RMS_signal_Macro(temp2);
                    data_summary(row_num).RMS_signal_LFP_ChNum=temp2;
%                     data_summary(row_num).RMS_signal_LFP_Trials=max(RMS_signal_Trials_Macro,[],2);
                    
                    data_summary(row_num).CAR_Flag=CAR_Flag;
                    
                    Subject_Data_Summary(row_num_subject_summary).Amplitude_LFP=max(Amplitude_Macro);
                    Subject_Data_Summary(row_num_subject_summary).SNR_LFP=max(SNR_Macro);
                    Subject_Data_Summary(row_num_subject_summary).RMS_noise_LFP=mean(RMS_noise_Macro);
                    Subject_Data_Summary(row_num_subject_summary).RMS_signal_LFP=max(RMS_signal_Macro);
                end
            end
            clear SNR_Macro Amplitude_Macro Average_Macro
            
            end
            row_num_subject_summary=row_num_subject_summary+1;
            
            %
        end
    end
    
    if strcmp(device,'Tetrode')
        
        %%%%FEATURE MATRIX Tetrodes
        magnitude_trials=[];
        direction_trials=[];
%         [feature_matrix_one_file, class_one_file]=Func_DISC_RV(NeuralData, channels_interest,0, magnitude_trials, direction_trials);
        [feature_matrix_one_file, class_one_file]=Func_DISC_RV(NeuralData, channels_interest,0);

        feature_matrix_MW=[feature_matrix_MW; feature_matrix_one_file];
        class_MW=[class_MW class_one_file];
        
       
        % Tuning curve
        if size(channels_interest.RV,2)>1
            [magnitude_trials, direction_trials, ~, ~, tuning_matrix_smoothed_Trials_Gamma, pval_rayleigh, pval_omni]=Func_RV_v3(NeuralData, channels_interest, keep_stdev, binsize, polarplotflag, color, 1, date);
            [magnitude_trials, direction_trials, ~, ~, tuning_matrix_smoothed_Trials_LFP, pval_rayleigh, pval_omni]=Func_RV_v3(NeuralData, channels_interest, keep_stdev, binsize, polarplotflag, color, 0, date);

            pval_rayleigh=NaN;
            pval_omni=NaN;
        end
        
        temp=NeuralData(1).Whisker_ID;
        Subject_Data_Summary(file_num).Whisker=temp; % do this by default, and change name if whisker name
        % is abbreviated. This is what the switch does
        switch string(temp)
            case {'Be','be'}
                Subject_Data_Summary(file_num).Whisker='Beta';
                
            case {'De', 'de'}
                Subject_Data_Summary(file_num).Whisker='Delta';
                
            case {'Ga', 'ga'}
                Subject_Data_Summary(file_num).Whisker='Gamma';
                
        end
        Subject_Data_Summary(file_num).Device='Tetrode';
        temp=[];
        for i=1:numel(channels_interest.model)
            temp=[temp find([NeuralData.Channel_Number]==channels_interest.model(i))];
        end
        Subject_Data_Summary(file_num).Amplitude_Gamma=max([NeuralData(temp).Amplitude_Gamma]);
        Subject_Data_Summary(file_num).SNR_Gamma=max([NeuralData(temp).SNR_Gamma]);
        Subject_Data_Summary(file_num).Amplitude_LFP=max([NeuralData(temp).Amplitude]);
        Subject_Data_Summary(file_num).SNR_LFP=max([NeuralData(temp).SNR]);
%         Subject_Data_Summary(file_num).Amplitude_Gamma_average=mean([NeuralData(temp).Amplitude_Gamma]);
%         Subject_Data_Summary(file_num).SNR_Gamma_average=mean([NeuralData(temp).SNR_Gamma]);
%         Subject_Data_Summary(file_num).Amplitude_LFP_average=mean([NeuralData(temp).Amplitude]);
%         Subject_Data_Summary(file_num).SNR_LFP_average=mean([NeuralData(temp).SNR]);
        Subject_Data_Summary(row_num_subject_summary).RMS_noise_LFP=mean([NeuralData(temp).RMS_noise_LFP]);
        Subject_Data_Summary(row_num_subject_summary).RMS_signal_LFP=max([NeuralData(temp).RMS_signal_LFP]);
        Subject_Data_Summary(row_num_subject_summary).RMS_noise_Gamma=mean([NeuralData(temp).RMS_noise_Gamma]);
        Subject_Data_Summary(row_num_subject_summary).RMS_signal_Gamma=max([NeuralData(temp).RMS_signal_Gamma]);
      
        
        row_num=size(data_summary,2)+1;
        temp=NeuralData(1).Whisker_ID;
        data_summary(row_num).Whisker=temp; % do this by default, and change name if whisker name
        % is abbreviated. This is what the switch does
        switch string(temp)
            case {'Be','be'}
                data_summary(row_num).Whisker=cellstr('Beta');
                
            case {'De', 'de'}
                data_summary(row_num).Whisker=cellstr('Delta');
                
            case {'Ga', 'ga'}
                data_summary(row_num).Whisker=cellstr('Gamma');
                
        end
        data_summary(row_num).Device='Tetrode';
        data_summary(row_num).Configuration=num2str(size(channels_interest.model));
        data_summary(row_num).Subject=date;
        
        temp=[];
        for i=1:numel(channels_interest.model)
            temp=[temp find([NeuralData.Channel_Number]==channels_interest.model(i))];
        end
        temp2=find([NeuralData.Amplitude_Gamma] == max([NeuralData(temp).Amplitude_Gamma]));
        data_summary(row_num).Amplitude_Gamma=NeuralData(temp2).Amplitude_Gamma;
        data_summary(row_num).Amplitude_Gamma_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).Amplitude_Gamma_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).Amplitude_Gamma_Trials=NeuralData(temp2).Amplitude_Gamma_Trials;
        data_summary(row_num).Gamma_Waveform=nanmean(NeuralData(temp2).Trials_Gamma);

        temp2=find([NeuralData.Amplitude] == max([NeuralData(temp).Amplitude]));
        data_summary(row_num).Amplitude_LFP=NeuralData(temp2).Amplitude;
        data_summary(row_num).Amplitude_LFP_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).Amplitude_LFP_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;        
        data_summary(row_num).Amplitude_LFP_Trials=NeuralData(temp2).Amplitude_LFP_Trials; 
        data_summary(row_num).LFP_Waveform=nanmean(NeuralData(temp2).Trials);
        data_summary(row_num).Time_Trials=NeuralData(temp2).Time_Trial;
        
        temp2=find([NeuralData.SNR_Gamma] == max([NeuralData(temp).SNR_Gamma]));
        data_summary(row_num).SNR_Gamma=NeuralData(temp2).SNR_Gamma;
        data_summary(row_num).SNR_Gamma_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).SNR_Gamma_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).SNR_Gamma_Trials=NeuralData(temp2).SNR_Gamma_Trials;   
                
        temp2=find([NeuralData.SNR] == max([NeuralData(temp).SNR]));
        data_summary(row_num).SNR_LFP=NeuralData(temp2).SNR;
        data_summary(row_num).SNR_LFP_ChNum=NeuralData(temp2).Channel_Number;
        data_summary(row_num).SNR_LFP_Ch_Impedance=NeuralData(temp2).Channel_Impedance_Magnitude;
        data_summary(row_num).SNR_LFP_Trials=NeuralData(temp2).SNR;  
        
        data_summary(row_num).RMS_noise_LFP=mean([NeuralData(temp).RMS_noise_LFP]);
        temp2=find([NeuralData.RMS_signal_LFP] == max([NeuralData(temp).RMS_signal_LFP]));
        data_summary(row_num).RMS_signal_LFP=NeuralData(temp2).RMS_signal_LFP;        
        data_summary(row_num).RMS_signal_LFP_ChNum=NeuralData(temp2).Channel_Number;
        
        data_summary(row_num).RMS_noise_Gamma=mean([NeuralData(temp).RMS_noise_Gamma]);     
        temp2=find([NeuralData.RMS_signal_Gamma] == max([NeuralData(temp).RMS_signal_Gamma]));
        data_summary(row_num).RMS_signal_Gamma=NeuralData(temp2).RMS_signal_Gamma;
        data_summary(row_num).RMS_signal_Gamma_ChNum=NeuralData(temp2).Channel_Number;
        
        
%         temp2=find([NeuralData.RMS_noise_LFP] == max([NeuralData(temp).RMS_noise_LFP]));
%         data_summary(row_num).RMS_noise_LFP_Trials=NeuralData(temp2).RMS_noise_LFP_Trials;
%         temp2=find([NeuralData.RMS_signal_LFP] == max([NeuralData(temp).RMS_signal_LFP]));
%         data_summary(row_num).RMS_signal_LFP_Trials=NeuralData(temp2).RMS_signal_LFP_Trials;
        
%         temp2=find([NeuralData.RMS_noise_Gamma] == max([NeuralData(temp).RMS_noise_Gamma]));
%         data_summary(row_num).RMS_noise_Gamma_Trials=NeuralData(temp2).RMS_noise_Gamma_Trials;
%         temp2=find([NeuralData.RMS_signal_Gamma] == max([NeuralData(temp).RMS_signal_Gamma]));
%         data_summary(row_num).RMS_signal_Gamma_Trials=NeuralData(temp2).RMS_signal_Gamma_Trials;

        if save_indvidual_DC==1
            
            for i=1:numel(channels_interest.RV)
                temp=find([NeuralData.Channel_Number]==channels_interest.RV(i));
                if ~isnan(temp)
                    data_summary(row_num).DC_Gamma=NeuralData(temp).Directional_Trials_Gamma;
                    data_summary(row_num).DC_LFP=NeuralData(temp).Directional_Trials_LFP;
                    
                    data_summary(row_num).DC_Gamma_Smoothed=tuning_matrix_smoothed_Trials_Gamma;
                    data_summary(row_num).DC_LFP_Smoothed=tuning_matrix_smoothed_Trials_LFP;
                    break
                end
            end
        end
    end
    
   data_summary(row_num).CAR_Flag=CAR_Flag;

    temp=split(filelist(file_num).name, "_");
    labels_whisker(file_num)=string(temp(1));
    labels_whisker(file_num)=string(NeuralData(1).Whisker_ID);
    
end

%


%Save data summary into a .csv file
subset=rmfield(data_summary, {'Amplitude_Gamma_Trials', 'Amplitude_LFP_Trials', 'SNR_Gamma_Trials', 'SNR_LFP_Trials', 'DC_Gamma', 'DC_LFP', 'DC_Gamma_Smoothed', 'DC_LFP_Smoothed'});
temp=struct2table(subset(:,2:end));
if saveflag==1
    writetable(temp,strcat(char(date), '_DataSummary_NoDenoised.csv'));
end
% close all

% Save channels_interest into the Data_Summary to pass this to Func_Model_All_Closest_Furthest_Whiskers
for i=1:length(Subject_Data_Summary)
    Subject_Data_Summary(i).channels_interest=channels_interest;
    Subject_Data_Summary(i).date=date;
end
%% MODELS

if model_flag==1
    % DISC
    if strcmp(device,'DISC')
        %%%%%% DISC no DC model
        subset_Subject_Data_Summary=Subject_Data_Summary(strcmp({Subject_Data_Summary.Device},'DISC'));
%         [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers(feature_matrix_DISC, class_DISC, Subject_Data_Summary, device, percentage_data_testing, plotflag, 1, target_variance, saveflag);
        [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers_v2(feature_matrix_DISC, class_DISC, subset_Subject_Data_Summary, device, target_variance, plotflag);
        
        if exist('model_summary', 'var')==1
            model_summary=[model_summary, model_summary_one_file];
        else
            model_summary=model_summary_one_file;
        end
        
        %%%%%% DISC Macro
        
        if MacroFlag == 1
            % DISC Macro, 2mm
            subset_Subject_Data_Summary=Subject_Data_Summary(strcmp({Subject_Data_Summary.Device},'Macro, 2mm'));
            [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers_v2(feature_matrix_DISC_Macro_2mm, class_DISC_Macro_2mm, subset_Subject_Data_Summary, 'Macro, 2mm', target_variance, plotflag);
            if exist('model_summary', 'var')==1
                model_summary=[model_summary, model_summary_one_file];
            else
                model_summary=model_summary_one_file;
            end            
% model_summary=[model_summary, model_summary_one_file];
%             
            % DISC Macro, 400 um
            subset_Subject_Data_Summary=Subject_Data_Summary(strcmp({Subject_Data_Summary.Device},'Macro, 400um'));
            [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers_v2(feature_matrix_DISC_Macro_400um, class_DISC_Macro_2mm, subset_Subject_Data_Summary, 'Macro, 400um', target_variance, plotflag);
            model_summary=[model_summary, model_summary_one_file];

        
        end
        
    end
    
    
    
    %MW MODEL
    if strcmp(device,'Tetrode')
        %         [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers(feature_matrix_MW, class_MW, Subject_Data_Summary, device, percentage_data_testing, plotflag, 1, target_variance, saveflag);
        [model_summary_one_file]=Func_Model_All_Closest_Furthest_Whiskers_v2(feature_matrix_MW, class_MW, Subject_Data_Summary, device, target_variance, plotflag);
        
        if exist('model_summary', 'var')==1
            model_summary=[model_summary, model_summary_one_file];
        else
            model_summary=model_summary_one_file;
        end
        
    end
    
    temp=struct2table(model_summary);
    if saveflag==1
        writetable(temp,strcat(char(date), '_ModelSummary_NoDenoised.csv'));
    end
else
    model_summary=[];
end

%
% temp=struct2table(model_summary);
% writetable(temp,'ModelSummary_LDA_Fullvs3Whiskers.csv');
% writetable(temp,strcat(char(date), '_ModelSummary_NoDenoising.csv'));

%%
%%% UNCOMMENT WHEN PLOTTING POLAR PLOTS
% if polarplotflag==1
%     set(gca,'ThetaZeroLocation', 'bottom');
% %     set(gcf, 'Position', get(0, 'Screensize'));
%     legend(labels_whisker(1:end), 'Orientation', 'Vertical') % all whiskes for each rat]
%     set(gca,'FontSize', 16');
% end
% 
% 
% 
% if gammaflag==1
%     title(join({date device 'Gamma '}),'FontSize', 18);
% end
%
% saveas(gcf, strcat(char(join({date device type plot},'_')),'.eps'))
% saveas(gcf, strcat(char(join({date device type plot},'_')),'.jpg'))
% saveas(gcf, strcat(char(join({date device type plot},'_')),'.fig'))
%
%
