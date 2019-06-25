%% Export the data as "EPrime text "  -- Uncheck unicode
close all;
clear;
clc
format longg;
format compact;
addpath C:\Users\ramakrs\Documents\MATLAB\OPS_CODES\Read_eprime
%% Inputs
%Run the windows_cmd_for_file_paths.txt
%dir /b /s /a:-D > results.txt
listOfFileNames = textread('E:\OPS\OPS_All_EPrime_files\Emotional_Reactivity\text_file_paths.txt','%s'); 

numberOfFiles = length(listOfFileNames);
%% Output Excel Sheet
xlsfilename = 'E:\OPS\OPS_All_EPrime_files\Emotional_Reactivity\OPS_Emotional_Reactivity_RTTime_Accuracy.xlsx'; 
xlRange = 'A1';
Emotional_Reactivity_stat_xlsx{1,1}  = 'Subject_ID';    
Emotional_Reactivity_stat_xlsx{1,2}  = 'Date';        
Emotional_Reactivity_stat_xlsx{1,3}  = 'Shapes_RTTime'; 
Emotional_Reactivity_stat_xlsx{1,4}  = 'Fear_RTTime'; 
Emotional_Reactivity_stat_xlsx{1,5}  = 'Anger_RTTime'; 
Emotional_Reactivity_stat_xlsx{1,6}  = 'Surprise_RTTime'; 
Emotional_Reactivity_stat_xlsx{1,7}  = 'Neutral_RTTime'; 
Emotional_Reactivity_stat_xlsx{1,8}  = 'Shapes_Accuracy'; 
Emotional_Reactivity_stat_xlsx{1,9}  = 'Fear_Accuracy'; 
Emotional_Reactivity_stat_xlsx{1,10} = 'Anger_Accuracy'; 
Emotional_Reactivity_stat_xlsx{1,11} = 'Surprise_Accuracy'; 
Emotional_Reactivity_stat_xlsx{1,12} = 'Neutral_Accuracy'; 
Emotional_Reactivity_stat_xlsx{1,13} = 'Shapes_Response_Rate';
Emotional_Reactivity_stat_xlsx{1,14} = 'Fear_Response_Rate';
Emotional_Reactivity_stat_xlsx{1,15} = 'Anger_Response_Rate';
Emotional_Reactivity_stat_xlsx{1,16} = 'Surprise_Response_Rate';
Emotional_Reactivity_stat_xlsx{1,17} = 'Neutral_Response_Rate';

Emotional_Reactivity_ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;
for k =  1 : numberOfFiles
       thisFile = listOfFileNames{k};
	fprintf('Processing file %s\n', thisFile);
    Eprime_Emotional_Reactivity_Textfile = thisFile;
    [upperPath, Current_File_name, ~] = fileparts(thisFile);
   
    DATA_Emotional_Reactivity = read_edat_output_2008(thisFile);
    idx = find(~strcmp(DATA_Emotional_Reactivity.Resting_OnsetTime, 'NULL'));
    ScannerOnset =DATA_Emotional_Reactivity.Resting_OnsetTime(idx);
    ScannerOnset = str2double(ScannerOnset(1));
    idx_Shapes   = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Shapes'));
    idx_Fear     = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Fear'));
    idx_Anger    = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Anger'));
    idx_Surprise = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Surprise'));
    idx_Neutral  = find(strcmp(DATA_Emotional_Reactivity.TrialConditionTrial,'Neutral'));
    
    Shapes_Acc   = cellfun(@str2num, DATA_Emotional_Reactivity.ShapesTrialProbe1_ACCTrial(idx_Shapes));
    Fear_Acc     = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Fear));
    Anger_Acc    = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Anger));
    Surprise_Acc = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Surprise));
    Neutral_Acc  = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_ACC(idx_Neutral));
    
    Shapes_RT   = cellfun(@str2num, DATA_Emotional_Reactivity.ShapesTrialProbe1_RTTrial(idx_Shapes));
    Shapes_RT_avg   = mean(Shapes_RT(Shapes_Acc>0)); 
    Fear_RT     = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Fear));
    Fear_RT_avg     = mean(Fear_RT(Fear_Acc>0));
    Anger_RT    = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Anger));
    Anger_RT_avg    = mean(Anger_RT(Anger_Acc>0));
    Surprise_RT = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Surprise));
    Surprise_RT_avg = mean(Surprise_RT(Surprise_Acc>0));
    Neutral_RT  = cellfun(@str2num, DATA_Emotional_Reactivity.FacesProcProbe_RT(idx_Neutral));
    Neutral_RT_avg  = mean(Neutral_RT(Neutral_Acc>0));
    
    
    Shapes_Acc_avg   = mean(Shapes_Acc(Shapes_RT>0)); 
    Fear_Acc_avg     = mean(Fear_Acc(Fear_RT>0));
    Anger_Acc_avg    = mean(Anger_Acc(Anger_RT>0));
    Surprise_Acc_avg = mean(Surprise_Acc(Surprise_RT>0));
    Neutral_Acc_avg  = mean(Neutral_Acc(Neutral_RT>0));
    
    Shapes_Resp_Rate   = length(Shapes_RT(Shapes_RT>0))/length(Shapes_RT); 
    Fear_Resp_Rate     = length(Fear_RT(Fear_RT>0))/length(Fear_RT); 
    Anger_Resp_Rate    = length(Anger_RT(Anger_RT>0))/length(Anger_RT); 
    Surprise_Resp_Rate = length(Surprise_RT(Surprise_RT>0))/length(Surprise_RT); 
    Neutral_Resp_Rate  = length(Neutral_RT(Neutral_RT>0))/length(Neutral_RT); 

    
%% Create Cells to Write to Excel Sheet
% Adjust Parameters to Read Date and Subject ID
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,1} = Current_File_name(1:11); %Subject ID
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,2} = Current_File_name(13:20);%Date
%       Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,1} = Current_Folder_name; %Subject ID
%       Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,2} = PPGdata(1,21:28);    %Date
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,3}  = Shapes_RT_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,4}  = Fear_RT_avg; 
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,5}  = Anger_RT_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,6}  = Surprise_RT_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,7}  = Neutral_RT_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,8}  = Shapes_Acc_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,9}  = Fear_Acc_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,10} = Anger_Acc_avg; 
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,11} = Surprise_Acc_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,12} = Neutral_Acc_avg;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,13} = Shapes_Resp_Rate;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,14} = Fear_Resp_Rate;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,15} = Anger_Resp_Rate;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,16} = Surprise_Resp_Rate;
     Emotional_Reactivity_stat_xlsx{Emotional_Reactivity_ind,17} = Neutral_Resp_Rate;
     
     Emotional_Reactivity_ind = Emotional_Reactivity_ind+1;
     clearvars variables -except k Emotional_Reactivity_stat_xlsx Emotional_Reactivity_ind listOfFileNames numberOfFiles xlRange xlsfilename
end
xlswrite(xlsfilename,Emotional_Reactivity_stat_xlsx,'Emotional_Reactivity',xlRange);