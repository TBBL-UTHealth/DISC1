%Format_Data extracts the Intan data from the file specified, it filters and
%downsamples the LFP data,

% Convert files to .mat
clear all
close all

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

%barrel_position='NA';
%date='201103';
%session_num=1;

filelist=dir('*.rhd');
for file_num=1:length(filelist)
    file=filelist(file_num).name;
    path=join([filelist(file_num).folder, '\']);        
    read_Intan_RHD2000_file_nonotch_automatic(file, path);                       % This reads .rhd file
    [filepath,name,ext] = fileparts(filename)
    samplingrate=frequency_parameters.amplifier_sample_rate;
    temp=split(name, '-');
    Whisker_Stimulated=temp(1);

    
%     CAR_Average=mean(amplifier_data,1, 'Omitnan');
%     
%     amplifier_data=amplifier_data-CAR_Average;

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
        

        
        
        if exist('NeuralData')==0
            
            %%% Create data structure. If loading a NeuralData structure, comment the
            %%% below line and run the next ones.
            
            NeuralData=struct('Filename', filename, 'Channel_Impedance_Magnitude', amplifier_channels(i).electrode_impedance_magnitude,...
                'Whisker_ID',Whisker_Stimulated,'Recording_Device_Type', recordingdevice, 'Channel_Number', amplifier_channels(i).native_order,...
                'LFP', LFP,'Time', time_down, 'LFP_Gamma', Gamma,'Sampling_Rate', Fsdown, 'Pulse_Signal', pulse_signal);
            
        else
            %%% Add data into the Neural Data structure to the last row
            addrow=length(NeuralData)+1;
            NeuralData(addrow).Filename=filename;
            NeuralData(addrow).Channel_Impedance_Magnitude=amplifier_channels(i).electrode_impedance_magnitude;
            NeuralData(addrow).Whisker_ID=Whisker_Stimulated;
            NeuralData(addrow).Recording_Device_Type=recordingdevice;
            NeuralData(addrow).Channel_Number = amplifier_channels(i).native_order;
            NeuralData(addrow).LFP = LFP;
            NeuralData(addrow).LFP_Gamma = Gamma;
            NeuralData(addrow).Time = time_down;
            NeuralData(addrow).Sampling_Rate = Fsdown;
            NeuralData(addrow).Pulse_Signal = pulse_signal;
        end
    end
    
    current_dir=pwd;
    
    % Saves Structure
    cd(path);
    if CSDFlag==1
        save(strcat(name,'_WhiskerLFPData_SR20kHz_LP100Hz.mat'), 'NeuralData', '-v7.3');

    else
        save(strcat(name,'_WhiskerLFPData.mat'), 'NeuralData', '-v7.3');
    end
    cd(current_dir);
    
    clear NeuralData
end
