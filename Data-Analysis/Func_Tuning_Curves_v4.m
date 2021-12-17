function [tuning_matrix,]=Func_Tuning_Curves_v4(NeuralData, channels_interest, binsize, plotflag, plot_colors, gammaflag, data_flag,date)
% Tuning_Curves will generate the tuning curve from the indicated channels
% channels_interest is an nx8 matrix that includes the channels that want
% to be used for the tuning curve. 8 is the number of columns, and n is the
% number of rows. 
% Binsize indicates the number of degrees you want to use as a bin for the
% smoothing
% plotflag, 0 not to plot, and 1 to plot tuning curves - smoothed
% color will give you the color of plot
% gammaflag, 0 do full LFP, 1 do tuning curves using gamma
% data_flag used to indicate manipulations in the data. 0 is raw amplitude,
% 1 brings min to 0 (subtract min), 2 is normalization (divide by max
% amplitude)
% tuning matrix is a nx8 matrix that includes the smoothed amplitude values 
% needed to create a tuning curve
% -v2 added Rayleigh z test
% -v3 automates DISC angles based on the date
% -v4 comments out interpolation completely, as this will be done in python
tuning_matrix=zeros(size(channels_interest,1),size(channels_interest,2));
tuning_matrix_smoothed=zeros(size(channels_interest,1),(360/binsize)+1);
magnitude=[];
direction=[];

tuning_vector=zeros(1,size(channels_interest,2));

for i=1:1 %size(channels_interest,1) % rows
    for j=1:size(channels_interest,2) % columns
        channel_number=channels_interest(i,j);
        position_struct=find([NeuralData.Channel_Number]==channel_number);
        if isempty(position_struct)==0
            if gammaflag==1
                tuning_vector(j)=NeuralData(position_struct).Amplitude_Gamma;
            else
                tuning_vector(j)=NeuralData(position_struct).Amplitude;
            end
            %Unsmoothed tuning_matrix
        else
            tuning_vector(j)=NaN;
        end
    end
    
%      DISC_Angles=[5, 55, 105, 155, 205, 255, 305, 355]; % DISC angles for 2020 recordings
%      DISC_Angles_tuning =[5 55 105 155 205 255 305 355 365 415 465 515 565 615 665 715 725 775 825 875 925 975 1025 1075];
%      DISC_Angles=[5, 105, 205, 305]; % DISC angles for 2020 recordings, 4 coulmns
%      DISC_Angles_tuning =[5 105  205  305  365  465  565  665  725  825  925  1025 ];
     %
     if strcmp(NeuralData(1).Recording_Device_Type, 'DISC')
         
         if size(channels_interest,2)==8
             if strcmp(date,'1-11-21') || strcmp(date, '1-13-21') || strcmp(date,'1-15-21')...
                     || strcmp(date, '1-27-21') || strcmp(date, '1-28-21')
                 DISC_Angles=[-5, 43, 91, 139, 187, 235, 283, 331]; % DISC angles for Jan 2021 recordings
                 DISC_Angles_tuning=[-5 43 91 139 187 235 283 331 355 403 451 499 547 595 643 691 715 763 811 859 907 955 1003 1051]; % DISC angles for 2021 recordings
             elseif strcmp(date,'8-27-21') || strcmp(date, '9-7-21') || strcmp(date, '9-9-21')
                 DISC_Angles=[86, 131, 177, 221, 263, 307, 350, 28]; % DISC angles for Jan 2021 recordings
                 DISC_Angles_tuning=[86   131   177   221   263   307   350    28 ...
                     446   491   537   581   623   667   710   388 ...
                     806   851   897   941   983   1027  1070  748]; % DISC angles for 2021 recordings
             elseif strcmp(date, '9-29-21') || strcmp(date, '10-05-21')
                 DISC_Angles=[-20, 25, 70, 115, 160, 205, 250, 295 ];
                 DISC_Angles_tuning = [-20 25 70 115 160 205 250 295 ...
                    340 385 430 475 520 565 610 655 ...
                    700 745 790 835 880 925 970 1015];
             end
             
         elseif size(channels_interest,2)==4
             if strcmp(date,'1-11-21') || strcmp(date, '1-13-21') || strcmp(date,'1-15-21')...
                     || strcmp(date, '1-27-21') || strcmp(date, '1-28-21')
                 %      Four columns DISC
                 DISC_Angles=[-5, 91, 187, 283]; % DISC angles for Jan 2021 recordings
                 DISC_Angles_tuning=[-5 91 187 283 355 451 547 643 715 811 907 1003]; % DISC angles for  Jan 2021 recordings
             elseif strcmp(date,'8-27-21') || strcmp(date, '9-7-21') || strcmp(date, '9-9-21')
                 DISC_Angles=[86 177 263 350 ];
                 DISC_Angles_tuning=[86 177 263 350 446 537 623 710 806  897 983 1070];
             elseif strcmp(date, '9-29-21') || strcmp(date, '10-05-21')
                 DISC_Angles=[-20, 70, 160, 250];
                 DISC_Angles_tuning = [-20  70  160  250  ...
                    340 430 520 610  ...
                    700 790 880 970 ];
             end
         end
     else
         if size(channels_interest,2)==8
             DISC_Angles=[0, 45, 90, 135, 180, 225, 270, 315, 360]; % DISC angles for 2021 recordings
             DISC_Angles_tuning=[0 45 90 135 180 225 270 315 360 405 450 495 540 585 630 675 720 765 810 855 900 945 990 1035]; % DISC angles for 2021 recordings
         elseif size(channels_interest,2)==4
             DISC_Angles=[0, 90, 180, 270]; % for tetrodes
             DISC_Angles_tuning=[0 90 180 270 360 450 540 630 720 810 900 990 ]; % for tetrodes
         end
     end
        % Smooth data
    angles=0:binsize:1080;

%     % x angles are separated 50 degrees because they are dependent on the DISC angle
%     tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
% %     tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'pchip');
%     tuning_vector_smoothed=interp1(DISC_Angles_tuning, tuning_vector_smoothed,angles, 'linear');
%     
    %     figure
%     plot(angles, tuning_vector_smoothed, 'LineWidth', 3)
%     xlim([360 720])
%     ylim([0 150])
%     
% 
% angles_rad=[0:binsize:360].*(pi/180);
% tuning_matrix(i, :)=tuning_vector;
% tuning_matrix_smoothed(i,:)=tuning_vector_smoothed(angles>=360 & angles<=720);
% angles=0:binsize:360;

% pval_omni=NaN;
% [pval_ray, ~]=circ_rtest(circ_ang2rad(DISC_Angles), tuning_vector); % if a channel has a NaN, this would become a NaN
% [pval_omni, ~]=circ_otest(circ_ang2rad(DISC_Angles), 22.5, tuning_vector);
% [pval_rao, ~]=circ_vtest(angles_rad, tuning_matrix_smoothed(i,:));
% data_flag used to indicate manipulations in the data. 0 is raw amplitude,
% 1 is regularization (subtract mean), 2 is normalization (divide by max
% amplitude)
% switch data_flag
%     case 0
%         temp=tuning_matrix_smoothed(i,:);
%     case 1
%         temp=tuning_matrix_smoothed(i,:)-min(tuning_matrix_smoothed(i,:))+.0001;
%     case 2
%         temp=tuning_matrix_smoothed(i,:)/max(tuning_matrix_smoothed(i,:));
% end
% [pval_ray, ~]=circ_rtest(angles_rad, temp);
% % [pval_omni, ~]=circ_otest(angles_rad, 1, temp);
% pval_omni=nan;
% 
% x=temp.*cosd(angles); % If using tuning_matrix_smoothed, magnitude gets too high
% y=temp.*sind(angles);
% % x=tuning_vector.*cosd(DISC_Angles); % If using tuning_matrix_smoothed, magnitude gets too high
% % y=tuning_vector.*sind(DISC_Angles);
% 
% x_mean=nanmean(x);
% y_mean=nanmean(y);
% x=nansum(x); 
% y=nansum(y);
% 
% %%% Calculates vector magnitude and direction
% if x>=0 & y>=0
%     direction(i)=atand(y/x);
% elseif x<0 & y>=0
%     direction(i)=180-atand(y/x);
% elseif x<0 & y<0
%     direction(i)=180+atand(y/x);
% elseif x>=0 & y<0
%     direction(i)=360+atand(y/x);
%     
% end
% magnitude(i)=sqrt((x^2)+(y^2));
% 
% end

% Resultant vectors


if plotflag ==1
    %hold all
    for i=1:size(channels_interest,1)
        color=plot_colors(i,:);
        %plot(0:binsize:360, tuning_matrix_smoothed(i,:), 'LineWidth', 4, 'Color', color)
        angles_rad=[0:binsize:360].*(pi/180);
%         subplot(1,2,1)
        polarplot(angles_rad,temp, 'LineWidth', 4, 'Color', color) % for 10 degree smooth bins
        hold on
%         subplot(1,2,2)
%         polarplot([0 circ_ang2rad(direction(i))],[0 magnitude(i)],'-', 'LineWidth', 4, 'Color', color)

        hold on
    end
    
    %xlim([0 360])
    %xlabel('Angle (degrees)','FontSize', 18)
    %ylabel('Maximum Amplitude (uV)', 'FontSize', 18)
    %set(gca,'TickDir','out');
    %set(gca, 'XLim', [0 360])
    %set(gca, 'XTick', [0 90 180 270 360], 'FontSize', 13)
    %title('Tuning Curves', 'FontSize', 22)
end
%saveas(gcf, strcat(char(temp(1)), '_TuningCurves.eps'), 'epsc');
%saveas(gcf, strcat(char(temp(1)), '_TuningCurves.jpg'));

end