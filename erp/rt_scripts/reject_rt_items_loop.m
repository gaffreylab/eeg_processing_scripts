%% Prepare workspace for preprocessing

% Clear workspace and command window
clear
clc

eeglab 

global proj % Declare variables as global (variables that you can access in other functions)

% Get file names

proj.data_location = 'E:\new_go_prep\processed_data_new\complete\';
proj.erp_filenames = dir(fullfile(proj.data_location, '*.set'));
proj.erp_filenames = {proj.erp_filenames(:).name};

proj.data_location2 = 'E:\new_go_prep\processed_data_new\rt_rej_items\';
proj.erp_filenames2 = dir(fullfile(proj.data_location2, '*.mat'));
proj.erp_filenames2 = {proj.erp_filenames2(:).name};


%% Loop over subjects and run go_process_single_subject.m

for i = 1:length(proj.erp_filenames)
    proj.currentSub = i;
    proj.currentId = proj.erp_filenames{i};
    
    % Subject ID will be filename up to first space, or up to first '.'
    space_ind = strfind(proj.currentId, '_');
    if ~isempty(space_ind)
        proj.currentId = proj.currentId(1:(space_ind(1)-1)); 
    else
        erp_ind = strfind(proj.currentId, '.set');
        proj.currentId = proj.currentId(1:(erp_ind(1)-1));
    end
    
    if ~exist('summary_tab', 'var')
        summary_info = reject_rt_items;
        summary_tab = struct2table(summary_info);
    else
        summary_info = reject_rt_items;
        summary_row = struct2table(summary_info,'AsArray',true); % 1-row table
        summary_tab = vertcat(summary_tab, summary_row); % Append new row to table
    end
end