%% Prepare workspace for preprocessing

% Clear workspace and command window
clear
clc

% Start EEGLAB (startup file in MATLAB folder should have already added it to the path)
eeglab

global proj % Declare variables as global (variables that you can access in other functions)

% Path of folder with raw data
% Data is in .set format
proj.data_location = 'E:\ern_rest_microstates\processed_eeg_data\ern_data\ern_data_good\';

% Get erp file names
proj.erp_filenames = dir(fullfile(proj.data_location, '*.erp'));
proj.erp_filenames = { proj.erp_filenames(:).name };


%% Loop over subjects and run go_process_single_subject.m

for i = 1:length(proj.erp_filenames)
    proj.currentSub = i;
    proj.currentId = proj.erp_filenames{i};
    
    % Subject ID will be filename up to first space, or up to first '.'
    space_ind = strfind(proj.currentId, ' ');
    if ~isempty(space_ind)
        proj.currentId = proj.currentId(1:(space_ind(1)-1)); 
    else
        erp_ind = strfind(proj.currentId, '.erp');
        proj.currentId = proj.currentId(1:(erp_ind(1)-1));
    end
    
    if ~exist('summary_tab', 'var')
        summary_info = go_quantify_single_sub_method_1;
        summary_tab = struct2table(summary_info);
    else
        summary_info = go_quantify_single_sub_method_1;
        summary_row = struct2table(summary_info); % 1-row table
        summary_tab = vertcat(summary_tab, summary_row); % Append new row to table
    end
end

%% Write summary info to spreadsheet

proj.output_location = 'E:\ern_rest_microstates\erp_measurement\';
writetable(summary_tab, [proj.output_location filesep 'erps_method_1.csv']);
