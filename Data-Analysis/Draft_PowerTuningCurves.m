if strcmp(device,'DISC')
    ch_num=11;
    DISC_Angles=[-5, 91, 187, 283]; % DISC angles for 2021 recordings
    DISC_Angles_tuning=[-5 91 187 283 355 451 547 643 715 811 907 1003]; % DISC angles for 2021 recordings

else
    ch_num=4;
    DISC_Angles=0:90:270; % DISC angles for 2021 recordings
    DISC_Angles_tuning=0:90:1000; % DISC angles for 2021 recordings

end

figure;
 hold on
for a=1:5
plot(NeuralData(ch_num).Directional_Trials_Gamma_Power_25Hz(a,:), 'LineWidth', 3, 'Color', 'blue')
plot(NeuralData(ch_num).Directional_Trials_Gamma_Power_50Hz(a,:), 'LineWidth', 3, 'Color', 'red')
plot(NeuralData(ch_num).Directional_Trials_Gamma_Power_75Hz(a,:), 'LineWidth', 3, 'Color', 'green')
plot(NeuralData(ch_num).Directional_Trials_Gamma_Power_100Hz(a,:), 'LineWidth', 3, 'Color', 'cyan')
plot(NeuralData(ch_num).Directional_Trials_Gamma_Power_125Hz(a,:), 'LineWidth', 3, 'Color', 'black')

end

legend('25 Hz', '50 Hz', '75 Hz', '100 Hz', '125 Hz')
set(gca, 'Yscale', 'log')


%%

figure;
angles=0:binsize:1080;
angles_rad=[0:binsize:360].*(pi/180);

%     tuning_vector=NeuralData(11).Directional_Trials_Gamma_Power_25Hz(a,:);
tuning_vector=mean([NeuralData(ch_num).Directional_Trials_Gamma_Power_25Hz], 'omitnan' );

tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'pchip');
tuning_vector_smoothed=tuning_vector_smoothed(angles>=360 & angles<=720);
%     polarplot(angles_rad,tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'blue')
plot(tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'blue')

hold on

tuning_vector=mean([NeuralData(ch_num).Directional_Trials_Gamma_Power_50Hz], 'omitnan');
tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'pchip');
tuning_vector_smoothed=tuning_vector_smoothed(angles>=360 & angles<=720);
%     polarplot(angles_rad,tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'blue')
plot(tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'red')
hold on

tuning_vector=mean([NeuralData(ch_num).Directional_Trials_Gamma_Power_75Hz], 'omitnan');
tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'pchip');
tuning_vector_smoothed=tuning_vector_smoothed(angles>=360 & angles<=720);
%     polarplot(angles_rad,tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'blue')
plot(tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'green')
hold on


tuning_vector=mean([NeuralData(ch_num).Directional_Trials_Gamma_Power_100Hz], 'omitnan');
tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'pchip');
tuning_vector_smoothed=tuning_vector_smoothed(angles>=360 & angles<=720);
%     polarplot(angles_rad,tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'blue')
plot(tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'cyan')
hold on

tuning_vector=mean([NeuralData(ch_num).Directional_Trials_Gamma_Power_125Hz], 'omitnan');
tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'pchip');
tuning_vector_smoothed=tuning_vector_smoothed(angles>=360 & angles<=720);
%     polarplot(angles_rad,tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'blue')
plot(tuning_vector_smoothed, 'LineWidth', 3, 'Color', 'black')
hold on

legend('25 Hz', '50 Hz', '75 Hz', '100 Hz', '125 Hz')
