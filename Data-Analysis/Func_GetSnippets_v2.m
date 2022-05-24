function [Snippet, time_snippet, TrialNumbers] = Func_GetSnippets_v2(LFP, pulse_signal, threshold,windowduration, Fsdown)
%UNTITLED Summary of this function goes here
%   LFP 
%   pulse_signal sends the analog or digital value of pulse signals
%   threshold depends on if thes ignal is digital or analog. It give you
%   the max value it will have
%   windowduration is an integer value with time in seconds, it's the time before and after the pulse. 
%       A .200 window would have analysis span from -200 to 200 ms.
%   Fsdown is the downsampled sampling rate
% -v2 added round function on line 24. Previous version was giving us an
% error when running using a window duration of 0.15. Added offset flag
%

offset_flag=0;
%%% Separate Repetitions in Individual trials
temp=(find(pulse_signal>threshold));
MaskPulse=find(diff(temp)>10);
TrialStart=[temp(1) temp(MaskPulse+1)];
if offset_flag==1
    TrialStart=TrialStart+6*Fsdown; % adds a 6 second offset to the data
    temp=find(TrialStart>length(LFP));
    TrialStart(temp)=[];
end
Snippet=zeros(length(TrialStart), int32((windowduration*2)*Fsdown +1));             % this is position of rising edge in board_adc_data
TrialNumbers=zeros(length(TrialStart),1);
for i=1:length(TrialStart)                                                  %error neg/zero value if pulse starts before 200 ms, check plot(Trials_noPulse)
    if TrialStart(i)>1
        temp=[(TrialStart(i)-(windowduration*Fsdown)):TrialStart(i)+((windowduration*Fsdown))];
        temp=round(temp);
        if (min(temp)<0 || max(temp)> length(LFP)) %assign Nan if towards the end
            temp=nan(size(temp,1), size(temp,2));
            TrialNumbers(i)=nan;
            Snippet(i,:)=temp;
        else  % THIS IS THE IMPORTANT PART
            Snippet(i,:)=LFP(temp);
            TrialNumbers(i)=i;
%             base = mean(Snippet(i,1:(size(Snippet(i,:),2)/2)));            
%             Snippet(i,:)=Snippet(i,:)-base;     %  Substract that from the entire snippet
            
            %             %TURN THIS ON IF YOU WANT TO CURATE DATA
            %             figure
            %             plot(Snippet(i,:));
            %             hold on
            %             plot(modSnip)
            %             title({'Trial ' num2str(i)})
            %             prompt = '0 for reject; 1 for keep  ';
            %             x = input(prompt);
            %             if x==0
%                 TrialNumbers(i)=nan;
%             end
%             close all
        end
    else %ignore first point for QC
        temp=[(TrialStart(i)-(windowduration*Fsdown)):TrialStart(i)+((windowduration*Fsdown))];
        temp=nan(size(temp,1), size(temp,2));
        Snippet(i,:)=temp;

        TrialNumbers(i)=nan;

    end
end


time_snippet=(-windowduration:1/Fsdown:windowduration).*1000; %should this be samplingrate or Fsdown

end

