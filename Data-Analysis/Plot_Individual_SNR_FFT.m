
WindowDuration=.20;
device='DISC'; % Device type
num_ch_RV=4;
num_ch=1; % 128, 64, 88, 44, 24, 12, 8, 4, 1

dates={'1-11-21', '1-13-21', '1-15-21', '1-27-21', '1-28-21', '8-27-21', '9-7-21', '9-29-21','10-05-21'}; % Recording date
subjects={'S1','S2','S3', 'S4', 'S5','S6', 'S7','S8', 'S9'};
figure;
set(gcf,'color','w');
Gamma_SNR=[];
Low_Gamma_SNR=[];
High_Gamma_SNR=[];

plot_colors=[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];...
    [0.4660 0.6740 0.1880]; [0.3010 0.7450 0.9330]; [0.6350 0.0780 0.1840];[1.0000 0.7109 0.7568];...
    [0.5000 0.5000 0.5000];[1.0000 0.0784 0.5764];[0.5000 0      1.0000];[0.5000 0.2350 0.0000] ];

%% Plots full gamma, LFP and beta SNR on same plot. There's one figure per animal, and one subplot by whisker
for i=1%:length(dates)
        date=char(dates(i));

    ChooseDirectory;
    
    ChooseChannels_v2;
    
filelist=dir('*.mat');
figure;
set(gcf,'color','w');
max_min_SNR=[0 0];
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
    Baseline=Snippet(:,1:(WindowDuration*1000/.5));
    Snippet=Snippet(:,(WindowDuration*1000/.5 + 2):(WindowDuration*1000*2/.5 + 1)); % if looking only 0.5 to window duration ms
    T = 1/Fsdown;             % Sampling period
    n=size(Snippet,2);
    freqDomain = Fsdown*(0:(n/2))/n;
    
    Y = fft(nanmean(Snippet)); % average waveform fft
    Y_baseline = fft(nanmean(Baseline)); % average waveform fft
    
    subplot(3,4,file_num)
    temp=10.*log10(abs(Y)./abs(Y_baseline));
    ax1=plot(freqDomain,temp(1:n/2+1), 'Color', [1 0 0], 'LineWidth', 3);
    hold on
    xlabel('Frequency (f)','fontsize', 12)
    ylabel('SNR (dB)', 'fontsize', 12)
    xlim([0 120])
    if max(temp)>max_min_SNR(2)
        max_min_SNR(2)=max(temp);
    end
    if min(temp)<max_min_SNR(1)
        max_min_SNR(1)=min(temp);
    end
    % Gamma - Green
    Gamma=NeuralData(position_struct).LFP_Gamma;
    [Snippet_Gamma,time_snippet, TrialNumbers] = Func_GetSnippets_v2(Gamma, pulse_signal, threshold,WindowDuration, Fsdown);
    Baseline=Snippet_Gamma(:,1:(WindowDuration*1000/.5));
    Snippet=Snippet_Gamma(:,(WindowDuration*1000/.5 + 2):(WindowDuration*1000*2/.5 + 1)); % if looking only 0-100 ms

    T = 1/Fsdown;             % Sampling period
    n=size(Snippet,2);
    freqDomain = Fsdown*(0:(n/2))/n;
    
    Y = fft(nanmean(Snippet)); % average waveform fft
    Y_baseline = fft(nanmean(Baseline)); % average waveform fft
    
    temp=10.*log10(abs(Y)./abs(Y_baseline));
    ax2=plot(freqDomain,temp(1:n/2+1), 'Color', [0 1 0], 'LineWidth', 3, 'DisplayName', 'Gamma');
    hold on
    Gamma_SNR=[Gamma_SNR; temp];
    if max(temp)>max_min_SNR(2)
        max_min_SNR(2)=max(temp);
    end
    if min(temp)<max_min_SNR(1)
        max_min_SNR(1)=min(temp);
    end
    
    % Beta - Blue
    Fpass1 = 13;          % First Passband Frequency
    Fpass2 = 30;         % Second Passband Frequency
    [b,a] = butter(5,[Fpass1 Fpass2]./((Fsdown)/2),'bandpass');
    LFP_Beta=filtfilt(b,a,LFP);
    [Snippet_Beta,~, ~] = Func_GetSnippets_v2(LFP_Beta, pulse_signal, threshold,WindowDuration, Fsdown);
    Baseline=Snippet_Beta(:,1:(WindowDuration*1000/.5));
    Snippet=Snippet_Beta(:,(WindowDuration*1000/.5 + 2):(WindowDuration*1000*2/.5 + 1)); % if looking only 0.5 to window duration ms

    T = 1/Fsdown;             % Sampling period
    n=size(Snippet,2);
    freqDomain = Fsdown*(0:(n/2))/n;
    
    Y = fft(nanmean(Snippet)); % average waveform fft
    Y_baseline = fft(nanmean(Baseline)); % average waveform fft
    temp=10.*log10(abs(Y)./abs(Y_baseline));
    
    ax3=plot(freqDomain,temp(1:n/2+1), 'Color', [0 0 1], 'LineWidth', 3);
    if max(temp)>max_min_SNR(2)
        max_min_SNR(2)=max(temp);
    end
    if min(temp)<max_min_SNR(1)
        max_min_SNR(1)=min(temp);
    end
    
    if file_num==1
        legend([ax1 ax2 ax3],{'LFP', 'Gamma', 'Beta'} )
    end
    title(NeuralData(1).Whisker_ID, 'fontsize', 16)    

end
sgtitle(join({char(subjects(i)), 'FFT SNR'}),'fontweight','bold', 'fontsize', 20)

for file_num=1:length(filelist)
    subplot(3,4, file_num)
    ylim([max_min_SNR(1) max_min_SNR(2)]);
end
end
% save('Snippets_D2_211005.mat','Snippet', 'Snippet_Gamma', 'Snippet_Beta', 'time_snippet')
temp=nanmean(Gamma_SNR);plot(freqDomain, temp(1:n/2+1), 'Color', [0 0 0], 'Linewidth', 2)

%%  Plots all gammas on same plot, but it's separated by band
figure;
set(gcf,'color','w');
for i=1:length(dates)
        date=char(dates(i));

    ChooseDirectory;
    
    ChooseChannels_v2;
    
filelist=dir('*.mat');
% % figure;
% set(gcf,'color','w');

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
    
    % Full Gamma - Green
    Gamma=NeuralData(position_struct).LFP_Gamma;
    [Snippet_Gamma,time_snippet, TrialNumbers] = Func_GetSnippets_v2(Gamma, pulse_signal, threshold,WindowDuration, Fsdown);
    Baseline=Snippet_Gamma(:,1:(WindowDuration*1000/.5));
    Snippet=Snippet_Gamma(:,(WindowDuration*1000/.5 + 2):(WindowDuration*1000*2/.5 + 1)); % if looking only 0-100 ms

    T = 1/Fsdown;             % Sampling period
    n=size(Snippet,2);
    freqDomain = Fsdown*(0:(n/2))/n;
    
    Y = fft(nanmean(Snippet)); % average waveform fft
    Y_baseline = fft(nanmean(Baseline)); % average waveform fft
    
%     subplot(3,1,1)
    subplot(1,3,1)

    temp=10.*log10(abs(Y)./abs(Y_baseline));
    ax2=plot(freqDomain,temp(1:n/2+1), 'Color', plot_colors(i,:), 'LineWidth', 1, 'DisplayName', char(subjects(i)));
    hold on
    Gamma_SNR=[Gamma_SNR; temp];
    title('Full Gamma');
    xlabel('Frequency (f)','fontsize', 12)
    ylabel('SNR (dB)', 'fontsize', 12)
    xlim([0 120])
    
    % Low Gamma - Lime green
    Fpass1 = 30;          % First Passband Frequency
    Fpass2 = 59;         % Second Passband Frequency
    [b,a] = butter(5,[Fpass1 Fpass2]./((Fsdown)/2),'bandpass');
    LFP=filtfilt(b,a,Gamma);
    [Snippet,~, ~] = Func_GetSnippets_v2(LFP, pulse_signal, threshold,WindowDuration, Fsdown);
    Baseline=Snippet(:,1:(WindowDuration*1000/.5));
    Snippet=Snippet(:,(WindowDuration*1000/.5 + 2):(WindowDuration*1000*2/.5 + 1)); % if looking only 0.5 to window duration ms
    
    n=size(Snippet,2);
    freqDomain = Fsdown*(0:(n/2))/n;
    
    Y = fft(nanmean(Snippet)); % average waveform fft
    Y_baseline = fft(nanmean(Baseline)); % average waveform fft
        xlabel('Frequency (f)','fontsize', 12)
    ylabel('SNR (dB)', 'fontsize', 12)
    xlim([0 120])
%     subplot(3,1,2)
        subplot(1,3,2)

    temp=10.*log10(abs(Y)./abs(Y_baseline));
    ax2=plot(freqDomain,temp(1:n/2+1), 'Color', plot_colors(i,:), 'LineWidth', 1, 'DisplayName', char(subjects(i)));
    hold on
    Low_Gamma_SNR=[Low_Gamma_SNR; temp];
    title('Low Gamma');
    xlabel('Frequency (f)','fontsize', 12)
    ylabel('SNR (dB)', 'fontsize', 12)
    xlim([0 120])
    
    % High Gamma 
    Fpass1 = 62;          % First Passband Frequency
    Fpass2 = 120;         % Second Passband Frequency
    [b,a] = butter(5,[Fpass1 Fpass2]./((Fsdown)/2),'bandpass');
    LFP=filtfilt(b,a,Gamma);
    [Snippet,~, ~] = Func_GetSnippets_v2(LFP, pulse_signal, threshold,WindowDuration, Fsdown);
    Baseline=Snippet(:,1:(WindowDuration*1000/.5));
    Snippet=Snippet(:,(WindowDuration*1000/.5 + 2):(WindowDuration*1000*2/.5 + 1)); % if looking only 0.5 to window duration ms
    
    n=size(Snippet,2);
    freqDomain = Fsdown*(0:(n/2))/n;
    
    Y = fft(nanmean(Snippet)); % average waveform fft
    Y_baseline = fft(nanmean(Baseline)); % average waveform fft
    
    subplot(1,3,3)
    temp=10.*log10(abs(Y)./abs(Y_baseline));
    ax2=plot(freqDomain,temp(1:n/2+1), 'Color', plot_colors(i,:), 'LineWidth', 1, 'DisplayName', char(subjects(i)));
    hold on
    High_Gamma_SNR=[High_Gamma_SNR; temp];
    title('High Gamma');
    xlabel('Frequency (f)','fontsize', 12)
    ylabel('SNR (dB)', 'fontsize', 12)
    xlim([0 120])
end
%     sgtitle(join({char(subjects(i)), 'FFT SNR'}),'fontweight','bold', 'fontsize', 20)

end
% save('Snippets_D2_211005.mat','Snippet', 'Snippet_Gamma', 'Snippet_Beta', 'time_snippet')
temp=nanmean(Gamma_SNR);subplot(1,3,1); plot(freqDomain, temp(1:n/2+1), 'Color', [0 0 0], 'Linewidth', 2)
temp=nanmean(Low_Gamma_SNR);subplot(1,3,2); plot(freqDomain, temp(1:n/2+1), 'Color', [0 0 0], 'Linewidth', 2)
temp=nanmean(High_Gamma_SNR);subplot(1,3,3); plot(freqDomain, temp(1:n/2+1), 'Color', [0 0 0], 'Linewidth', 2)
