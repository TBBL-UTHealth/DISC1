%Format_Data extracts the Intan data from the file specified, it filters and
%downsamples the LFP data and saves it in a .mat structure
% -v3 optimizes data structure. LFP and Gamma signals are saved into a
% substructure instead of a new one. Pulse signal, time, whisker ID,
% filename are no longer repeated throughout the structure for each channel

clear all
close all
windowduration=.3;

%%% Define variables
Fsdown = 2000; %2k sampling rate
CSDFlag=0;
if CSDFlag==1
    Fsdown = 20000; %20k sampeling rate
end
% recordingdevice = 'DISC';
recordingdevice = 'DISC';
% recordingdevice = 'Tetrode';
%recordingdevice = 'Macroelectrode';

filelist=dir('*.rhd');
for file_num=1%:length(filelist)
    file=filelist(file_num).name;
    path=join([filelist(file_num).folder, '\']);        
    read_Intan_RHD2000_file_nonotch_automatic(file, path);                       % This reads .rhd file
    [filepath,name,ext] = fileparts(filename);
    samplingrate=frequency_parameters.amplifier_sample_rate;
    temp=split(name, '-');
    if size(temp, 1)==1
        temp=split(name, '_');
    end
    Whisker_Stimulated=temp(1);

    
    %%% Create data structure. If loading a NeuralData structure, comment the
    %%% below line and run the next ones.

    NeuralData=struct('Filename', filename, 'Whisker_ID',Whisker_Stimulated,'Recording_Device_Type', recordingdevice,...
        'Sampling_Rate', Fsdown,  'iEEG', []);


    for i = 1:size(amplifier_data,1)
        rawdata=amplifier_data(i,:);
   
        time=t_amplifier;
        
        %%% Define variables
        if exist('board_dig_in_data', 'var') == 1                                   %For digital data
            pulse_signal=downsample(board_dig_in_data(1,:),samplingrate/Fsdown);        % Pulse is in the first channel
            threshold=0.9999;
        else
            pulse_signal=downsample(board_adc_data, samplingrate/Fsdown);               %For analog data
            threshold=2.99;
        end
        
        %%% Obtains data vectors and saves them in a structure. Downsamples, filters LFP and divides data into snippets
        [rawdata_down,time_down, LFP, Gamma] = Func_FilterDownsampleLFP_v3(rawdata,samplingrate, Fsdown, time);
        
%         [Snippet,~, ~] = Func_GetSnippets_v2(LFP, pulse_signal, threshold,windowduration, Fsdown);
%         
%         %%% GAMMA        
%         [Snippet_Gamma,time_snippet, TrialNumbers] = Func_GetSnippets_v2(Gamma, pulse_signal, threshold,windowduration, Fsdown);

        
        %%% Add data into the Neural Data structure to the last row
        addrow=length(NeuralData.iEEG)+1;
        NeuralData.iEEG(addrow).Channel_Impedance_Magnitude=amplifier_channels(i).electrode_impedance_magnitude;
        NeuralData.iEEG(addrow).Channel_Number = amplifier_channels(i).native_order;
        NeuralData.iEEG(addrow).LFP = LFP;
        NeuralData.iEEG(addrow).LFP_Gamma = Gamma;
%         NeuralData.iEEG(addrow).LFP_Trials = Snippet;
%         NeuralData.iEEG(addrow).Gamma_Trials = Snippet_Gamma;
        
        if i==1
%             NeuralData.Time=time_down;
            NeuralData.Pulse_Signal=pulse_signal;
            NeuralData.Time=time_down;
        end
    end
    
    current_dir=pwd;
    
    % Saves Structure
    cd(path);
%     if CSDFlag==1
%         save(strcat(name,'_WhiskerLFPData_SR20kHz_LP100Hz.mat'), 'NeuralData', '-v7.3');
% 
%     else
%         save(strcat(name,'_WhiskerLFPData.mat'), 'NeuralData', '-v7.3');
%     end
    cd(current_dir);
    
%     clear NeuralData
end
