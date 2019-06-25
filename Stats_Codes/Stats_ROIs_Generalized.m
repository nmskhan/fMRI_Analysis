%% Author: Sreekrishna Ramakrishna Pillai
%% Extracts contrast values (or Beta Values) from the contrast maps listed in the SPM.mat given as the input
%% ROI data won't be created if the coordinate lies outside the SPM MASK 
clear;
addpath C:\Users\ramakrs\Documents\spm12;
addpath C:\Users\ramakrs\Documents\spm8\toolbox\marsbar-0.44;
addpath C:\Users\ramakrs\Documents\spm8\toolbox\marsbar-0.44\spm5;
%% This path should contain ROIs(in .mat format) in Folders 
% Folder names should be the ROI group name
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\AAL\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Brodmann\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\ANT\ANT_Alerting\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\ANT\ANT_Executive_Attention\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\ANT\ANT_Orienting\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\MSIT\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Emotional_Reactivity\Emotional_Reactivity_Anger_Neutral\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Emotional_Reactivity\Emotional_Reactivity_Fear_Neutral\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Emotional_Reactivity\Emotional_Reactivity_Surprise_Neutral\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\AXCPT\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\STROOP\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Retaliation\Anticipation\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Retaliation\Retaliation\';
ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\Retaliation\Retaliation_Watching\';
% ROI_PATH = 'C:\Users\ramakrs\Documents\Task_ROIs\MSIT_Test\';

% ROI_PATH = 'C:\Users\ramakrs\Documents\Food_Photo_PBRC\FOOD_ROIs\';

%% Input SPM.mat
des_path = spm_get(1, 'SPM.mat', 'Select SPM.mat');
des = mardo(des_path);  % make mardo design object
load(des_path); % for reading participant names from the ROI
%%
Char_Participant_name = 1:11; % Characters in file name with Participant ID
Char_Date = 17:24;            % Characters in file name with Date
filename = 'OPS_stats_Observing_opponent_High_Low_ROIs_Test.xlsx'; %Output  Filename
xlRange = 'A1';
%% 
topLevelFolder = ROI_PATH;
if topLevelFolder == 0	
    return;    
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames);

for k =  1 : numberOfFolders
    thisFolder = listOfFolderNames{k};
	fprintf('Applying ROIs from %s\n', thisFolder);
    DD = dir([thisFolder, '\*roi.mat']);% Checking if the folder has any roi files
    Num_of_files = length(DD(not([DD.isdir])));
    currentDirectory = thisFolder;
    [upperPath, Current_Folder_name, ~] = fileparts(currentDirectory);
    [upper_to_upperPath, Upper_Folder_name, ~] = fileparts(upperPath);
    if (Num_of_files ~=0) 
               
        roi_files          = spm_get('files', [ROI_PATH Current_Folder_name], '*roi.mat');
        

        rois               = maroi('load_cell', roi_files); % make maroi ROI objects
        

        mY                 = get_marsy(rois{:}, des, 'mean'); % extract data into marsy data object
        

        Stats              = summary_data(mY );  % get summary time course(s)
        

        st                 = y_struct(mY );  % get summary time course(s)
        
        %% Obtaining filename (Participant ID and Date) from file paths
        Image_FilePaths = char(SPM.xY.P);
        [rr, cc] = size(Image_FilePaths);
        Image_File_name  =  cell(rr,1);
        upperPath = cell(rr,1);
        for i = 1:rr
            [upperPath{i}, Image_File_name{i}, ~] = fileparts(Image_FilePaths(i,:));
        end
        Image_File_name_char = char(Image_File_name);

        Participant_IDs = ['Participant_ID'; cellstr(Image_File_name_char(:,Char_Participant_name))];
        Dates = ['Date'; cellstr(Image_File_name_char(:,Char_Date))];
        TimePoint  = ['Time_Point'; cellstr(Image_File_name_char(:,26:31))];
        [r, c]  = size(Stats);
        for i = 1:c
            Stats_xlsx{1,i} =  st.regions{1,i}.name;
        end

        for i = 2:r+1
            for j = 1:c
                Stats_xlsx{i,j} = Stats(i-1,j);
            end
        end
        Stats_xlsx  = [Participant_IDs Dates TimePoint Stats_xlsx];
%         Stats_xlsx  = [Participant_IDs Dates Stats_xlsx];

        xlswrite(filename,Stats_xlsx,Current_Folder_name,xlRange);
        clear roi_files rois mY Stats st Stats_xlsx 
        % xlswrite(filename,SPM.xY.P, 'FilePaths',xlRange);% Adds additional sheet
        % with file paths
    end

end