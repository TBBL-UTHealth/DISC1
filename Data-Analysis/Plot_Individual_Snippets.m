
WindowDuration=.1;
device='DISC'; % Device type
num_ch_RV=4;
num_ch=1; % 128, 64, 88, 44, 24, 12, 8, 4, 1

dates={'1-11-21', '1-13-21', '1-15-21', '1-27-21', '1-28-21', '8-27-21', '9-7-21', '9-29-21','10-05-21'}; % Recording date
subjects={'S1','S2','S3', 'S4', 'S5','S6', 'S7','S8', 'S9'};

for i=1:length(dates)
        date=char(dates(i));

    ChooseDirectory;
    
    ChooseChannels_v2;
    
filelist=dir('*.mat');
figure;
set(gcf,'color','w');

for file_num=1:length(filelist)
    load(filelist(file_num).name);
    threshold=max(NeuralData(1).Pulse_Signal);
    if threshold==1
        threshold=0.9999;
    else
        threshold=2.99;
    end
    position_struct=find([NeuralData.Channel_Number]==channels_interest.model);

    pulse_signal=NeuralData(position_struct).Pulse_Signal;
    Fsdown=NeuralData(position_struct).Sampling_Rate;
    LFP=NeuralData(position_struct).LFP;
    
    % LFP - Red
    [Snippet,time_snippet, ~] = Func_GetSnippets_v2(LFP, pulse_signal, threshold,WindowDuration, Fsdown);
    Average_Waveform=nanmean(Snippet);
    SD_Waveform= nanstd(Snippet);
    Waveform_SD1=Average_Waveform+SD_Waveform;
    Waveform_SD2=Average_Waveform-SD_Waveform;
    
    subplot(3,4,file_num)
    patch([time_snippet fliplr(time_snippet)], [Waveform_SD1 fliplr(Waveform_SD2)], [1 0.5 0.5],'EdgeColor', [0.85 0.85 0.85])
    alpha(0.2)
    hold on
    ax1=plot(time_snippet, Average_Waveform, 'LineWidth', 3, 'Color', [1 0 0]);
    
    % Gamma - Green
    Gamma=NeuralData(position_struct).LFP_Gamma;
    [Snippet_Gamma,time_snippet, TrialNumbers] = Func_GetSnippets_v2(Gamma, pulse_signal, threshold,WindowDuration, Fsdown);
    Average_Waveform=nanmean(Snippet_Gamma);
    SD_Waveform= nanstd(Snippet_Gamma);
    Waveform_SD1=Average_Waveform+SD_Waveform;
    Waveform_SD2=Average_Waveform-SD_Waveform;
    patch([time_snippet fliplr(time_snippet)], [Waveform_SD1 fliplr(Waveform_SD2)], [0.75 1 0.8],'EdgeColor', [0.85 0.85 0.85])
    alpha(0.2)
    hold on
    ax2=plot(time_snippet, Average_Waveform, 'LineWidth', 3, 'Color', [0 .8 0.3]);
    
    
    % Beta - Blue
    Fpass1 = 13;          % First Passband Frequency
    Fpass2 = 30;         % Second Passband Frequency
    [b,a] = butter(5,[Fpass1 Fpass2]./((Fsdown)/2),'bandpass');
    LFP_Beta=filtfilt(b,a,LFP);
    [Snippet_Beta,~, ~] = Func_GetSnippets_v2(LFP_Beta, pulse_signal, threshold,WindowDuration, Fsdown);
    Average_Waveform=nanmean(Snippet_Beta);
    SD_Waveform= nanstd(Snippet_Beta);
    Waveform_SD1=Average_Waveform+SD_Waveform;
    Waveform_SD2=Average_Waveform-SD_Waveform;
    patch([time_snippet fliplr(time_snippet)], [Waveform_SD1 fliplr(Waveform_SD2)], [0.5 0.8 1],'EdgeColor', [0.85 0.85 0.85])
    alpha(0.2)
    hold on
    ax3=plot(time_snippet, Average_Waveform, 'LineWidth',3, 'Color', [0 0 1]);
    
    if file_num==1
        legend([ax1 ax2 ax3],{'LFP', 'Gamma', 'Beta'} )
    end
    title(NeuralData(1).Whisker_ID, 'fontsize', 16)
    
end
    sgtitle(join({char(subjects(i)), 'FFT Snippets'}),'fontweight','bold', 'fontsize', 20)

end
% save('Snippets_D2_211005.mat','Snippet', 'Snippet_Gamma', 'Snippet_Beta', 'time_snippet')
