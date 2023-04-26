% ********************************************************************** %
% Preprocessing Script for ERN Resting State EEG Data [Script 1]
% Authors: Armen Bagdasarov & Kenneth Roberts
% Institution: Duke University
% ********************************************************************** %

%% Prepare workspace for preprocessing

% Clear workspace and command window
clear
clc

% Start EEGLAB (startup file in MATLAB folder should have already added it to the path)
eeglab

global proj % Declare variables as global (variables that you can access in other functions)

% Path of folder with raw data
% Data is in .mff format
proj.data_location = 'E:\resting_for_ern\eyes_closed\preprocessed_data\raw_data\';

% Get mff file names
proj.mff_filenames = dir(fullfile(proj.data_location, '*.mff'));
proj.mff_filenames = { proj.mff_filenames(:).name };

% Location for a file to hold error messages for subjects whose processing fails
proj.error_file = 'E:\resting_for_ern\eyes_closed\preprocessed_data\processed_new\6_logs\errors.txt';

%% Loop over subjects and run rest_process_single_subject.m

for i = 1:length(proj.mff_filenames)
    proj.currentSub = i;
    proj.currentId = proj.mff_filenames{i};
    
    % Subject ID will be filename up to first space, or up to first '.'
    space_ind = strfind(proj.currentId, ' ');
    if ~isempty(space_ind)
        proj.currentId = proj.currentId(1:(space_ind(1)-1)); 
    else
        mff_ind = strfind(proj.currentId, '.mff');
        proj.currentId = proj.currentId(1:(mff_ind(1)-1));
    end
    
    try
        if i == 1
            summary_info = ern_rest_single_sub;
            summary_tab = struct2table(summary_info);
        else
            summary_info = ern_rest_single_sub;
            summary_row = struct2table(summary_info); % 1-row table
            summary_tab = vertcat(summary_tab, summary_row); % Append new row to table
        end
        
    catch me
       fid = fopen(proj.error_file, 'a');
       % At (date) x at time y subject z had error q
       fprintf(fid, 'At %s subject %s had error %s\r\n', ...
           datestr(now), proj.currentId, me.message);
       fprintf(fid, '\tin %s at line %s \r\n', me.stack(end-1).file, num2str(me.stack(end-1).line)); 
       fclose(fid);
    end
    
end

%% Write summary info to spreadsheet

proj.output_location = 'E:\resting_for_ern\eyes_closed\preprocessed_data\processed_new\6_logs\';
writetable(summary_tab, [proj.output_location filesep 'rest_for_ern_prep_log.csv']);

% This will overwrite each time
% So, rename if running again
