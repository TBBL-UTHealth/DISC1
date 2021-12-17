% File created based on voltage_spread_v4. I removed all the waveforms and
% CSD using Ulbert's way. Plots CSD in a different figure by file

% close all
windowduration = .100;
temp_sm=0;
spat_sm=0;

dates={'1-11-21', '1-13-21', '1-15-21', '1-27-21', '1-28-21',  '8-27-21', '9-7-21'}; % Recording date
device='DISC'; % Device type
date=char(dates(7));
ChooseChannels;
% ChooseDirectory;

channels_interest.model=[7	23	39	55	71	87	103	119;...
    8	24	40	56	72	88	104	120;...
    6	22	38	54	70	86	102	118;...
    9	25	41	57	73	89	105	121;...
    5	21	37	53	69	85	101	117;...
    10	26	42	58	74	90	106	122;...
    4	20	36	52	68	84	100	116;...
    11	27	43	59	75	91	107	123;...
    3	19	35	51	67	83	99	115;...
    12	28	44	60	76	92	108	124;...
    2	18	34	50	66	82	98	114;...
    13	29	45	61	77	93	109	125;...
    1	17	33	49	65	81	97	113;...
    14	30	46	62	78	94	110	126;...
    0	16	32	48	64	80	96	112;...
    15	31	47	63	79	95	111	127];
num_columns_CSD=size(channels_interest.model,1);

filelist=dir('*.mat');
labels_whisker=string();
col_num=8; 


 
figure
files=[1 4]; % for D1 and Gamma on 9-7-21
%  files=[1 2];
% whiskers={'B2','D2', 'Gamma'};



for i=1:2%length(filelist)%length(files)%6:length(filelist)% 
%     figure
    file_num=files(i); % use when specifying a vector of files that will be used
%     file_num=i; % use when doing all files in filelist
%     figure;
    color_labels=string();

    load(filelist(file_num).name)
    
    % Calculates matrix size depending on sampling rate
    temp=NeuralData(1).Sampling_Rate;
    temp=temp*windowduration*2 + 1;

    CSD_matrix=zeros(num_columns_CSD, temp);
    LFP_matrix=zeros(num_columns_CSD, temp); 
    
    threshold=max(NeuralData(1).Pulse_Signal);
    if threshold==1
        threshold=0.9999;
    else
        threshold=2.99;
    end
    

    labels_whisker(i)=NeuralData(1).Whisker_ID;

        
    for row=1:num_columns_CSD%size(channels_interest.model,1)
        for col=col_num:col_num%:size(channels_interest.model,2)
            position_struct=find([NeuralData.Channel_Number]==channels_interest.model(row,col));
            if ~isempty(position_struct)        %%% LFP
                LFP=NeuralData(position_struct).LFP;
                pulse_signal=NeuralData(position_struct).Pulse_Signal;
                Fsdown=NeuralData(position_struct).Sampling_Rate;
                [Snippet,time_snippet, TrialNumbers] = Func_GetSnippets(LFP, pulse_signal, threshold,windowduration, Fsdown);
                                
                %%% Average Waveform               
                Average_LFP=nanmean(Snippet);
               
                %%% Gradient Average Waveform
                dLFP=diff(Average_LFP)/0.5;
                d2LFP=diff(dLFP)/0.5;

                LFP_matrix(row,:)=Average_LFP;
   
            end
        end
    end
    

    
    
    %Transpose LFP_matrix to be able to use same code as Buszaki's lab. We will
    %then get time on the rows and electrodes on the columns
    LFP_matrix=LFP_matrix';
    
    % Does spatial and temporal smoothing from Buszaki's code
    % temporal smoothing
    if temp_sm > 0
        for ch = 1:size(LFP_matrix,2)
            LFP_matrix(:,ch) = smooth(LFP_matrix(:,ch),temp_sm,'sgolay');
        end
    end
    
    % spatial smoothing
    if spat_sm > 0
        for t = 1:size(LFP_matrix,1)
            LFP_matrix(t,:) = smooth(LFP_matrix(t,:),spat_sm,'lowess');
        end
    end
    % Calculates CSD - from Buszaki's code
    CSD=diff(LFP_matrix,2,2);
    
    subplot(1,2,i)
    c1=contourf(time_snippet,1:size(CSD,2),CSD',40,'LineColor','none');hold on;
     colormap jet;      
%      cmax = max(max(CSD)); caxis([-cmax cmax]);
    colorbar
%     if col_num==5
%         %         cmax=28;
%         cmax=70; % this is for when using the same scale for four plots
%     elseif col_num==1
%         cmax=70;
    %     end
    cmax=150;
    caxis([-cmax cmax]);
    colorbar('southoutside','Ticks',[-cmax, 0,  cmax],'TickLabels',{'Sink','0','Source '}) % for 9-7-21, D1 and Gamma

%      caxis([-280 280]);    %for 8-27-21, D2 and Gamma
%      colorbar('southoutside','Ticks',[-280, 0,  280],'TickLabels',{'Sink','0','Source '}) % for 9-7-21, D1 and Gamma

    yticks(1:12);
    yticklabels(string(0.1:0.2:2.4));
    %     ylim([100 2100])
    xlim([0 100])
    ylim([1 12])
   	xlabel('Time','FontSize',12);
    ylabel('Electrode depth (mm)','FontSize',12);
    title({date labels_whisker(i)}, 'FontSize', 18)
    set(gca, 'YDir','reverse')

    yyaxis right
    
    %normalize LFP matrix to plot traces
    LFP_matrix_norm=normalize(LFP_matrix);
    LFP_matrix=fliplr(LFP_matrix);
    hold on
    for j=2:11
        temp=LFP_matrix_norm(:,j);
        temp=(temp/7) +j;
        plot(time_snippet, temp,'-', 'LineWidth', 2, 'Color', [0.6 0.6 0.6])
    end
%     yticks([1 2.9 4.9 7.5 11.5]) %480 um (2.9) for end layer 3, 880 um (4.9) for end of layer 4, 1400 um (7.5) for layer 5, 2200 (11.5) for layer 6
    yticklabels({'L2', 'L3', 'L4', 'L5', 'L6'})
%     set(gca, 'YDir','reverse')
    ylabel('Layer End','FontSize',12);
%     ylim([1 12])

     sgtitle(['Column: ' num2str(col_num)])


end
