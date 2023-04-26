% ********************************************************************** %
% Preprocessing Script for ERN ERP Data [Script 1]
% This is specifically for Resting vs. ERP comparisons
% Authors: Armen Bagdasarov & Kenneth Roberts
% Institution: Duke University
% Date created: 2022-04-19
% Date last modified: 2022-04-19
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
proj.data_location = 'E:\new_go_prep\raw_data\';

% Get mff file names
proj.mff_filenames = dir(fullfile(proj.data_location, '*.mff'));
proj.mff_filenames = { proj.mff_filenames(:).name };

% Location for a file to hold error messages for subjects whose processing fails
% proj.error_file = 'E:\new_go_prep\processed_data\logs\';

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
    
    % try % KCR
        if i == 1
            summary_info = go_process_single_subject;
            summary_tab = struct2table(summary_info);
        else
            summary_info = go_process_single_subject;
            summary_row = struct2table(summary_info); % 1-row table
            summary_tab = vertcat(summary_tab, summary_row); % Append new row to table
        end
         
     % catch me % KCR
% Ken - I removed this part of the code because it wasn't working with the ERP data
% Script usually works without this part of the code though
% %        fid = fopen(proj.error_file, 'a');
% %        % At (date) x at time y subject z had error q
% %        fprintf(fid, 'At %s subject %s had error %s\r\n', ...
% %            datestr(now), proj.currentId, me.message);
% %        fprintf(fid, '\tin %s at line %s \r\n', me.stack(end-1).file, num2str(me.stack(end-1).line)); 
% %        fclose(fid);
    % end % KCR

end

%% Write summary info to spreadsheet

proj.output_location = 'E:\new_go_prep\processed_data_new\logs\';

writetable(summary_tab, [proj.output_location filesep 'prep_log.csv']);

% This will overwrite each time
% So, rename if running again 
