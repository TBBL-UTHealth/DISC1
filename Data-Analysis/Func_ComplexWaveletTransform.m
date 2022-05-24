function [coefsi]=Func_ComplexWaveletTransform(LFP,window,noverlap, Fs, F, time, spectrogramflag)
    % Wavelet Analysis
    % Outputs: 
    % coefsi is the coefficients of the Morlet Complex Wavelet Transform
    % Inputs:
    % window is the size of the sliding window applied in the Fourier analysis.
    % If the sampling rate is 2000 data points per second
    % a window of 1000 represents 1/2 second or 500 ms of data
    % noverlap is the amount of overlap from one window to the next . An overlap of 800 samples
    % will mean that the window steps over the data in 100 ms increments
    % (1000-800 = 200 samples = 100 ms)
    % Fs is the sampling rate
    % F is the range of frequencies to compute spectral data. It's a vector
    % with the first value being the minimum frequency and the last one tha max
    % frequency

% figure;     set(gcf,'color','w');

if spectrogramflag==1
    subplot(1,4,1);
else
    subplot(1, 3,1);
end
plot(time,LFP); hold on
title('Original Signal ', 'FontSize', 16);
xlabel('Time (ms)'); ylabel('Voltage (uV)')

if spectrogramflag==1
    subplot(1,4,2);
else
    subplot(1, 3,2);
end
pspectrum(LFP, Fs); hold on
%      set(gca,'LineWidth',3)
xlim([min(F/1000) max(F/1000)])
xl = xticks*1000;
set(gca, 'XTickLabel',xl)
xlabel('Frequency (Hz)')
title('Signal Power Spectrum', 'FontSize', 16);
grid off

temp=find(mod(round(time,1), 50) == 0);

if spectrogramflag==1
    subplot(1,4,3);

    spectrogram(LFP , window ,noverlap ,F,Fs,'yaxis');
    set(gca, 'XTick', temp/2)
    set(gca, 'XTickLabel',time(temp), 'FontSize', 8)

%     view(2)
    colormap jet;
    title('Spectrogram of Signal ','FontSize', 16);

end


% Morlet wavelet
coefsi = cwt(LFP ,centfrq('cmor1 -1 ')*Fs./F,'cmor1 -1 ');
if spectrogramflag==1
    subplot(1,4,4);
else
    subplot(1,3,3);
end
wm_image = imagesc(abs(coefsi));
ylabel('Frequency (Hz)')
xlabel('Time (ms)')
set(gca, 'YDir','normal')
%     xlim([0 1001])
set(gca, 'XTick', temp)
% set(gca, 'XTickLabel',time(temp))
set(gca, 'XTickLabel',time(temp), 'FontSize',8)

title('Spectrogram of Complex Wavelet ','FontSize', 16);
    colormap jet;

% Mexican hat wavelet
%     coefsi_hat = cwt(LFP ,centfrq('mexh ')*Fs./[2:40], 'mexh ');
%     imagesc(abs(coefsi_hat));
end