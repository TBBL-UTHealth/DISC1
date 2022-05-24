function [magnitude_trials, direction_trials, denoised, index, tuning_matrix_smoothed_Trials,pval_ray, pval_omni]=Func_RV_v3(NeuralData, channels_interest, kept_stdev, binsize, plotflag,plot_colors, gammaflag,date)
% RV takes the magnitude and amplitude from the column based on the
% average waveform, and individual trials
% It also saves the trial number of the data that's within 3*stdev of the
% mean
% -v3 adds the date as an input. Based on it, it automatically selects the
% DISC angle
for j=1:1 %Modify value to choose the column from the channels of interest we will be using for the RV
    [~,~,~, rv_direction, pval_ray, pval_omni]=Func_Tuning_Curves_v3(NeuralData, channels_interest.RV,binsize,plotflag,plot_colors, gammaflag, 1,date);
    position_struct=find([NeuralData.Channel_Number]==channels_interest.RV(1,j));
    if isempty(position_struct)
        temp=isempty(position_struct);
        while temp==1
            j=j+1;
            position_struct=find([NeuralData.Channel_Number]==channels_interest.RV(1,j));
            temp=isempty(position_struct);
        end

    end
    
    direction_trials=zeros(length(NeuralData(position_struct).Directional_Trials_Gamma),1);
    magnitude_trials=zeros(length(NeuralData(position_struct).Directional_Trials_Gamma),1);
    tuning_matrix_smoothed_Trials=zeros(length(NeuralData(position_struct).Directional_Trials_Gamma),(360/binsize)+1);
    for i=1:length(NeuralData(position_struct).Directional_Trials_Gamma)
        if gammaflag==1
            tuning_vector=NeuralData(position_struct).Directional_Trials_Gamma(i,:);
        else
            tuning_vector=NeuralData(position_struct).Directional_Trials_LFP(i,:);
        end
        if sum(isnan(tuning_vector))<=3
            angles=0:binsize:1080;
            %    x_tuning=[5 55 105 155 205 255 305 355 365 415 465 515 565 615 665 715 725 775 825 875 925 975 1025 1075]; % for 2020 recordings
            %      x_tuning =[5 105  205  305  365  465  565  665  725  825  925  1025 ];
            if strcmp(NeuralData(1).Recording_Device_Type, 'DISC')
                if size(channels_interest.RV,2)==8
                    if strcmp(date,'1-11-21') || strcmp(date, '1-13-21') || strcmp(date,'1-15-21')...
                            || strcmp(date, '1-27-21') || strcmp(date, '1-28-21')...
                            || strcmp(date, '11-12-20') || strcmp(date, '03-02-21')
                                x_tuning=[-5 43 91 139 187 235 283 331 355 403 451 499 547 595 643 691 715 763 811 859 907 955 1003 1051]; % DISC angles for 2021 recordings
                    elseif strcmp(date,'8-27-21') || strcmp(date, '9-7-21') || strcmp(date, '9-9-21')
                        x_tuning=[86   131   177   221   263   307   350    28 ...
                            446   491   537   581   623   667   710   388 ...
                            806   851   897   941   983   1027  1070  748]; % DISC angles for 2021 recordings
                    elseif strcmp(date, '9-29-21')|| strcmp(date, '10-05-21')
                        x_tuning = [-20 25 70 115 160 205 250 295 ...
                            340 385 430 475 520 565 610 655 ...
                            700 745 790 835 880 925 970 1015];
                    end
                    
                 
                elseif size(channels_interest.RV,2)==4
                    if strcmp(date,'1-11-21') || strcmp(date, '1-13-21') || strcmp(date,'1-15-21')...
                            || strcmp(date, '1-27-21') || strcmp(date, '1-28-21')...
                            || strcmp(date, '11-12-20') || strcmp(date, '03-02-21')
                        x_tuning=[-5 91 187 283 355 451 547 643 715 811 907 1003]; % DISC angles for 2021 recordings, 4 columns
                    elseif strcmp(date,'8-27-21') || strcmp(date, '9-7-21') || strcmp(date, '9-9-21')
                        x_tuning=[86 177 263 350 446 537 623 710 806  897 983 1070]; % DISC angles for 2021 recordings, 4 columns
                    elseif strcmp(date, '9-29-21') || strcmp(date, '10-05-21')
                        x_tuning = [-20  70  160  250  ...
                            340 430 520 610  ...
                            700 790 880 970 ];
                    end
                end
            else
                if size(channels_interest.RV,2)==8
                    x_tuning=[0 45 90 135 180 225 270 315 360 405 450 495 540 585 630 675 720 765 810 855 900 945 990 1035 ]; % Tetrode angles for 2021 recordings
                elseif size(channels_interest.RV,2)==4
                    x_tuning=[0 90 180 270 360 450 540 630 720 810 900 990 ]; % for tetrodes
                end
            end
            
            % x angles are separated 50 degrees because they are dependent on the DISC angle
            tuning_vector_smoothed=[tuning_vector tuning_vector tuning_vector ]; %  amplitude values
%             tuning_vector_smoothed=interp1(x_tuning, tuning_vector_smoothed,angles, 'pchip');
            tuning_vector_smoothed=interp1(x_tuning, tuning_vector_smoothed,angles, 'linear');

            tuning_vector_smoothed=tuning_vector_smoothed(angles>=360 & angles<=720);
            
            % Resultant vectors
            angles=0:binsize:360;
            
            x=tuning_vector_smoothed.*cosd(angles); % If using tuning_matrix_smoothed, magnitude gets too high
            y=tuning_vector_smoothed.*sind(angles);
            
            x=nansum(x);
            y=nansum(y);
            
            %%% Calculates vector magnitude and direction
            if x>=0 && y>=0
                direction=atand(y/x);
            elseif x<0 && y>=0
                direction=180-atand(y/x);
            elseif x<0 && y<0
                direction=180+atand(y/x);
            elseif x>=0 && y<0
                direction=360+atand(y/x);
            end
            
            magnitude=sqrt((x^2)+(y^2));
            direction_trials(i)=direction;
            magnitude_trials(i)=magnitude;
            tuning_matrix_smoothed_Trials(i,:)=tuning_vector_smoothed;
        else
            direction_trials(i)=NaN;
            magnitude_trials(i)=NaN;
            direction_trials(i,:)=NaN;
            tuning_matrix_smoothed_Trials(i,:)=nan(1,(360/binsize)+1);

        end
    end
    index=isnan(direction_trials);
    direction_trials_denoised=direction_trials;
    direction_trials_denoised(index)=[];
    
    rv_stdev=circ_rad2ang(circ_std(circ_ang2rad(direction_trials_denoised)));
    denoised=min([abs(direction_trials_denoised-rv_direction) abs(rv_direction-(direction_trials_denoised+360)) abs(rv_direction-(direction_trials_denoised-360))],[],2);
    denoised=find(denoised<=kept_stdev*rv_stdev);
    
    %         %%% Use below line to visualize angles, rv direction, distances
    %         %%% difference and minimum value
    %          [direction_trials_denoised repmat(rv_direction,450,1) abs(direction_trials_denoised-rv_direction) abs(rv_direction-(direction_trials_denoised+360))...
    %               abs(rv_direction-(direction_trials_denoised-360))];
    
end
%clear tuning_vector magnitude direction tuning_matrix_smoothed tuning_vector_smoothed tuning_curve x x_tuning angles rv_stdev rv_direction rv_magnitude y

