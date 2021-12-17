function [rawdata_down,time_down, LFP, Gamma] = FilterDownsampleLFP(rawdata,samplingrate, Fsdown, time)
%FilterLFP Low pass filters raw data with a 120 Hz cutoff and downsamples
%the data to the specified frequency
%   INPUT
%   rawdata is the Intan Rawdata
%   samplingrate is the sampling rate that intan used to acquire the raw
%       data
%   Fsdown is the new frequency that wants to be sampled

%%% DOWN SAMPLING
rawdata_down=downsample(rawdata,samplingrate/Fsdown);
time_down=downsample(time,samplingrate/Fsdown);


%%% LFP
Fpass = 120;             % Passband Frequency
Fstop = 400;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.01;            % Stopband Attenuation
dens  = 20;              % Density Factor


% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fsdown/2), [1 0], [Dpass, Dstop]);


% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);


LFP = filter(Hd,rawdata_down);
%plot(time_down,LFP)
%pspectrum(LFP,Fsdown);%,'spectrogram')

% %%% Removes 60 Hz noise
% d = designfilt('bandstopiir','FilterOrder',2, ...
%     'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
%     'DesignMethod','butter','SampleRate',Fsdown);
% %fvtool(d,'Fs',Fsdown);
% LFP = filtfilt(d,LFP);
% %%% Removes 60 Hz noise


    
%%% GAMMA
Fpass1 = 40;          % First Passband Frequency
Fpass2 = 150;         % Second Passband Frequency


[b,a] = butter(5,[Fpass1 Fpass2]./((Fsdown)/2),'bandpass');
Gamma = filtfilt(b,a,rawdata_down);

% %%% Removes 60 Hz noise
% d = designfilt('bandstopiir','FilterOrder',2, ...
%     'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
%     'DesignMethod','butter','SampleRate',Fsdown);
% %fvtool(d,'Fs',Fsdown);
% Gamma = filtfilt(d,Gamma);
% %%% Removes 60 Hz noise



end

