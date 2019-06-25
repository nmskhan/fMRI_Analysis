close all; clear ; clc;
addpath C:\Users\ramakrs\Documents\spm12
format longg;
format compact;
%Run the windows_cmd_for_folder_paths.txt
listOfFolderNames = textread('E:\OPS\SK_Preprocessed\Retaliation\file_paths.txt','%s'); 
numberOfFolders = length(listOfFolderNames);
% Process image files in those folders.

%% Output Excel Sheet
xlsfilename = 'E:\OPS\SK_Preprocessed\Retaliation\Retaliation_Outlier_Percentage.xlsx'; 
xlRange = 'A1';
       

stat_xlsx{1,1} = 'Subject_ID';    
stat_xlsx{1,2} = 'Date';  
stat_xlsx{1,3} = 'Total_Outlier_Percentage'; 
stat_xlsx{1,4} = 'Reaction_Time_Task_Outlier_Percentage';
stat_xlsx{1,5} = 'Smiley_Loss_Outlier_Percentage';
stat_xlsx{1,6} = 'Smiley_Win_Outlier_Percentage';
stat_xlsx{1,7} = 'Anticipation_High_Outlier_Percentage';
stat_xlsx{1,8} = 'Anticipation_Low_Outlier_Percentage';
stat_xlsx{1,9} = 'Retaliation_High_Outlier_Percentage';
stat_xlsx{1,10} = 'Retaliation_Low_Outlier_Percentage';
stat_xlsx{1,11} = 'Watching_Opponent_High_Outlier_Percentage';
stat_xlsx{1,12} = 'Watching_Opponent_Low_Outlier_Percentage';
ind = 2; 
addpath C:\Users\ramakrs\Documents\spm12 ;



for k = 1 : numberOfFolders 
    % Replace this for loop with parfor if using parellel computing tool box - Not installed in cluster Matlab
    % Windows matlab - not connected cluster - Should try once Ram gives Samba access
    % To submit these jobs to cluster - repeat the code outide the loop to in bash script. PBS/torque scheduler
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	cd (thisFolder);

    currentDirectory = pwd;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    
    %%
    if (strcmp(Current_Folder_name,'Task_1') || strcmp(Current_Folder_name,'Task_2')) 
        
        addpath C:\Users\ramakrs\Documents\spm12
        
%% check for folders without art performed
%         art_regression_outliers_and_movement_file = spm_select('List',pwd,'^art_regression_outliers_and_movement'); % OPS and Keely's study - folder names has tags to functional file  
%         if strcmp (art_regression_outliers_and_movement_file,'')
%             fprintf('%s\n', pwd);
%         end
%% OLD
%         load(art_regression_outliers_and_movement_file)
%         load('outliers.mat')
%         [p q] = size(R);
%         len = length(out_idx);
%         movement = (len/p) *100;
%%        
        [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
        [upper_to_upper2Path, Upper2_Folder_name, ~] = fileparts(upper_to_upperPath);

        cd glm
        DD = dir([pwd, '\*SPM_outliers.txt']);% Checking if the folder has any .nii files
        Num_of_files = length(DD(not([DD.isdir])));
        outliers_file = spm_select('List',pwd,'^SPM_outliers');
        if (Num_of_files  ~= 0)
            vals = textread('SPM_outliers.txt','%s'); 
            Total_mov  = vals(21);
            Reaction_Time_Task_mov   = vals(22);
            Smiley_Loss_mov   = vals(23);
            Smiley_Win_mov = vals(24);
            Anticipation_High_mov = vals(25);
            Anticipation_Low_mov = vals(26);
            Retaliation_High_mov = vals(27);
            Retaliation_Low_mov = vals(28);
            Watching_Opponent_High_mov = vals(29);
            Watching_Opponent_Low_mov = vals(30);
       
    
            
            stat_xlsx{ind,1} = Upper2_Folder_name; %Subject ID
            stat_xlsx{ind,2} = Upper_Folder_name;  %Date
            stat_xlsx{ind,3} = cell2mat(Total_mov);
            stat_xlsx{ind,4} = cell2mat(Reaction_Time_Task_mov);
            stat_xlsx{ind,5} = cell2mat(Smiley_Loss_mov);
            stat_xlsx{ind,6} = cell2mat(Smiley_Win_mov);
            stat_xlsx{ind,7} = cell2mat(Anticipation_High_mov);
            stat_xlsx{ind,8} = cell2mat(Anticipation_Low_mov);
            stat_xlsx{ind,9} = cell2mat(Retaliation_High_mov);
            stat_xlsx{ind,10} = cell2mat(Retaliation_Low_mov);
            stat_xlsx{ind,11} = cell2mat(Watching_Opponent_High_mov);
            stat_xlsx{ind,12} = cell2mat(Watching_Opponent_Low_mov);

            ind = ind+1;
        end
%         
        cd ..
    end
end
xlswrite(xlsfilename,stat_xlsx,'ENS',xlRange);