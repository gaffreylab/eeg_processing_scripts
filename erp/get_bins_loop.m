%% Prepare workspace for preprocessing

clear
clc

eeglab

global proj

proj.data_location = 'E:\ern_rest_microstates\processed_eeg_data\ern_data\ern_data_good\';

proj.erp_filenames = dir(fullfile(proj.data_location, '*.erp'));
proj.erp_filenames = {proj.erp_filenames(:).name};


%% Loop over subjects and run get_bins_single_subject.m

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
        summary_info = get_bins_single_subject;
        summary_tab = struct2table(summary_info);
    else
        summary_info = get_bins_single_subject;
        summary_row = struct2table(summary_info); % 1-row table
        summary_tab = vertcat(summary_tab, summary_row); % Append new row to table
    end
end
