%%% Prepare workspace for preprocessing

% Clear workspace and command window
clear
clc

% Start EEGLAB (startup file in MATLAB folder should have already added it to the path)
eeglab

global proj % Declare variables as global (variables that you can access in other functions)

% Path of folder with data
% Data is in .set format
proj.data_location = 'E:\new_go_prep\processed_data_new\complete\';

% Get set file names
proj.set_filenames = dir(fullfile(proj.data_location, '*.set'));
proj.set_filenames = { proj.set_filenames(:).name };

%% Loop over subjects 

for i = 1:length(proj.set_filenames)
    proj.currentSub = i;
    proj.currentId = proj.set_filenames{i};
    
    % Subject ID will be filename up to first underscore, or up to first '.'
    space_ind = strfind(proj.currentId, '_');
    if ~isempty(space_ind)
        proj.currentId = proj.currentId(1:(space_ind(1)-1)); 
    else
        set_ind = strfind(proj.currentId, '.set');
        proj.currentId = proj.currentId(1:(set_ind(1)-1));
    end
    
    if i == 1
        summary_info = get_rej_flags;
        summary_tab = struct2table(summary_info);
    else
        summary_info = get_rej_flags;
        summary_row = struct2table(summary_info); % 1-row table
        summary_tab = vertcat(summary_tab, summary_row); % Append new row to table
    end
       
end
